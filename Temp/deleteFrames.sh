#!/bin/bash

## @file deleteFrames.sh
## @brief The script to delete the frames folder.
## @details This script was used to give the command which was necessary to delete the frames folder. It generated a specified folder which gave the command to the handler to delete the frames folder.

if [ ! -d /tmp/deleteFrames ]
then
  mkdir /tmp/deleteFrames
fi