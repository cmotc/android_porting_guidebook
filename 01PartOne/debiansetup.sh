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
sudo mount --bind ~/android/system/dev /dev
sudo cp /proc/mounts ~/android/system/etc/mtab
sudo cp /etc/hosts ~/android/system/etc/hosts
sudo chroot ~/android/system/ /bin/sh -c "cd /home/android && bash"
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
xsltproc zip
case a in
        amd64 ) apt-get install libc6-dev-i386 gcc-multilib \
        g++-multilib lib32z1-dev lib32readline5-dev lib32ncurses5-dev 
esac
curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
chmod a+x /usr/bin/repo
echo "Install android-tools-* packages on the host machine or the build 
machine?"
select tools in "host" "build"; do
        case $Arch in
                host ) sudo apt-get install android-tools*;
                build )sudo chroot ~android/system apt-get install android-tools*
        esac
done
