Android Porting Guidebook
=========================

Part One : The Android Build Environment
----------------------------------------
   * [Debian, Ubuntu Setup](https://github.com/cmotc/android_porting_guidebook/blob/master/01PartOne/01PartOneDebian.md)
   * Windows, VirtualBox, Debian Setup
   * Fedora, Redhat Setup
   * OSX Setup
   * [repo](https://github.com/cmotc/android_porting_guidebook/blob/master/01PartOne/05PartOneRepo.md)
   * [envsetup.sh](https://github.com/cmotc/android_porting_guidebook/blob/master/01PartOne/06PartOneEnvsetup.md)
   * [breakfast, brunch, lunch](https://github.com/cmotc/android_porting_guidebook/blob/master/01PartOne/07PartOneMeals.md)
   * [Makefiles, .mk, make and mka](https://github.com/cmotc/android_porting_guidebook/blob/master/01PartOne/08PartOneMake.md)
   * [Building a basic ROM](https://github.com/cmotc/android_porting_guidebook/blob/master/01PartOne/09PartOneTestBuild.md)

Part Two : Gathering Device Information
---------------------------------------
   * Examining build.prop
   * Examining an existing boot.img
   * Useful "adb shell " commands and how to pipe their output
   * How to use DuckDuckGo
   * How to ask questions

Part Three : Manifests, git and Github
--------------------------------------
   * Why you should use git
   * Where can I host my git Repositories
   * repo Revisited, manifest.xml
   * Using Local Manifests
   * [A simple manifest project: Replace ClockWorkMod with Team Win Recovery Project](https://github.com/cmotc/android_porting_guidebook/blob/master/03PartThree/05PartThreeCWMtoTWRP.md)
   * An Absurdling Exhastive Breakdown of manifest.xml, Every Single Package In Brief

Part Four : Extracting Device Information and Proprietary Drivers
------------------------------------------
   * [How to use dmesg to examine your hardware](https://github.com/cmotc/android_porting_guidebook/blob/master/04PartFour/01PartFourHowTodmesg.md)
   * [How to Build a recovery.fstab By Cross-Referencing Information about your partition table.](https://github.com/cmotc/android_porting_guidebook/blob/master/04PartFour/02PartFourHowToXRefPart.md)
   * The /system/lib directory
   * Researching proprietary drivers
   * Finding similar devices
   * Using system logs

Part Five : Compiling a Recovery
------------------------------
   * mka recoveryimage
   * recoveryui.cpp

Part Six : Compiling a ROM
--------------------------
   * 
   * 
   * 
   * 

Part Seven : Debugging Compilation Errors
-----------------------------------------
   * Basic Kernel Issue Resolution, and a Disclaimer.
   * 
   * 
   * 

Part Eight : Compiling a Kernel
-------------------------------
   * Kernel Hacking for people some would say probably shouldn't be doing it.
   * Setting up Automated Kernel Building for Cyanogenmod 10 or greater
   * Backporting Kernels for devices
   * 
   * 

Part Nine : Testing Your ROM
-----------------------------
   * 
   * 
   * 
   * 

Part Ten : Next Steps
-----------------------
   * Add System Apps to the Build
   * Other Open-Source Android-Based ROM's
   * Contribute To Replicant!
   * Harden your ROM
   * Develop an Android App
   * Port GNU/Linux
