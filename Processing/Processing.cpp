/*! \file Processing.cpp
    \brief The main file for all processing Methods.
	
	This class is not used on the NanoPi of fast and curious. But it involves all methods explained in chapter 9.4 in the documentation. Because of this, it is also part of the doxygen documentation.
*/

#include <stdio.h>
#include <iostream>

#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace cv;
using namespace std;

//! This function is used to remove the shadow of a blur picture. The result is stored in the picture named ShadowRemoved.jpg.
    /*!
      \param path The path to the actual picture.
	  \return A number dependent of the result.
    */
int removeShadow(string path) {
	int length1 = 0;
	int length2 = 0;
	int count = 0;
	bool first = true;
	bool second = false;
	bool stillWhite = false;
	bool messurePixel = true;
	// Open another image
	Mat image, image2;
	image = imread(path, IMREAD_GRAYSCALE);
	image2 = imread(path);
	int pixelThresh = 25;
	int minLength = 20;
	int pixelL1, pixelL2, pixelLastBlack = 0;

	int pixVal1 = 0;
	int pixVal2 = 0;

	if (!image.data) // Check for invalid input
	{
		cout << "Could not open or find the image" << std::endl;
		return -1;
	}

	// Iterate through pixels.
	for (int r = 150; r < image.rows; r++)
		//for (int r = image.rows - 1; r > 0; r--)
	{
		for (int c = 0; c < image.cols; c++)
		{
			int pixel = image.at<uchar>(r, c);
			if (pixel < (pixelLastBlack + pixelThresh)) {
				//still Black and increase one px
				stillWhite = false;
				pixelLastBlack = pixel;
				//if White is longer than minLength
				if (length1 > minLength) {
					first = false;
					second = true;
					messurePixel = true;
				}

				//if White is longer than minLength
				else if (length2 > minLength) {
					second = false;
				}

			}

			else if (pixel > (pixelLastBlack + pixelThresh) && first == true) {
				pixVal1 += pixel;
				if (messurePixel == true) {
					pixelL1 = pixel;
					length1 = 1;
					messurePixel = false;
				}

				else {
					if (abs((pixVal1 / (length1 + 1)) - pixel) < 25) {
						length1++;
					}
				}
				stillWhite = true;
			}

			else if (pixel > (pixelLastBlack + pixelThresh) && second == true) {
				pixVal2 += pixel;
				if (messurePixel == true) {
					pixelL2 = pixel;
					length2 = 1;
					messurePixel = false;
				}
				else {
					if (abs((pixVal2 / (length2 + 1)) - pixel) < 25) {
						length2++;
					}
					else {
						messurePixel = true;
					}
				}
				stillWhite = true;
			}
		}
		if (length1 > minLength && length2 > minLength) {
			if (abs(length1 - length2) <= 20) {
				count++;
			}
			else {
				count = 0;
			}
			if (count == 10) {
				Rect roi;
				roi.x = 0;
				roi.y = 0;
				roi.width = image.cols;
				roi.height = r - 5;
				Mat crop = image2(roi);
				imwrite("ShadowRemoved.jpg", crop);
				waitKey();
				return 0;
			}
		}
		length1 = 0;
		length2 = 0;

		pixVal1 = 0;
		pixVal2 = 0;
		pixelLastBlack = 0;
		first = true;
		second = false;
		messurePixel = true;
	}

	waitKey(0);
	return 0;
}

//! This function is used to separate the main object from the background. The result is stored in the picture named Grabcut.jpg.
    /*!
      \param path The path to the actual picture.
	  \return A number dependent of the result.
    */
int grabcut(string path) {
	Mat image, result, bgModel, fgModel;
	image = imread(path);

	if (!image.data) {
		cout << "Could not open or find the image" << endl;
		return -1;
	}

	int border = 5;
	int border2 = border + border;
	Rect rect(border, border, image.cols - border2, image.rows - border2);

	grabCut(image, result, rect, bgModel, fgModel, 2, GC_INIT_WITH_RECT);
	compare(result, GC_PR_FGD, result, CMP_EQ);

	Mat foreground(image.size(), CV_8UC3, Scalar(0, 0, 0));
	image.copyTo(foreground, result);
	
	imwrite("Grabcut.jpg", foreground);

	waitKey();
	return 0;
}

//! This function is used to cluster the colours of the picture in only a few different colours. It first uses the algorithm grabcut before the actual methods is running. The result is stored in the picture named KMeans.jpg.
    /*!
      \param path The path to the actual picture.
	  \param clusterCount The amount different colours after the algorithm.
	  \return A number dependent of the result.
    */
