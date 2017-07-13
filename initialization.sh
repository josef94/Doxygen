
## @file initialization.sh
## @brief The script to initialize all programs and folders.
## @details This script is used to initialize all necessary things to use Fast and Curious. It makes an update and upgrade, generates all folders, install all required software und build all necessary things.
 
#Nach der Installation des Betriebssystemes ausführen

# Reset
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
White='\033[0;37m'        # Whited

############################# Update & Upgrade #############################
echo -e  "$Cyan Update... $OFF"
sudo apt-get -y -q update
echo -e "$Cyan Upgrade... $OFF"
sudo apt-get -y -q upgrade

############################# Ordnerstruktur #############################
echo -e "$Cyan Ordnerstruktur erstellen... $Off"
cd /BA
if [ ! -d /BA/Crops ]
then
  mkdir /BA/Crops
fi

if [ ! -d /BA/Frames ]
then
  mkdir /BA/Frames
fi

if [ ! -d /BA/Videos ]
then
  mkdir /BA/Videos
fi

if [ ! -d /var/www/html/Downloads ]
then
  mkdir /var/www/html/Downloads
fi

if [ ! -d /var/www/html/Downloads/Frames ]
then
  mkdir /var/www/html/Downloads/Frames
fi

############################# OpenCV  #############################
echo -e "$Cyan Installing OpenCV... $OFF"
if ! dpkg --get-selections | grep -q build-essential
then
  echo -e "$Yellow build-essential $OFF"
  sudo apt-get -y -q install build-essential
fi

if ! dpkg --get-selections | grep -q cmake
then
  echo -e "$Yellow cmake $OFF"
  sudo apt-get -y -q install cmake
fi

if ! dpkg --get-selections | grep -q git
then
  echo -e "$Yellow git $OFF"
  sudo apt-get -y -q install git
fi

if ! dpkg --get-selections | grep -q libgtk2.0-dev
then
  echo -e "$Yellow libgtk2.0-dev $OFF"
  sudo apt-get -y -q install libgtk2.0-dev
fi

if ! dpkg --get-selections | grep -q pkg-config
then
  echo -e "$Yellow pkg-config $OFF"
  sudo apt-get -y -q install pkg-config
fi

if ! dpkg --get-selections | grep -q libavcodec-dev
then
  echo -e "$Yellow libavcodec-dev $OFF"
  sudo apt-get -y -q install libavcodec-dev
fi

if ! dpkg --get-selections | grep -q libavformat-dev
then
  echo -e "$Yellow libavformat-dev $OFF"
  sudo apt-get -y -q install libavformat-dev
fi

if ! dpkg --get-selections | grep -q libswscale-dev
then
  echo -e "$Yellow libswscale-dev $OFF"
  sudo apt-get -y -q install libswscale-dev
fi

if ! pkg-config --exists opencv
then
  echo -e "$Yellow OpenCV $OFF"
  if [ ! -d ~/opencv ]
  then
    cd ~/
    git clone https://github.com/josef94/opencv.git
  fi

  if [ -d ~/opencv/build ]
  then
    if [ ! -d ~/opencv/build/CMakeFiles ]
    then
      cd ~/opencv/build
      chmod +x buildOpenCV
      ./buildOpenCV
    fi

    if [[ -d ~/opencv/build/CMakeFiles && ! -f ~/opencv/build/Makefile ]]
    then
      cd ~/opencv/build
      make
    fi

    if [ -f ~/opencv/build/Makefile ]
    then
      cd ~/opencv/build
      sudo make install
      echo -e "$Yellow OpenCV successfully installed $OFF"
    fi
  fi
fi
############################# network-manager #############################
if ! dpkg --get-selections | grep -q zip
then
  echo -e "$Yellow zip $OFF"
  sudo apt-get -y -q install zip
fi

if ! dpkg --get-selections | grep -q network-manager
then 
  echo -e "$Yellow network-manager $OFF"
  sudo apt-get -y -q install network-manager
  sudo systemctl start NetworkManager.service
  sudo systemctl enable NetworkManager.service
else 
  sudo systemctl start NetworkManager.service
  sudo systemctl enable NetworkManager.service
 fi 

############################# avconv #############################
echo -e "$Cyan Installing Avconv... $OFF"
if ! dpkg --get-selections | grep -q libav-tools
then
  echo -e "$Yellow avconv $OFF"
  sudo apt-get -y -q install libav-tools
fi

############################# apache2 #############################
echo -e "$Cyan Installing Apache2... $OFF"
if ! dpkg --get-selections | grep -q apache2
then
  echo -e "$Yellow apache2 $OFF"
  sudo apt-get -y -q install apache2
fi

if ! dpkg --get-selections | grep -q libapache2-mod-php7.0
then
  echo -e "$Yellow libapache2-mod-php7 $OFF"
  sudo apt-get -y -q install libapache2-mod-php7.0 
fi

if dpkg --get-selections | grep -q apache2
then
  echo -e "$Yellow restarting apache2 $OFF"
  sudo systemctl daemon-reload
  sudo /etc/init.d/apache2 restart 2>&1 >/dev/null
fi

