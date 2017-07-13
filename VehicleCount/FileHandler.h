#pragma once
//FileHandler.h
/*! \file FileHandler.h
    \brief The header file for the FileHandler.
	
	This file is used to define all methods and namespaces for the FileHandler.cpp class.
*/
#ifndef MY_FILEHANDLER

 //! A definition of the header file FileHandler.h
    /*!
      To prevent multiple definition, there is a definition of the header file FileHandler.h.
    */
#define MY_FILEHANDLER

#include<fstream> 
#include<iostream>
#include <ctime>
#include <time.h>
#include <vector>

#include<opencv2/core/core.hpp>
#include<opencv2/highgui/highgui.hpp>
#include<opencv2/imgproc/imgproc.hpp>

using namespace std;
using namespace cv;

void writeCSV(int countIndex, string folder, string csvName, int pictureNumber, int picureCount, bool direction, string cropName, string blurName, string picName, Rect roi);
string calculateTimestamp(string fold, int picN);
string intToString(int a);
int getIndexOfLastLine(string filename);
void calculateDirectionCount(string filename);
int stringToInt(string s);

#endif