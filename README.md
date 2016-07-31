dab-rpi SD-card image
=====================
![dab-rpi Screenshot](/pictures/dab-rpi.jpg?raw=true)

Table of contents
====

  * [Description](#description)
  * [Usage of the Raspberry image](#usage-of-the-raspberry-image)
  * [Create your own Raspberry image](#create-your-own-raspberry-image)

Description
====
This repository holds all binary files to run dab-rpi with GPU acceleration on a Raspberry Pi 2 and 3.

**Warning: At the moment dab-rpi and the Raspberry image are in an early development stage! Usage at your own risk!**

Usage of the Raspberry image
====

TBD

Create your own Raspberry image
====

The following description bases on the Raspbian image "2016-05-27-raspbian-jessie-lite.img"

1. Download the raspbian lite image from https://www.raspberrypi.org/downloads/raspbian/
2. Flash the image to a SD card
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
$ rsync -av .rootfs root@IP:/
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
16. Run alsamixer and set the sound level to 100 %

  ```
  $ alsamixer
  ```
17. Reboot the Raspberry and enjoy dab-rpi

