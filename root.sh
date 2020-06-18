#!/bin/bash

if [ ! $(id -u) -eq 0 ]; then
	echo "Please run the script as root user!"
	exit
fi

echo -e '\033[0;32m\nWe will add a user called "scp", please set a strong password...\n\033[0m\n'
adduser --gecos "" scp

echo -e "\033[0;32mEnabling linger for user scp...\033[0m\n"
loginctl enable-linger scp

echo -e "\033[0;32mInstalling basic tools...\033[0m\n"
apt install build-essential git python3-dev python3-venv vim -y

echo -e "\033[0;32mInstalling dependencies...\033[0m\n"
apt install caffe-cpu fonts-arphic-gkai00mp fonts-freefont-ttf libzbar0 opencc tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-chi-tra -y
sed -i 's/skimage.img_as_float(skimage.io.imread(filename, as_grey=not color))/skimage.img_as_float(skimage.io.imread(filename, as_gray=not color, plugin="pil"))/g' /usr/lib/python3/dist-packages/caffe/io.py

echo -e "\033[0;32mDone!\033[0m\n"
