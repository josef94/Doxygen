#!/bin/sh

## @file temperature.sh
## @brief The script to handle the core temperature.
## @details This script is used to handle the actual core temperature. It reads the core temperature and a timestamp every 60 seconds and store both arguments in a file named temperatures.csv. This file is used from the website to display a temperature diagram over the whole time since the NanoPi has been started.

while [ 1 ]
do
 
## @var value
## @brief A public variable which holds the actual core temperature.
## @details This variable is used to store the actual core temperature. The process reads the temperature every 60 seconds and saves it in the variable. 
declare value=$(cat /sys/class/thermal/thermal_zone0/temp);
  
## @var d1
## @brief A public variable which holds the actual date.
## @details This variable is used to know the actual date to generate the temperatures.csv file. Without this variable, it is not possible to know, when a day changes, which is necessary to know for the temperature diagram of the website.
declare d1=`date +%Y/%m/%d`

## @var d2
## @brief A public variable which holds the actual time.
## @details This variable is used to know the actual time to generate the temperatures.csv file. Without this variable, it is not possible to know, what time it is, which is necessary to know for the temperature diagram of the website.
declare d2=`date +%H:%M:%S`
  
  echo "$d1 $d2, $value" >> /var/www/html/temperatures.csv
  sleep 60
done
exit 0

