dab-rpi SD-card image
=====================
The dab-rpi SD-card image enables you to listen DAB and DAB+ radio with a Raspberry Pi 2 or 3.

**Warning: At the moment dab-rpi and the Raspberry image are in an early development stage! Usage at your own risk!**

![dab-rpi Screenshot](/pictures/dab-rpi.jpg?raw=true)

Table of contents
====

  * [Description](#description)
  * [Usage of the Raspberry image](#usage-of-the-raspberry-image)
    * [Hardware requirements](#hardware-requirements)
    * [Download](#download)
    * [Installation](#installation)
    * [Usage](#usage)
    * [Input sources](#input-sources)
    * [Power supply issues](#power-supply-issues)
    * [Troubleshooting](#troubleshooting)
  * [Create your own Raspberry image](#create-your-own-raspberry-image)
  * [dab-rpi and QT cross compiling](#dab-rpi-and-qt-cross-compiling)

Description
====
dab-rpi is based on [SDR-J](http://www.sdr-j.tk/) by Jan van Katwijk. You can find the original code here: https://github.com/JvanKatwijk/dab-rpi

At the moment the nice GUI that is presented here is not included on the official version. But it is planned to added the GUI to the official version. You find the fork with the GUI here: https://github.com/AlbrechtL/dab-rpi

This repository just holds all binary files to run dab-rpi with GPU acceleration on a Raspberry Pi 2 and 3 with the official raspbian image.

The image itself is based on 2016-05-27-raspbian-jessie-lite.img.

Usage of the Raspberry image
====

Hardware requirements
---------------------

- Raspberry Pi 2 or 3
- Touch screen
- A powerful power source (see section [power issues](#power-issues))
- A RTL2823U DVB-T stick to receive the radio signals

I tested the image only with a Raspberry Pi 3 and the official 7" touch display. But any other display should also work.
You can also connect a mouse to the system if you don't have a touch display.

Download
--------
You have to download the following file ["20160731_dab-rpi.img.7z"](https://github.com/AlbrechtL/dab-rpi_raspbian_image/releases/download/v20160731/20160731_dab-rpi.img.7z) and unpack it with 7zip. 

Installation
------------
- You need a 2 GB SD-card
- Unpack the image with 7zip
- Copy the image to a SD-card

        $ sudo dd bs=4M if=20160731_dab-rpi.img /dev/mmcblk

- Put the SD-card into your Raspberry Pi

Usage
-----
dab-rpi starts automatically after the boot. You can use dab-rpi easily with a touch screen.
If you closed dab-rpi you can restart it with the command
        $ dab-rpi

To login you can use to following users (ssh is also possible)
- Username: pi
- Password: raspberry

- Username: root
- Password: raspberry

Input sources
-------------
The following radio sources are supported. Both source are using auto gain control (AGC) by default.
- RTL2823U DVB-T stick (by default)
- rtl_tcp client

You can change it in the file "/etc/dab-rpi.ini" in the section "[General]"

       device=dabstick # RTL2823U DVB-T stick
or

       device=rtl_tcp # rtl_tcp client

### rtl_tcp setup
rtl_tcp is a tool to connect the RTL2823U DVB-T stick to another PC and stream the raw data via TCP. The data rate about 5 MB/s so a simple Wifi network is not working.

1. On the server PC start the tool with the following command on port 1235.

  ```
       $ rtl_tcp -a [local server IP] -p 1235
  ```
2. Adapt the input device in the file "/etc/dab-rpi.ini" in the section "[General]"

  ```
       device=rtl_tcp # rtl_tcp client
  ```
3. Adapt the server IP address in "/etc/dab-rpi.ini" in the section "[rtl_tcp_client]"

  ```
       remote-server=[server IP]
  ```

Power supply issues
-----

TBD

Troubleshooting
-----

If something is not working take a look into the file "/tmp/dab-rpi_output.log". All text output is redirected to this file.


Create your own Raspberry image
====

The following description bases on the raspbian image "2016-05-27-raspbian-jessie-lite.img"

1. Download the raspbian lite image from https://www.raspberrypi.org/downloads/raspbian/
2. Flash the image to a SD-card
3. Boot the Raspberry image and login
4. Create a root user and set a the password "raspberry"

  ```
$ sudo su
$ passwd
  ```

5. Login as root
6. Enable the ssh root login and change the line "PermitRootLogin without-password" to "PermitRootLogin yes"

  ```
$ nano /etc/ssh/sshd_config 
  ```
7. Restart ssh

  ```
$ service ssh restart 
  ```
8. Install software
   - dab-rpi needs the libraries libfaad2, libfftw3-3, libportaudio2, libusb-1.0-0, librtlsdr0 and libsndfile1
   - QT with EGLFS mode needs the libraries libinput5, libxcb-xinerama0, libts-0.0-0, tsconf, libxkbcommon0 and libfontconfig1

  ```
$ apt get update
$ apt-get install libfaad2 libfftw3-3 libportaudio2 libusb-1.0-0 librtlsdr0 libsndfile1 libinput5 libxcb-xinerama0 libts-0.0-0 tsconf libxkbcommon0 libfontconfig1
  ```
9. On the host PC clone this repository

  ```
$ git clone https://github.com/AlbrechtL/dab-rpi_raspbian_image.git
  ```
10. Copy the data to the Raspberry

  ```
$ cd dab-rpi_raspbian_image
$ rsync -av rootfs/ root@IP:/
  ```
11. Back on the Raspberry fix the EGL/GLES libraries symbolic links

  ```
$ rm /usr/lib/arm-linux-gnueabihf/libEGL.so.1.0.0 /usr/lib/arm-linux-gnueabihf/libGLESv2.so.2.0.0
$ ln -s /opt/vc/lib/libEGL.so /usr/lib/arm-linux-gnueabihf/libEGL.so.1.0.0
$ ln -s /opt/vc/lib/libEGL.so /usr/lib/arm-linux-gnueabihf/libEGL.so.1
$ ln -s /opt/vc/lib/libGLESv2.so /usr/lib/arm-linux-gnueabihf/libGLESv2.so.2.0.0
$ ln -s /opt/vc/lib/libGLESv2.so /usr/lib/arm-linux-gnueabihf/libGLESv2.so.2
  ```

12. Fix librtsdr symbolic link

  ```
$ ln -s /usr/lib/arm-linux-gnueabihf/librtlsdr.so.0 /usr/local/lib/librtlsdr.so
  ```
13. Run ldconfig to find the QT libraries and rtlsdr library

  ```
$ ldconfig
  ```

14. Disable the blank screen after a while
    
    Edit /boot/cmdline and add "*consoleblank=0*" to end of the string 

  ```
$ nano /boot/cmdline
$ cat /boot/cmdline
dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait consoleblank=0
  ```
15. If your screen is rotated add the following lines to /boot/config.txt

  ```
# Rotate display
lcd_rotate=2
  ```
16. By default this image sets the 3.5 mm audio jack volume to 100 %. To change this change the line following line in "/etc/rc.local"

  ```
# Set the audio jack volume to 100 %
/usr/bin/amixer set PCM -- 100% >/tmp/amixer_output.log 2>/tmp/amixer_err_output.log
  ```
17. Reboot the Raspberry and enjoy dab-rpi


dab-rpi and QT cross compiling
===
The tutorial is to cross compile dab-rpi and QT 5.7 with GPU acceleration for a Raspberry 2 or 3 and has to be followed one by one.

1. Follow the tutorial https://wiki.qt.io/RaspberryPi2EGLFS but use QT lib 5.7 instead of 5.6
2. If you get the following QT compile error please read the [QTBUG-55029 ](https://bugreports.qt.io/browse/QTBUG-55029)
  
  ```
   qeglfsbrcmintegration.cpp:35:22: fatal error: bcm_host.h: No such file or directory
   #include <bcm_host.h>
  ```
3. Compile qtxmlpatterns on the host PC

  ```
# cd ~/raspi
# git clone git://code.qt.io/qt/qtxmlpatterns.git -b 5.7
# cd qtxmlpatterns
# ~/raspi/qt5/bin/qmake -r
# make
# make install
  ```
4. Compile qtdeclarative on the host PC

  ```
# cd ~/raspi
# git clone git://code.qt.io/qt/qtdeclarative.git -b 5.7
# cd qtdeclarative
# ~/raspi/qt5/bin/qmake -r
# make
# make install
  ```
5. Compile qtquickcontrols on the host PC

  ```
# cd ~/raspi
# git clone git://code.qt.io/qt/qtquickcontrols.git -b 5.7
# cd qtquickcontrols
# ~/raspi/qt5/bin/qmake -r
# make
# make install
  ```
6. Compile qtquickcontrols2 on the host PC

  ```
# cd ~/raspi
# git clone git://code.qt.io/qt/qtquickcontrols2.git -b 5.7
# cd qtquickcontrols2
# ~/raspi/qt5/bin/qmake -r
# make
# make install
  ```
 7. Compile qtcharts on the host PC

  ```
# cd ~/raspi
# git clone git://code.qt.io/qt/qtcharts.git -b 5.7
# cd qtcharts
# ~/raspi/qt5/bin/qmake -r
# make
# make install
  ```
8. Install all necessary libraries to compile dab-rpi on the RPi

  ```
  # apt-get install libfaad-dev libfftw3-dev portaudio19-dev libusb-1.0-0-dev librtlsdr-dev libsndfile1-dev
  ```
9. Resync all new files between the host PC and the RPi

  ```
# cd ~/raspi
# rsync -avz pi@IP:/lib sysroot
# rsync -avz pi@IP:/usr/include sysroot/usr
# rsync -avz pi@IP:/usr/lib sysroot/usr
# rsync -avz pi@IP:/opt/vc sysroot/opt
  ```
10. Adjust symlinks to be relative 

  ```
# cd ~/raspi
# ./sysroot-relativelinks.py sysroot
  ```
11. Now you can setup QT Creator as it is explanied in the tutorial https://wiki.qt.io/RaspberryPi2EGLFS
12. Clone dab-rpi and open it with QT Creator

  ```
# cd ~/raspi
# https://github.com/AlbrechtL/dab-rpi.git
  ```
13. Cross compile dab-rpi, load it to the RPi and start it
