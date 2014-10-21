How to use dmesg to examine your Wireless Hardware
==================================================
Sometimes you will need to import a repository or object file which applies to a
specific piece of hardware on your device, and sometimes, you won't even have 
access to the name of that piece of hardware. 

In this case, the closest to a universal means to discern what this hardware is
to use [dmesg](https://en.wikipedia.org/wiki/Dmesg), the driver messaging 
system. In order to do this you will need to connect to the device via "adb 
shell" or use the Terminal Emulator or ConnectBot App, both of which are 
available in F-Droid and the Google Play Store.

Installing a Terminal Emulator
------------------------------
To use dmesg, you will need to have access to a Terminal Emulator on the device.
If you want, you can use "adb shell", but if not you can install a Terminal
Emulator on the device. There are two Free Software options available.

###Which one?
Well it depends. It's totally possible to use dmesg with either of them, and
there is not much difference between the two of them. The short of it is that if
you only want to work on the device, Android Terminal Emulator is the one for
you. If you want advanced features or the ability to ssh to another machine,
then you should use ConnectBot.

####Android Terminal Emulator
[Android Terminal Emulator](https://f-droid.org/repository/browse/?fdfilter=terminal&fdid=jackpal.androidterm) is an easy to use Terminal Emulator
available from F-Droid, as an APK, and from the Google Play store. It is
intended to provide a terminal for your device, on your device.

####ConnectBot Android Shell
[ConnectBot Android Shell](https://f-droid.org/repository/browse/?fdid=org.connectbot)
is a terminal emulator and secure shell client. It can be run in terminal
emulator mode, or it can be used to connect via ssh to a remote machine. It can
also be used to connect to a GNU/Linux chroot and launch some X applications if
they are supported on your device.

Working in the Terminal Emulator
--------------------------------
Once you've selected your terminal emulator, start it and enter the application
on your device. The process for determining your what hardware your device is
using is roughly (turn off device)->(turn on device)->(run dmesg in emulator)->
(examine the results).

###Step-by-Step
Usually, when you are doing this you will be looking for your wifi hardware.
Here is an example of how to discern what wifi hardware your device is using 
with dmesg.

####Stop and start the hardware in question
In order to make sure that a message from the device you are looking for is easy
to find in the dmesg output, you need to make it do something that will be
logged. The easiest way to do this, especially with wi-fi, to turn the device
off, then back on, then immediately run dmesg and examine the output. Just use
the interface on your Android device.

####Run dmesg, optionally save the output to a file
Immediately after you turn your wi-fi off and on, open the terminal emulator and
type  

        dmesg

to display the output immediately, or use

        dmesg > wifi_device_log.log

to save the output to a file on the device and

        cat wifi_device_log.log

to view the output.

If you want to save the output file to your work machine, you will need to use
"adb shell" to connect to your device and pipe the output of the command to a
file on your work device.

        adb shell dmesg > wifi_device_log.log

####Examine the output to find the device
The output of dmesg can seem confusing at first, but what you need to find is
fairly straightforward. Just look for every line in the output which has the
phrase wlan0. From these lines, information can be gleaned about what wireless 
driver is in use, whether it requires a proprietary firmware, or and most of 
the time reveal the actual hardware. Right now the only phone I have, however, 
is one of the really, absurdly cheap phones(L35g) and the only information that 
can be gathered from this particular phone is that the phone uses a proprietary
driver.

        <4>[   27.461203] wlan: module license 'Proprietary' taints kernel.

But, on an even slightly better phone(like the Samsung Galaxy Centura) a line
like this will reveal the wireless card.

        <7>[  775.718946] ath6kl: wmi tx id 1 len 53 flag 0

Power Tools for use with dmesg, the Advantages of Busybox
=========================================================
If you've never used grep before, prepare to meet your best friend. Grep stands
for GNU regular expression parser but you don't care about that. If I 


For example, here is the dmesg output of the LG Optimus Logic(l35g) filtered
with grep.

        cat wifi_device_log.log | grep wlan
        <3>[    2.625814] init: cannot find '/system/bin/wlan_tool', disabling 'wlan_tool'
        <4>[   27.461203] wlan: module license 'Proprietary' taints kernel.
        <6>[   34.082345] ADDRCONF(NETDEV_UP): wlan0: link is not ready
        <6>[   34.838541] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
        <6>[   53.944377] ADDRCONF(NETDEV_UP): wlan0: link is not ready
        <6>[   55.327871] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
        <7>[   65.913191] wlan0: no IPv6 routers present


Further Citations
-----------------
[How do I find out what Wi-Fi Chipset my phone has](https://android.stackexchange.com/questions/13548/how-do-i-find-out-what-wifi-chipset-my-phone-has) Android Stack Exchange, GAThrawn, Gili

