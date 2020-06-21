#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"

if [ ! "$(id -u)" -eq 0 ]; then
	echo -e "\n${RED}Please run the script as root user!${NOCOLOR}\n"
	exit
fi

echo -e "\nWe will add a user called ${YELLOW}scp${NOCOLOR}, please set a strong password...\n"
adduser --gecos "" scp

echo -e "\n${GREEN}Enabling linger for user scp...${NOCOLOR}\n"
loginctl enable-linger scp

echo -e "${GREEN}Installing basic tools...${NOCOLOR}\n"
apt update
apt install build-essential git python3-dev python3-venv vim -y

echo -e "\n${GREEN}Installing dependencies...${NOCOLOR}\n"
apt install caffe-cpu fonts-arphic-gkai00mp fonts-freefont-ttf libzbar0 opencc tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-chi-tra -y
sed -i 's/skimage.img_as_float(skimage.io.imread(filename, as_grey=not color))/skimage.img_as_float(skimage.io.imread(filename, as_gray=not color, plugin="pil"))/g' /usr/lib/python3/dist-packages/caffe/io.py

echo -e "\n${GREEN}Setting time zone to UTC...${NOCOLOR}"
echo "Etc/UTC" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

echo -e "${GREEN}Done!${NOCOLOR}\n"
