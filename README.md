# numato-pas
Simple console USB Relay Module Controller

This utility was created in free pascal (Lazarus) to control USB Relay Module Controller model USBPOWRL002 from Numato.
You can get more this link: https://numato.com/docs/1-channel-usb-powered-relay-module/
Device: idVendor=2a19, idProduct=0c05

In Window run no problems but in PURE-Linux you may configure device permissions via UDEV:
sudo nano /etc/udev/rules.d/70-numato.rules
	KERNEL=="ttyACM[0-9]*",MODE="0666"

Usage:
numato-pas -d device -c command           
Where:                                             
device name: Ex.: /dev/ttyACM0 or COM1              
command to process: Ex.: ON, OFF or PULSE

This device is usefull to turn ON and OFF motors, ligths, power supply, etc.

You can run this on WSL (Windows Subsystem for Linux) where device name corresponding:
Windows COM1 => Linux /dev/ttyS1
Windows COM2 => Linux /dev/ttyS2
Windows COM3 => Linux /dev/ttyS3
.
.
.
You can get more this link: https://blogs.msdn.microsoft.com/wsl/2017/04/14/serial-support-on-the-windows-subsystem-for-linux/
