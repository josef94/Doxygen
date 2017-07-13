/*! \file CheckMotion.cpp
    \brief The main file for the pre-processing.
	
	This class is used for the pre-processing of fast and curious on processor core two. It takes the input video and analyse every frame if there was motion between two successive frames. To analyse this, the frames were subtracted from each other and when there is too much difference, the actual frame will be saved. After all 22’500 frames were analysed, the video will be deleted and the process is terminated.
*/

#include <iostream>
#include <stdio.h>
#include <ctime>

#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/videoio.hpp>

using namespace cv;
using namespace std;

    //! A public variable which holds the path for the Frame folder.
    /*!
      This string variable defines the path to the frame folder. This folder is used to save all pictures generated from the class. So, the post-processing class can operate with them.
    */
	string framePath = "/BA/Frames/";
	
	//! A public variable which holds the path for the Video folder.
    /*!
      This string variable defines the path to the video folder. In this folder are all videos saved which have to be processed by this class. Every time, the class starts, it has to take the oldest video from the path and process it.
    */
	string videoPath = "/BA/Videos/";
	
	//! A public variable which holds the specified path to the oldest video in the video path.
    /*!
      This string variable holds the specified video path. The path is handed over by the method and saved to this variable. 
    */
	string video;

	//! A public variable which holds the specified path where the frames must be stored.
    /*!
      This string variable holds the specified frames path. The path is handed over by the method and saved to this variable. This is necessary for the post-processing to know the start date of each video to calculate the specified time stamp of a vehicle driver.
    */
	string frames;

    //! Main function which checks motion of the frames of a video and save it if necessary.
    /*!
      \param argc amount of input arguments.
      \param argv[] path to the video and name of the frames folder.
      \return bool indicates if everything was successful.
    */
int main(int argc, char* argv[]) {

	video = videoPath + argv[1];
	cout << video << endl;
	frames = framePath + argv[2] +"/";
	
	VideoCapture cap(video); // open the default camera
	if (!cap.isOpened()){  // check if we succeeded
		cout << "video not opened" << endl;
		return -1;
	}
	
	int i = 0;
	char file[256];
	Mat pic1, pic2, dif;
	
	cap >> pic1;
	cap >> pic2;
	dif = pic1.clone();
	while(!pic2.empty()&&!pic1.empty()){
		dif = pic1 - pic2;
		
		
		double s = sum(dif)[0];
		if (s > 1000000) {
			sprintf(file, "pic%05i.tif", i);
			imwrite(frames + file, pic1);
		}

		if (i & 1) {
			cap >> pic2;
		}
		else {
			cap >> pic1;
		}
		i++;
	}

	if( remove(video.c_str()) != 0 ) {
    		cout << "Error deleting file" << endl;
  	} 
	else {
    		cout <<  "File successfully deleted" << endl;
	}
	return 0;
}
