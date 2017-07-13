#!/bin/bash

## @file startStream.sh
## @brief The script to start the video stream.
## @details This script is used to give the command which is necessary to stat the video stream. It generates a specified folder which gives the command to the handler to start the video stream.

if [ -d /tmp/videoStart ]
then
  rmdir /tmp/videoStart
fi
