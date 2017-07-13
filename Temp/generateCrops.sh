#!/bin/bash

## @file generateCrops.sh
## @brief The script to generate the zip folder.
## @details This script is used to give the command which is necessary to generate the crops folder. It generates a specified folder which gives the command to the handler to generate a zip folder of all crops, blurs and original pictures and save them to the download folder.

if [ ! -d /tmp/zipCrops ]
then
  mkdir /tmp/zipCrops
fi