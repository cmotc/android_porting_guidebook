Initializing the build toolchain with envsetup.sh
=================================================

What is envsetup.sh?
--------------------
Before you can successfully build an Android ROM, you need to run some scripts
that set up your build environment, foremost among them being envsetup.sh. When
you run envsetup.sh, you must call it using the "source" bash command.

        source build/envsetup.sh

The reason for this is because it must add some commands to your environment.
The simplest command it adds is "croot .", which returns you to the base of your
build directory. Remember to always type it including the period after "croot"
or it will not work successfully.

        croot .



Further Citations
-----------------
[A practical approach to the AOSP build system,](http://www.jayway.com/2012/10/24/a-practical-approach-to-the-aosp-build-system/) JayWay Software Innovations
[](http://www.elinux.org/Android_Build_System) elinux.org