int kMeans(String path, int clusterCount) {
	Mat image, result, bgModel, fgModel;
	image = imread(path);

	if (!image.data) {
		cout << "Could not open or find the image" << endl;
		return -1;
	}

	int border = 5;
	int border2 = border + border;
	Rect rect(border, border, image.cols - border2, image.rows - border2);

	grabCut(image, result, rect, bgModel, fgModel, 2, GC_INIT_WITH_RECT);
	compare(result, GC_PR_FGD, result, CMP_EQ);

	Mat foreground(image.size(), CV_8UC3, Scalar(0, 0, 0));
	image.copyTo(foreground, result);

	Mat src = foreground;

	Mat samples(src.rows * src.cols, 3, CV_32F);
	for (int y = 0; y < src.rows; y++)
		for (int x = 0; x < src.cols; x++)
			for (int z = 0; z < 3; z++)
				samples.at<float>(y + x*src.rows, z) = src.at<Vec3b>(y, x)[z];


	Mat labels;
	int attempts = 5;
	Mat centers;
	kmeans(samples, clusterCount, labels, TermCriteria(CV_TERMCRIT_ITER | CV_TERMCRIT_EPS, 10000, 0.0001), attempts, KMEANS_PP_CENTERS, centers);


	Mat new_image(src.size(), src.type());
	for (int y = 0; y < src.rows; y++)
		for (int x = 0; x < src.cols; x++)
		{
			int cluster_idx = labels.at<int>(y + x*src.rows, 0);
			new_image.at<Vec3b>(y, x)[0] = centers.at<float>(cluster_idx, 0);
			new_image.at<Vec3b>(y, x)[1] = centers.at<float>(cluster_idx, 1);
			new_image.at<Vec3b>(y, x)[2] = centers.at<float>(cluster_idx, 2);
		}
	imwrite("KMeans.jpg", new_image);
	waitKey(0);
	return 0;
}

//! This function is used to categorize a picture with the number of relevant pixels. The number of pixels is handed back with this function. After this, with a threshold is it possible to find out what kind of vehicle driver is recognized on the picture.
    /*!
      \param path The path to the actual picture.
	  \return A number which shows the number of pixels.
    */
int categorize(string path) {
	vector<String> filenames;

	Mat image, result, bgModel, fgModel;
	string pathT = path;
	char file[256];

	glob(pathT, filenames, false);
	size_t k = 0;

	if (filenames.size() == 0) {
		return(0);
	}

	while (k < filenames.size()) {

		image = imread(filenames[k]);

		int area = image.total();

		if (!image.data) {
			cout << "Could not open or find the image" << endl;
			return -1;
		}

		int border = 2;
		int border2 = border + border;
		Rect rect(border, border, image.cols - border2, image.rows - border2);
		grabCut(image, result, rect, bgModel, fgModel, 2, GC_INIT_WITH_RECT);
		compare(result, GC_PR_FGD, result, CMP_EQ);
		int z = result.total();

		int count_white = countNonZero(result);
		return count_white;
	}
}

//! This function is used to calculate the speed of a vehicle driver on the picture. It is necessary to hand in a generated picture of a crop to calculate the velocity.
    /*!
      \param path The path to the actual picture.
	  \return A number which shows the covered distance between two frames.
    */
int velocity(string path) {
	vector<String> filenames;

	Mat image, result, bgModel, fgModel;
	string pathT = path;
	char file[256];

	glob(pathT, filenames, false);
	size_t k = 0;

	if (filenames.size() == 0) {
		return 0;
	}

	while (k < filenames.size()) {

		image = imread(filenames[k]);

		int area = image.total();

		if (!image.data) {
			cout << "Could not open or find the image" << endl;
			return -1;
		}

		int border = 2;
		int border2 = border + border;
		Rect rect(border, border, image.cols - border2, image.rows - border2);
		grabCut(image, result, rect, bgModel, fgModel, 2, GC_INIT_WITH_RECT);
		compare(result, GC_PR_FGD, result, CMP_EQ);
		int z = result.total();

		int half = image.rows / 2;
		int pixel = 0;
		int pix, blackRight = 0, blackLeft = 0;
		bool changed = false;
		for (int c = 0; c < image.cols; c++) {
			pixel = result.at<uchar>(half, c);
			if (pixel == 0 && changed == false) {
				blackLeft++;
			}
			else if (changed = true && pixel == 0) {
				blackRight++;
			}
			else {
				changed = true;
			}
		}
		pix = max(blackLeft, blackRight);
		double pixPerSec = pix / 0.04;
		return pixPerSec;
	}
}