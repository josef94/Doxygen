#!/bin/bash

## @file startVideo.sh
## @brief The script to start the video.
## @details This script is used to give the command which is necessary to start the video. It generates a specified folder which gives the command to the handler to start the video.

if [ ! -d /tmp/videoStart ]
then
  mkdir /tmp/videoStart
fi