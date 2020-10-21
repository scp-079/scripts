#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"

# Check root status
if [ ! "$(id -u)" -eq 0 ]; then
    echo -e "\n${RED}Please run the script as root user!${NOCOLOR}\n"
    exit
fi

# Add user "scp"
echo -e "\nWe will add a user called ${YELLOW}scp${NOCOLOR}, please set a strong password...\n"
adduser --gecos "" scp

# Enable systemd linger
echo -e "\n${GREEN}Enabling linger for user scp...${NOCOLOR}\n"
loginctl enable-linger scp

# Install build tools
echo -e "${GREEN}Installing basic tools...${NOCOLOR}\n"
apt update
apt install build-essential git python3-dev python3-venv vim -y

# Install dependencies
echo -e "\n${GREEN}Installing dependencies...${NOCOLOR}\n"
apt install caffe-cpu fonts-arphic-gkai00mp fonts-freefont-ttf libzbar0 opencc tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-chi-tra -y

# Fix bug
sed -i 's/skimage.img_as_float(skimage.io.imread(filename, as_grey=not color))/skimage.img_as_float(skimage.io.imread(filename, as_gray=not color, plugin="pil"))/g' /usr/lib/python3/dist-packages/caffe/io.py

# Install google re2
cd ~ || exit
git clone https://github.com/google/re2.git
cd re2 || exit
make
make test
make install
make testinstall
ldconfig

# Set timezone
echo -e "\n${GREEN}Setting time zone to UTC...${NOCOLOR}"
echo "Etc/UTC" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# Enable journal storage persistence
mkdir -p /var/log/journal
sed -i 's/#Storage=auto/Storage=persistent/g' /etc/systemd/journald.conf
systemctl restart systemd-journald

echo -e "${GREEN}Done!${NOCOLOR}\n"
