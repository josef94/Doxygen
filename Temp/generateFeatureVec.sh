#!/bin/bash

## @file generateFeatureVec.sh
## @brief The script to generate the feature vector.
## @details This script is used to give the command which is necessary to generate the feature vector. It generates a specified folder which gives the command to the handler to generate the feature vector in the download folder.

if [ ! -d /tmp/generateFeatureVec ]
then
  mkdir /tmp/generateFeatureVec
fi