############################# mjpg-streamer #############################
echo -e "$Cyan Installing Mjpg-streamer... $OFF"
if ! dpkg --get-selections | grep -q libjpeg-dev
then
  echo -e "$Yellow libjpeg-dev $OFF"
  sudo apt-get -y -q install libjpeg-dev
fi

if ! dpkg --get-selections | grep -q imagemagick
then
  echo -e "$Yellow imagemagick $OFF"
  sudo apt-get -y -q install imagemagick
fi

if ! dpkg --get-selections | grep -q subversion
then
  echo -e "$Yellow subversion $OFF"
  sudo apt-get -y -q install subversion
fi

if ! dpkg --get-selections | grep -q libv4l-dev
then
  echo -e "$Yellow libv4l-dev $OFF"
  sudo apt-get -y -q install libv4l-dev
fi

if ! dpkg --get-selections | grep -q checkinstall
then
  echo -e "$Yellow checkinstall $OFF"
  sudo apt-get -y -q install checkinstall
fi

if ! which mjpg_streamer 2>&1 >/dev/null
then
  echo -e "$Yellow mjpg-streamer $OFF"
  if [ ! -d ~/mjpg-streamer ]
  then
    cd ~
    svn co svn://svn.code.sf.net/p/mjpg-streamer/code/ mjpg-streamer
  fi

  if [ -d ~/mjpg-streamer/mjpg-streamer ]
  then
    cd ~/mjpg-streamer/mjpg-streamer
    make USE_LIBV4L2=true
    sudo make install
    echo -e "$Yellow Mjpg-streamer successfully installed $OFF"
  fi
fi

############################# Temp #############################
echo -e "$Cyan Temp moves... $OFF"
if [ -d /BA/Temp ]
then
  if [ -f /BA/Temp/rc.local ]
  then
    mv /BA/Temp/rc.local /etc
  fi

  if [ -f /BA/Temp/index.php ]
  then
    mv /BA/Temp/index.php /var/www/html
  fi
  
  if [ -f /var/www/html/index.html ]
  then
    rm /var/www/html/index.html
  fi

  if [ -f /BA/Temp/startStream.sh ]
  then
   mv /BA/Temp/startStream.sh /var/www/html
    chmod +x /var/www/html/startStream.sh
  fi
  
  if [ -f /BA/Temp/startVideo.sh ]
  then
   mv /BA/Temp/startVideo.sh /var/www/html
    chmod +x /var/www/html/startVideo.sh
  fi
  
  if [ -f /BA/Temp/generateCrops.sh ]
  then
   mv /BA/Temp/generateCrops.sh /var/www/html
    chmod +x /var/www/html/generateCrops.sh
  fi
  
  if [ -f /BA/Temp/deleteFrames.sh ]
  then
   mv /BA/Temp/deleteFrames.sh /var/www/html
    chmod +x /var/www/html/deleteFrames.sh
  fi
  
  if [ -f /BA/Temp/generateFeatureVec.sh ]
  then
   mv /BA/Temp/generateFeatureVec.sh /var/www/html
    chmod +x /var/www/html/generateFeatureVec.sh
  fi

  if [ -f /BA/Temp/temperatures.csv ]
  then
   mv /BA/Temp/temperatures.csv /var/www/html
  fi

  if [ -f /BA/Temp/temperature.php ]
  then
    mv /BA/Temp/temperature.php /var/www/html
  fi

  if [ -d /BA/Temp ]
  then 
    wget http://dygraphs.com/2.0.0/dygraph.js
    mv dygraph.js /var/www/html
    wget http://dygraphs.com/2.0.0/dygraph.css
    mv dygraph.css /var/www/html
  fi

  if [ -d /BA/Temp ]
  then
    rmdir /BA/Temp
  fi
fi


############################# Make all #############################
echo -e "$Cyan Make all... $OFF"
if [ -d /BA/CheckMotion/Release ]
then
  cd /BA/CheckMotion/Release
  if [ ! -d /BA/CheckMotion/Release/CMakeFiles ]
  then
    cmake .
  fi

  if [ -d /BA/CheckMotion/Release/CMakeFiles ]
  then
    make clean
    make all
  fi
fi

if [ -d /BA/VehicleCount/Release ]
then
  cd /BA/VehicleCount/Release
  if [ ! -d /BA/VehicleCount/Release/CMakeFiles ]
  then
    cmake .
  fi

  if [ -d /BA/VehicleCount/Release/CMakeFiles ]
  then
    make clean
    make all
  fi
fi

############################# chmod  #############################
echo -e "$Cyan chmod... $OFF"
if [ -f /BA/MakeVideo/makeVideo.sh ]
then
  chmod +x /BA/MakeVideo/makeVideo.sh
fi

if [ -f /BA/Handler/Release/handler.sh ]
then
  chmod +x /BA/Handler/Release/handler.sh
fi

if [ -f /BA/Handler/Release/settings.sh ]
then
  chmod +x /BA/Handler/Release/settings.sh
fi

if [ -f /BA/Handler/Release/temperature.sh ]
then
  chmod +x /BA/Handler/Release/temperature.sh
fi

if [ -f /BA/WLAN/WLANSettings.sh ]
then 
  chmod +x /BA/WLAN/WLANSettings.sh
fi

echo -e "$Green Finished $OFF"
