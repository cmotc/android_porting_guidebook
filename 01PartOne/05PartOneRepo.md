An overly detailed guide to repo, manifests, and assembling your port
=====================================================================

Quick Setup
-----------
It may be that you never need to use most of the advanced features of repo. If
you just want to port CyanogenMod to a new device, for example, you only need to
know about how to initialize, synchronise, and create manifests.  

###Initializing and Syncing a Repository
Developed by Google, repo is a tool used to download a large number of git
repositories using files called "manifests," which are XML files that describe
the location of a git repository and where to place it in the local source tree.
Since you are porting, you will eventually need to write your own repo local
manifests and include your source code.  

####repo init
To get a copy of the Android source code, you need to initialize the repository,
naming a branch. This will install the "repo" tool in the directory where you
initialize the repository, under the hidden directory named ".repo" where all
it's data will be stored.

This command will initialize the Replicant Android variant repository in the
current directory.  
        
        repo init -u git://gitorious.org/replicant/manifest.git -b replicant-4.2

This does not download the repository for you, it simply sets up the repository
for download.  

####Explore the .repo folder
Once you have run "repo init" you will have a new hidden folder underneath the 
source directory called ".repo". You will have an assortment of files and 
folders in this directory which instruct repo where to download source files
from. It's worth taking some time to familiarize yourself with the contents of
this folder before you get too deep into porting a device.  

   * manifest.xml : This is the default manifest file that you downloaded with
your "repo init" command. When you open it in a text editor or view it using
"cat filename" you will see a long list of lines that look like this.  

        <project path="tools/swt" name="platform/tools/swt" groups="notdefault,tools" remote="aosp" revision="refs/tags/android-4.4.4_r2" />
        <project path="vendor/cm" name="CyanogenMod/android_vendor_cm" />
        <project path="vendor/cyngn" name="cyngn/android_vendor_cyngn" />


   * manifests.git : In order to keep your manifest up to date, manifests 
themselves are downloaded from a git repository. This folder is where that git
repository is downloaded.  

   * manifests : This is where a copy of the default manifest is stored in case
you modify the manifest.xml file. I do not reccomend editing the manifest.xml
file directly or editing the default manifest, instead porters should use local
manifests to import their device trees. If you do not edit the manifest.xml
file it will be identical to the manifests/default.xml file.  

   * local_manifests : This is by far the most important part of the .repo 
folder for porters. When you have a device tree you want to try out, you should
upload the folder to github and add it to the the local_manifests folder. There
isn't really any standard way of naming the files under the local_manifests
folder, but I use (device codename).xml.  

   * project.list : Your project.list file is automatically generated when you
sync your source files using repo. It just lists the names of all the packages
in your source tree. You should probably not alter this file or it's contents.  

   * projects : The projects folder contains the git resource data downloaded by
your manifests. These are the actual copies of the files, as opposed to the
symbolic links(shortcuts) to the files which appear in the working source tree.
This is so you can delete your entire working tree, type repo sync, and retrieve
the last copy of each piece of software in your manifests.
You should probably never edit them.  

   * project-objects : The project-objects folder is similar to the projects
folder in that it contains git resource data, but it's used to download 
app-related git repositories instead of system related git repositories.  

   * repo : This is where the copy of the repo application used for your source
tree is stored. You will probably never need to mess with the files in this
folder.  

####repo sync
Now we download the contents of the source code repository using repo sync. Repo
will download everything listed in the manifest.xml file and everything listed
in an .xml file under the folder .repo/local_manifests  

It will take an annoyingly long-ass time. Just run  

        repo sync

and watch it go. The good news, however, is that it will only take a long time
the first time. Every subsequent time, it only downloads the changes between the
files, which will only take a few minutes.

###Using Manifests to Import Supplemental Repositories
Manifests are used to add and remove repositories from your personal copy of the
source code. Since you're probably using this guide to port Android to your
own hardware, you are going to want to use git repositories and manifests.  

Manifests are housed in two directories, the .repo directory, and the 
.repo/local_manifests/ directory.  

####Just Enough XML
Manifests are written in XML, but you don't need to know alot of XML to be able
to use them. XML is written using "tags" to markup data intended to be read by
a computer program.

####What's in a Manifest Line
Let's break down a manifest line, line by line.  

        <project name="omr87169/android_device_lge_l35g"

"project name" is a little misleading, it's actually the path to your device
tree on the remote repository. In this case, the device tree is at 
https://github.com/omr87169/android_device_lge_l35g.  

                path="device/lge/l35g"

"path" is the path where the git repository will be downloaded and imported into
your device tree. In this case, it will be downloaded to the absolute path
/home/android/devices/lge/l35g under your development environment  

                remote="github"

"remote" is the site where the code that needs to be downloaded will be taken
from. In this case, it is an alias, "github" which will download a repository
from https://www.github.com. This is easy because the remote is already added in
the default manifest.xml file. If you want to add a non-github remote, you can
do so by adding a line like this to your local manifest.  
        <remote name="github" fetch="https://github.com/" />

                revision="2.3.7"

"revision" reflects the branch of the remote repository to be downloaded.  

        />

####Local Manifests
Now you know enough about manifest files to try creating your own. Let's take a
look at a very simple example manifest file, named l35g.xml

####Example Local Manifest file

This is an example local manifest file which will import repositories for the LG
Optimus Logic.  

        <?xml version="1.0" encoding="UTF-8"?>
        <manifest>
          <project name="omr87169/android_device_lge_l35g" path="device/lge/l35g" remote="github" revision="2.3.7" />
          <project name="omr87169/android_kernel_lge_l35g" path="kernel/lge/l35g" remote="github" revision="2.3.7" />
          <project name="omr87169/android_vendor_lge_l35g" path="vendor/lge/l35g" remote="github" revision="2.3.7" />
        </manifest>

####What Else Can I Do With Manifests?

Lots of stuff. Manifests are integral to how Android is built from source and
knowing how to manipulate them will help you build custom Android and 
Android-Like Operating Systems for your device. For instance, you can use them
to add system apps to your ROM, remove unwanted pieces from ROM's, try out
experimental kernels and drivers.



Advanced Guide
--------------

###

Further Citations
-----------------
[Using Manifests,](http://wiki.cyanogenmod.org/w/Doc:_Using_manifests) 
CyanogenMod Wiki, CyanogenMod Project  


