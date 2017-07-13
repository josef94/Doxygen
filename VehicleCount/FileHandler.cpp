/*! \file FileHandler.cpp
    \brief The class to handle all file operations.
	
	This class is responsible for the feature vector generation and some calculations referenced to the folders. It handles all files of the post-processing and gains information from the already generated feature vector.
*/
#include "FileHandler.h"

	//! A public variable which holds a counter for the vehicles from right to left.
    /*!
        This integer variable holds the number of vehicles tracked from right to left. This amount is read out from the feature vector every time the VehicleCount starts new.
    */
	int directionCountRight;

	//! A public variable which holds a counter for the vehicles from left to right.
    /*!
      This variable is used as counter and holds the ammount of vehicles tracked from left to right. This amount is read out from the feature vector every time the VehicleCount starts new.
    */
	int directionCountLeft;

///////////////////////////////////////////////////////////////////////////////////////////////////
	//! When this function is called, it saves the actual vehicle with all necessary information to the feature vector.
    /*!
      \param lastLine Counter which holds the last line of the feature vector.
	  \param folder The name of the current folder to calculate the timestamp.
	  \param csvName The name of the feature vector file.
	  \param pictureNumber The picture number necessary to calculate the timestamp.
	  \param pictureCount The amount of relevant pictures.
	  \param direction A bool that indicates the direction left to right or right to left.
	  \param cropName The name of the crop.
	  \param blurName The name of the blur.
	  \param picName The name of the original picture.
	  \param roi A Rectangle with all the information for the current crop. This involves the x, y, width and height.
    */
	void writeCSV(int lastLine, string folder, string csvName, int pictureNumber, int pictureCount, bool direction, string cropName, string blurName, string picName, Rect roi) {
	string limiter = ";\t";
	int index;
	char s[128];
	bool newFile = false;
	ifstream input_stream;
	input_stream.open(csvName.c_str(), ios::in);
	if (!input_stream) {
		newFile = true;
	}

	fstream file;
	file.open(csvName.c_str(), ios::app);
	if (newFile) {
		file << "Index" + limiter + "Timestamp" + limiter + "ReleventPictures" + limiter + "Direction" + limiter + "DirectionCount" + limiter + "CropName" + limiter + "BlurName" + limiter + "PicName" + limiter + "Roi X" + limiter + "Roi Y" + limiter + "Roi Width" + limiter + "Roi Height\n";
	}

	file << intToString(lastLine) + limiter;

	string timestamp = calculateTimestamp(folder, pictureNumber);
	file << timestamp + limiter;
	file << intToString(pictureCount) + limiter;
	if (direction) {
		file << "R" + limiter;
		file << intToString(directionCountRight+1) + limiter;
	}
	else {
		file << "L" + limiter;
		file << intToString(directionCountLeft+1) + limiter;
	}
	file << cropName + limiter;
	file << blurName + limiter;
	file << picName;
	sprintf(s, ";\t%i", roi.x);
	file << s;
	sprintf(s, ";\t%i", roi.y);
	file << s;
	sprintf(s, ";\t%i", roi.width);
	file << s;
	sprintf(s, ";\t%i", roi.height);
	file << s;
	file << ";\n";
	file.close();
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//! When this function is called, it calculates the timestamp from the folder name and the picture number.
    /*!
      \param fold The name of the specified folder.
	  \param picN The number of the specified picture.
	  \return The calculated timestamp as string.
    */
string calculateTimestamp(string fold, int picN) {
	int day, month, year, hour, min, sec;
	int nFps = 25;
	sscanf(fold.c_str(), "%d.%d.%d_%d.%d.%d", &day, &month, &year, &hour, &min, &sec);

	struct tm time = { 0 };
	time.tm_year = year - 1900;
	time.tm_mon = month - 1;
	time.tm_mday = day;
	time.tm_hour = hour-1;
	time.tm_min = min;
	time.tm_sec = sec + picN / nFps;

	char buff[20];
	time_t calculatedTime = mktime(&time);
	
	strftime(buff,20, "%d.%m.%Y %H:%M:%S", localtime(&calculatedTime));

	return buff;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//! When this function is called, it converts a integer to a string and returns it.
    /*!
      \param a The input as integer.
	  \return The output of the integer converted to a string.
    */
string intToString(int a) {
	ostringstream temp;
	temp << a;
	return temp.str();
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//! When this function is called, it calculates the last line of the feature vector file and returns it.
    /*!
      \param filename The Name of the feature vector file.
	  \return The number of the last line as integer.
    */
int getIndexOfLastLine(string filename){
	ifstream input_stream; 
	input_stream.open(filename.c_str(), ios::in);
	string line, lastLine;
	while (getline(input_stream, line)) {
		lastLine = line;
	}
	if (lastLine == "") {
		return 0;
	}
	else {
		line = lastLine;
		if (line.find(";\tL;\t") != string::npos){
			line = line.substr(line.find(";\tL;\t") + 5, line.find(";\tcrop") - 1);
			directionCountLeft = stringToInt(line);
		}
		else if(line.find(";\tR;\t") != string::npos) {
			line = line.substr(line.find(";\tR;\t") + 5, line.find(";\tcrop") - 1);
			directionCountRight = stringToInt(line);
		}
		return stringToInt(lastLine.substr(0, lastLine.find('\t')));
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//! When this function is called, it calculates either the left to right or the right to left direction count from the feature vector file and returns it.
    /*!
      \param filename The Name of the feature vector file.
	  \return The number of the relevant integer value.
    */
void calculateDirectionCount(string filename) {
	ifstream input_stream;
	input_stream.open(filename.c_str(), ios::in);
	string line, lastLine;
	while (getline(input_stream, line)) {
		lastLine = line;

		if (line.find(";\tL;\t") != string::npos) {
			line = line.substr(line.find(";\tL;\t") + 5, line.find(";\tcrop") - 1);
			directionCountLeft = stringToInt(line);
		}

		else if (line.find(";\tR;\t") != string::npos) {
			line = line.substr(line.find(";\tR;\t") + 5, line.find(";\tcrop") - 1);
			directionCountRight = stringToInt(line);
		}
	}
	if (lastLine == "") {
		directionCountLeft = 0;
		directionCountRight = 0;
	}

}

///////////////////////////////////////////////////////////////////////////////////////////////////
//! When this function is called, it converts a string to an integer and returns it.
    /*!
      \param s The input as string.
	  \return The output as integer.
    */
int stringToInt(string s) {
	int integer;
	stringstream ss(s);
	ss >> integer;
	return integer;
}


