#!/bin/bash

## @file settings.sh
## @brief The script to start the video stream which is shown on the website.
## @details This script is used to start the video stream with the necessary settings for the mjpg-streamer. This is important to set the right output and device for the camera.

## @var LD_LIBRARY_PATH
## @brief The library path export for the mjpg-streamer.
## @details This export library path must be set right before the program mjpg-streamer is called to ensure, that the program works correctly.
declare LD_LIBRARY_PATH=/usr/local/lib;

if [ ! -d /tmp/videoStart ]
then
   export LD_LIBRARY_PATH=/usr/local/lib
   mjpg_streamer -i "input_uvc.so -d /dev/video0" -o "output_http.so -p 8080 -w /usr/local/www" &
fi
