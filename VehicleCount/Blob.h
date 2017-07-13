#pragma once
// Blob.h
/*! \file Blob.h
    \brief The header file for the Blob.
	
	This file is used to define all methods and namespaces for the Blob.cpp class.
*/
#ifndef MY_BLOB

 //! A definition of the header file Blob.h
    /*!
      To prevent multiple definition, there is a definition of the header file Blob.h.
    */
#define MY_BLOB

#include<opencv2/core/core.hpp>
#include<opencv2/highgui/highgui.hpp>
#include<opencv2/imgproc/imgproc.hpp>

using namespace std;
using namespace cv;

///////////////////////////////////////////////////////////////////////////////////////////////////
class Blob {
public:
	vector<Point> currentContour;
	Rect currentBoundingRect;
	vector<Point> centerPositions;
	double dblCurrentDiagonalSize;
	double dblCurrentAspectRatio;
	bool blnCurrentMatchFoundOrNewBlob;
	bool blnStillBeingTracked;
	int intNumOfConsecutiveFramesWithoutAMatch;
	Point predictedNextPosition;

	// function prototypes ////////////////////////////////////////////////////////////////////////
	Blob(vector<Point> _contour);
	void predictNextPosition(void);

};

#endif    // MY_BLOB


