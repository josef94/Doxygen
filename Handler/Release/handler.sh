#!/bin/bash

## @file handler.sh
## @brief The main script which handles everything on the NanoPi.
## @details This script is the main script of Fast and Curious and handles all other processes. It starts when the NanoPi is started up and runs the whole time. This script checks if the other processes, like the pre-process and the post-process are still running and starts them, if they are not busy. It also handles every user input from the website and the logic, that the videos only starts from 5 am to 9 pm. 

# Reset
OFF='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

#für While Schleife
## @var duration
## @brief A public variable which holds an amount of time.
## @details This variable was used to test the program and let the main loop only runs for 10 minutes. It is not used anymore.  
declare duration=600;

# @var end
# @brief A public variable which holds the end time.
# @details This variable was used for the end time of 10 minutes. It is not used anymore.
#declare	end=$((SECONDS + $duration));

#für Zeitsteuerung in UTC!!

# 03:00:00 - 19:00:00 UTC -> 05:00:00 - 21:00:00 Local Time
## @var startTime
## @brief A public variable which holds the start time of the video.
## @details This variable is used to set the start time for the main process. Videos will only be recorded after this time. The number begins with a 9 to reduce integer problems. After that, the time is shown in UTC. In this case it means 030000 UTC as 05:00:00 local time.
declare startTime="9030000";

## @var endTime
## @brief A public variable which holds the end time of the video.
## @details This variable is used to set the end time for the main process. Videos will only be recorded before this time. The number begins with a 9 to reduce integer problems. After that, the time is shown in UTC. In this case it means 190000 UTC as 21:00:00 local time.
declare endTime="9190000";

## @var isRunningVideo
## @brief A public variable which holds a Boolean that indicates if the video is running right now.
## @details This variable is used to know if a video is currently running. If it is running, the pre-process must wait until more than one videos are in the video folder. This is necessary to ensure, that the video is finished before the next process starts with it. When no video is running, the pre-process can start the video even if there is only one video in the folder.
declare isRunningVideo=false;

while [ 1 ]
do
  if [ -d /tmp/videoStart ]
  then
    if [ `pidof mjpg_streamer` > "0" ]
    then
      pkill mjpg_streamer
      sleep 5
    fi

    if [[ ! "$((`date +"9%H%M%S"`))" < "$startTime" && ! "$((`date +"9%H%M%S"`))" > "$endTime" ]]
    then
      isRunningVideo=true;
      if [ `pidof avconv` > "0" ]
      then
        echo -e "$Yellow Video is running $OFF"
      else
        echo -e "$Cyan Start MakeVideo: .. $OFF"
        /BA/MakeVideo/./makeVideo.sh
        sleep 5
      fi

    else
      echo -e "$Red NOT ready for MakeVideo $OFF"
      isRunningVideo=false;
    fi

    if [[ `find /BA/Videos/* -maxdepth 0 -type f | wc -l` -gt "1" || ( "$isRunningVideo" = false && `pidof avconv` < "1" ) ]]
    then
      if [ `find /BA/Videos -prune -empty` ]
      then
        echo -e "$Red No Videos left $OFF"
      else
        firstVideo=$(ls /BA/Videos/ -tr | head -n 1)
        firstPath=${firstVideo:0:19}
        if [ `pidof CheckMotion` > "0" ]
        then
          echo -e "$Yellow CheckMotion running $OFF"
        else
          echo -e "$Cyan Start CheckMotion: $firstVideo $OFF"
          mkdir /BA/Frames/$firstPath
		  sudo taskset 6 /BA/CheckMotion/Release/./CheckMotion $firstVideo $firstPath &
	      sleep 2
        fi
      fi
    else
      echo -e "$Red NOT ready for CheckMotion $OFF"
    fi

    if [[ `find /BA/Frames/* -maxdepth 0 -type d | wc -l` -gt "1" || ( "$isRunningVideo" = false && `pidof CheckMotion` < "1" ) ]]
    then
      if [ `find /BA/Frames -prune -empty` ]
      then
        echo -e "$Red No Videos left $OFF"
      else
        if [ `pidof VehicleCount` > "0" ]
        then
          echo -e "$Yellow VehicleCount is running $OFF"
        else
          echo -e "$Cyan VehicleCount started: $folderPath $OFF"
		  folderPath=$(ls /BA/Frames/ -tr | head -n 1)
          sudo taskset 8 /BA/VehicleCount/Release/./VehicleCount $folderPath &
        fi
      fi
    else
      echo -e "$Red NOT ready for VehicleCount $OFF"
    fi
    echo -e "$Purple ------------------------------------------- -__- $OFF"
  else
    if [ `pidof avconv` > "0" ]
    then
     pkill avconv
     sleep 5
    fi
    export LD_LIBRARY_PATH=/usr/local/lib
    mjpg_streamer -i "input_uvc.so -d /dev/video0" -o "output_http.so -p 8080 -w /usr/local/www" &
  fi
  if [ -d /tmp/zipCrops ]
  then
    rmdir /tmp/zipCrops
    zip -r /var/www/html/Downloads/Crops.zip /BA/Crops
  fi

  if [ -d /tmp/generateFeatureVec ]
  then
    rmdir /tmp/generateFeatureVec
    cp /BA/FeatureVec.csv /var/www/html/Downloads
  fi
  
  if [ -d /tmp/deleteFrames ]
  then
    rmdir /tmp/deleteFrames
	rm -r /var/www/html/Downloads/Frames
	mkdir /var/www/html/Downloads/Frames
  fi

  sleep 2
done

exit 0