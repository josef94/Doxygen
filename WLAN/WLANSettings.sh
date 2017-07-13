#Wird zum verbindne in ein WLAN Netzwerk verwendet.
#WICHTIG: in /etc/network/interfaces den Namen anpassen 

## @file WLANSettings.sh
## @brief The script to initialize the WLAN settings.
## @details This script is used to initialize all WLAN settings. It involves the SSID and password.

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


echo -e "$Cyan WLAN Connection $OFF"
sudo ifconfig -a
sudo nmcli r wifi on
sudo nmcli dev wifi
sudo nmcli dev wifi connect HUAWEI password josef123

echo -e "$Green WLAN Connected $OFF" 
