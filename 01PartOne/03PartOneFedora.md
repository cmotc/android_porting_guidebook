Android Development Environment Setup on Debian-Based Linux Distributions
=========================================================================
*for the purposes of this book, all instructions taking place on GNU/Linux
will explicitly show the use of sudo when a command must be run as root or a
substitute user. This is largely in order to disambiguate the process of setting
up a build environment.  

Stabilizing and Isolating your Build Environment with yum and chroot
----------------------------------------------------------------------------
Using chroot will allow you to work with a consistent build environment and
avoid conflicting dependencies. Although it is not described in most Android
porting guides, I find it to be an invaluable step in setting up my development
environment. In order to do this, we shall use debootstrap to generate a minimal
Debian installation in a directory on your computer, mount the necessary parts
the underlying filesystem, and enter the new sterile environment using chroot.
Lastly, we'll write some short scripts to automatically enter our build
environment. This process may seem a little onerous, but it can save you some
trouble if you take the time to do it.  

###Programs you will be using
  * apt-get
  * yum [debootstrap @ Debian wiki](https://wiki.debian.org/Debootstrap)
  * chroot [chroot @ Debian wiki](https://wiki.debian.org/chroot)

####First, set up some directories.
These directories will hold all the files you require for building your Android
ROM.  

        mkdir -p ~/android/system

/android is the directory where we will store a few helper scripts for setting
up and entering the build environment  

/android/system is the directory where the stable chroot environment will be
created.  

####Second, get some dependencies.
In case you don't have debootstrap installed already, install it.  

        sudo apt-get install debootstrap

debootstrap creates a minimal Debian install in a directory on your computer.  

####Third, run debootstrap.
Change directory to the helper script directory.  

        cd ~/android
Run debootstrap to create a Debian i386 install in the system directory.  

        sudo debootstrap --arch i386 wheezy system
Alternatively, create a Debian amd64 install in the system directory.  

This command means "as root, boostrap a new Debian installation for the i386
architecture using the wheezy repositories in the directory under the working
directory called system."  

####Fourth, mount /proc, /sys and /dev.
Next, you will need to mount some parts of the host filesystem in order to use
the system you have just created.  

        sudo mount proc system/proc -t proc
        sudo mount sysfs system/sys -t sysfs
        sudo mount --bind /dev/pts ~/android/system/dev/pts
        sudo mount --bind system/dev /dev

####Fifth, enter the chroot and allow it to draw from wheezy-backports.
Copy the local hosts file into the development environment  

        sudo cp /etc/hosts system/etc/hosts
Copy the locally mounted devices into the development environment.  

        sudo cp /proc/mounts system/etc/mtab
Now we're ready to enter the chroot. This time, we're just going to set up the
wheezy-backports repository, update the installation, and quit.  

        sudo chroot system
        mkdir -p /home/android/
        echo "
        deb http://ftp.us.debian.org/debian/ wheezy-backports main
        " >> /etc/apt/sources.list
        echo "
        APT::Default-Release "wheezy";
        " > /etc/apt/apt.conf
        apt-get update && apt-get dist-upgrade

The wheezy-backports repository will be used supplementally to help you install
software essential to working with Android ROM's.  

####Sixth, write some scripts to enter the chroot automatically.
We aren't configured to automatically start the processes in the chroot when you
start the system, so each time, we'll have to re-mount the host filesystems and
re-copy the host and mounts files into the chroot. Instead of doing all that,
we're just going to create a script that will load you right into the chroot
automatically.  

Create a file containing the script to enter the chroot in the helper scripts
directory.  

        echo "#! /bin/sh
        sudo mount proc ~/android/system/proc -t proc
        sudo mount sysfs ~/android/system/sys -t sysfs
        sudo mount --bind /dev/pts ~/android/system/dev/pts
        sudo mount --bind ~/android/system/dev /dev
        sudo cp /proc/mounts ~/android/system/etc/mtab
        sudo cp /etc/hosts ~/android/system/etc/hosts
        sudo chroot ~/android/system/ /bin/sh -c "cd /home/android && bash && CROSS_COMPILE=/home/android/arm-linux-androideabi-4.7/prebuilt/linux-x86_64/bin/arm-linux-androideabi- & echo "success ""
        " > ~/android/enter.sh
Make the file executable.  

        chmod +x ~/android/enter.sh

####Finally, let's review the workflow for those new scripts.  
To use the enter.sh script, you just change directory to the helper scripts
directory and run ./enter.sh. Because it uses sudo, you will be asked for your
password.  

        cd ~/android/
        ./enter.sh

####Exit the chroot build environment
Leave the chroot.  

Type exit.  

        exit

Installing the building dependencies
------------------------------------
Next, we're going to install the build dependencies for compiling an Android ROM
in the chroot.  

###Programs you will be using
  * apt-get
  * ln

####Enter the build environment.
When you want to work on your Android ROM, you will need to enter your chroot
development environment.  

Now that you have your chroot environment set up, enter it.  

        cd ~/android
        ./enter.sh

####Set up the build dependencies
Now just use apt to install the build dependencies.  

For 386 build environments, install these packages.  

        apt-get install -t wheezy-backports bison flex git-core gperf \
        libncurses-dev build-essential squashfs-tools openjdk-6-jre \
        openjdk-6-jdk pngcrush wget zip zlib1g-dev lzma libxml2-utils \
        build-essential libesd0-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 lzop \
        xsltproc zip schedtool locales
For amd64 build environments, also install these packages.  

        apt-get install libc6-dev-i386 gcc-multilib g++-multilib lib32z1-dev \
        lib32readline5-dev lib32ncurses5-dev 

#####Something to come back to, resolving libraries.
This is the first part of the process which may require some reasoning(although
the use of the 386 chroot should mitigate most issues). Some distributions put
libraries in slightly different directories on your computer. If you get an
error when you are compiling your ROM that involves a missing library, this is
probably the case. Resolving this issue will involve making a symbolic link in
to the required library in the directory where the environment expects it to be.  

for example, should you see zconf.h missing, you probably need to do something
like  

        sudo ln -s /usr/include/x86_64-linux-gnu/zconf.h /usr/lib/zconf.h
Similarly, if libstdc++.so is missing,  

        sudo ln -s /usr/lib32/libstdc++.so.6.0.14 /usr/lib32/libstdc++.so
or libGL.so  

        sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 \
        /usr/lib/i386-linux-gnu/libGL.so

This command means as root, create a soft symbolic link to the required file in 
the directory where the compiler is looking for it.  

Unfortunately, it's hard to determine where your particular build environment
expects each of these libraries to be. I will do my best to document as many of
these as possible in this document.  

Installing repo
---------------
A few more programs need to be installed for you to obtain the sources and build
successfully.  

#####Something to come back to, apt-get only install of SDK and NDK
Parts of the Android SDK and NDK are already available as standard Debian
packages, unfortunately it is not readily apparent how complete these tools are.
for that reason, we'll be setting all of these tools up from source rather than
using the apt packages. If anyone knows more about how to use the apt packages
in lieu of installing the software from source, please let me know.  

####Let's install repo
Created by Google, repo is a tool which automates the downloading of a large 
number of git source repositories in an automated fashion using xml files called
manifests. I will go into more detail about repo in the second half of this
part of the book.  

Installing repo is easy, just download the file to your /usr/bin directory.  

        curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
Then, make it executable.  

        chmod a+x /usr/bin/repo

This installs repo directly into your path at /usr/bin/repo. The Android
documentation does this differently, encouraging you to install repo into a
folder under your home directory and add that folder to your $PATH to help
you facilitate updates. In a chroot, that is not necessary.  

Also the name is kind of bullshit. It makes it super hard to find people's forum
posts about using repo as opposed to searching for other types of repositories.
Way to think it through, Google.

####Install the Android NDK and add it to yout PATH
You also need the Android NDK to compile your own ROM. The NDK generates binary
code for arm devices.

In order to install the NDK, download it using wget.
        wget -O /home/NDK.tar.gz http://dl.google.com/android/ndk/android-ndk32-r10-linux-x86.tar.bz2
        tar xvjf NDK.tar.gz
        CROSS_COMPILE=/home/android/android-ndk-r10/arm-linux-androideabi-4.7/prebuilt/linux-x86_64/bin/arm-linux-androideabi-

Installing adb, fastboot
------------------------
You may wish to install adb and fastboot on your host computer and not in your
chroot development environment. This can be done using apt, or by installing the
SDK tools from source.  

From outside the chroot development environment, run  

        sudo apt-get install android-tools*

Or, from inside the chroot development environment, run  

        apt-get install android-tools

A one-time script which does all this for you
---------------------------------------------
        #! /bin/sh
        mkdir -p ~/android/system
        sudo apt-get install debootstrap
        cd ~/android
        echo "Do you want to use an i386 or amd64 build environment?"
        select Arch in "i386" "amd64"; do
                case $Arch in
                        i386 ) sudo debootstrap --arch i386 wheezy system; a=i386;
                        amd64 ) sudo debootstrap --arch amd64 wheezy system; a=amd64;
                esac
        done
        sudo mount proc system/proc -t proc
        sudo mount sysfs system/sys -t sysfs
        sudo mount --bind system/dev /dev
        sudo cp /etc/hosts system/etc/hosts
        sudo cp /proc/mounts system/etc/mtab
        sudo chroot system
        mkdir -p /home/android/
        echo "
        deb http://ftp.us.debian.org/debian/ wheezy-backports main
        " >> /etc/apt/sources.list
        echo "
        APT::Default-Release "wheezy";
        " > /etc/apt/apt.conf
        apt-get update && apt-get dist-upgrade
        echo '#! /bin/sh
        sudo mount proc ~/android/system/proc -t proc
        sudo mount sysfs ~/android/system/sys -t sysfs
        sudo mount --bind /dev/pts ~/android/system/dev/pts
        sudo mount --bind ~/android/system/dev /dev
        sudo cp /proc/mounts ~/android/system/etc/mtab
        sudo cp /etc/hosts ~/android/system/etc/hosts
        sudo chroot ~/android/system/ /bin/sh -c "cd /home/android && bash && CROSS_COMPILE=/home/android/android-ndk-r10/arm-linux-androideabi-4.7/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gcc & echo "success""
        ' > ~/android/enter.sh
        chmod +x ~/android/enter.sh
        cd ~/android/
        ./enter.sh
        exit
        cd ~/android
        ./enter.sh
        apt-get install -t wheezy-backports bison flex git-core gperf \
        libncurses-dev build-essential squashfs-tools openjdk-6-jre \
        openjdk-6-jdk pngcrush wget zip zlib1g-dev lzma libxml2-utils \
        build-essential libesd0-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 lzop \
        xsltproc zip schedtool locales
        case a in        
                amd64 ) apt-get install libc6-dev-i386 gcc-multilib \
                g++-multilib lib32z1-dev lib32readline5-dev lib32ncurses5-dev 
        esac
        curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
        chmod a+x /usr/bin/repo
        wget -O /home/NDK.tar.gz http://dl.google.com/android/ndk/android-ndk32-r10-linux-x86.tar.bz2
        tar xvjf NDK.tar.gz
        CROSS_COMPILE=/home/android/android-ndk-r10/arm-linux-androideabi-4.7/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gcc
        echo "Install android-tools-* packages on the host machine or the build 
        machine?"
        select tools in "host" "build"; do
                case $Arch in
                        host ) sudo apt-get install android-tools*;
                        build )sudo chroot ~android/system apt-get install android-tools*
                esac
        done

Further Citations
-----------------
[Build Dependencies Installation,](http://redmine.replicant.us/projects/replicant/wiki/BuildDependenciesInstallation), Replicant Wiki, Replicant Project  
[Initializing a Build Environment,](http://source.android.com/source/initializing.html) Android Developers Guide, Google  

Further Reading:
----------------
https://en.wikipedia.org/wiki/Chroot
