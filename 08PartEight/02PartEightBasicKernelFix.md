Basic Kernel Issue Resolution, A Disclaimer, and Why I Wrote This Book
======================================================================
.Sdrawkcab nettirw si retpach siht

Why I Am Writing This Book
--------------------------
I installed my first Linux distribution when I was about 13 years old on a
Compaq Presario with a purple, curved faceplate. Back then, if you had an issue
during installation, there were few automatic, user-friendly ways of fixing
those issues and you had 2 choices, try a different distribution or resolve it
yourself. The first one I got to work was Slackware, and it didn't work
entirely the first time around. I spent weeks on my Windows partition copying 
things I thought might help me resolve my issue(a malfunctioning desktop window
manager). This sort of rite-of-passage is typical of alot of people in my 
generation of GNU+Linux enthusiasts, we started out hoping to be users but found
the kind of freedom we could have with our hardware by working through an issue
we had with it on a system that would allow us to do so. Thousands of man-hours
of fixes contributed have given us highly user-friendly distributions like 
Ubuntu and Android, general-purpose base distributions like Fedora, Debian, and
Arch, highly secure Linux distributions like Alpine and penetration testing
Distributions like Kali Linux. Even SteamOS can use Linux as it's basis. These
days, they *all work great* and that's largely a function of transparency and
the involvement of tech industry workers, academics, and enthusiasts getting
involved with their development. Eventually, a lot of us learned from [Linux From Scratch](https://linuxfromscratch.org)
\(Which is still an active and excellent resource which will be very helpful as
you port AOSP, CyanogenMod, Replicant, etc to your device\)how Linux systems 
were put together, and we learned to code, then we learned to code better, and 
administer software, and all kinds of cool stuff. It's in that spirit of Free 
Software, personal freedom, and ownership that this book is written. I would 
even go so far as to say that it attempts to continue in the spirit of Linux 
from Scratch, which has become a hacker rite-of-passage for many. There are
hundreds of millions of potential enthusiasts who could extend the hardware and
upstream support of the billions of devices produced and sold each year. These 
tiny computers, in the pockets of thousansds of people all over the world, are
discarded every day when they could be repurposed into everything from massive
parallel computing clusters, industrial control systems, robot brains, or even
used in conjunction with a keyboard and mouse as a workstation computer for
somebody who just wants to get a better job. This an attempt to empower and 
stimulate new business and innovation, and most of all indiviuals. It can also
have other side-effects, like potentially reducing e-waste and the consequent
poisoning and victimization of the environment and citizens of industrially
undeveloped countries. I encourage you, in spite of the difficulties I am about
to outline, to nonetheless persevere in your own efforts to port to your device
and consider all the possibilities that go even beyond the amazing functionality
of a modern phone.

And Now, the Disclaimer
-----------------------
There are two chapters in this book that can brick your device. This is one of
them. 

Here's the deal. This bit deals with fixing up your device for use with a 
different Linux kernel than the one supplied by the manufacturer. The best
reason for this is in order to backport a newer userland\(say, Android 4.4\) to
a device which previously used an older Kernel\(Say, Linux 3.0.8, used on 
Android 4.0.4\) Sometimes, it's easy because the **upstream support** for a
device's hardware is good. Upstream Support means that the hardware in a device
is officially supported in the Linux Kernel. Unfortunately, unless it's
particularly well supported, it might be pretty hard to figure out whether a
device has hardware with upstream support, and it might be hard to figure out
what options you need to enable in a new Kernel defconfig in order to use that
hardware. And that's before you even get to the part where you have to compile
the kernel and deal with the sections of the code which don't work because of
some peculiarity of your system. And while it's not *likely*, a mistake in this
process can *potentially* make your device unfixable. And there's good news, you
can even usually recover from a bad flash. Like, 95% of the time, you're not
going to wind up with an unfixable device.

So go carefully forward.

And one final note, please write documentation and put it online somewhere. And
use git, for fuckssake.

Without Further Ado
-------------------

###Part One: Get source code for your device from the Manufacturer
The first, and easiest step is finding the best version of the 
Android-Modifified Linux Kernel for your device. This depends on a couple of
things. First, you need to pick a version of Linux compatible with the Android
system you want to compile. Android uses the incremental, long-term stable
releases of Linux for it's Kernel. To find a suitable Kernel version number for
the ROM you want to make, you can consult the following table.

Android/Replicant Version | CyanogenMod Version | Linux Kernel Version
--------------------------|---------------------|---------------------
    Gingerbread 2.3       |    CM7              |    2.6.35
    Honeycomb 3.0         |    N/A              |    2.6.36
   Ice Cream Sandwich 4.0 |    CM9              |    3.0.1
    Jelly Bean 4.1        |    CM10             |    3.0.31
    Jelly Bean 4.2        |    CM10.1           |    3.4.0
    Jelly Bean 4.3        |    CM10.2           |    3.4.0
    Kit Kat 4.4           |    CM11             |    3.4.0
    Lollipop 5.0          |    CM12             |    3.1.4

There is some, for lack of a better term, wiggle room here. One can usually
regard these as minimum Kernel versions, which is a little helpful because
*sometimes* a Free driver has been incorporated upstream after a certain Kernel
version. That means you can use that driver instead of some proprietary firmware
or other. More on that later. For now, let's focus on getting ahold of the code
you need.

####OK so this part kind of fucking sucks too
Hey you know what's confusing? When Samsung branded devices don't have Samsung
parts inside. Like the Samsung Galaxy Centura. Definitely not an Exynos(Thank
fuck) nearly every bit of this little bastard is designed by Qualcomm. It's got
an MSM7627A processor(or 7x27A in CyanogenMod and Linux Kernel parlance) an
Atheros 6kl Wireless Card, an Adreno GPU and a Hexagon Digital Signal Processor.
Like, nothing Samsung about it at all. So when you're presented with a table
like this one

Original Equipment Manufacturer | Platform | Repositories
--------------------------------|----------|-------------
Google                          | various  | [Google Git](https://android.googlesource.com/) [Nexus Blobs](https://developers.google.com/android/nexus/drivers)
HTC                             | various  | [HTC Dev Center](http://htcdev.com/devcenter/)
HP                              | various  | [HP Open Source](http://www.hp.com/software/opensource)
Lenovo                          | various  | [Lenovo Smartphones](http://www.hp.com/software/opensource)
LG                              | various  | [LG Open Source](http://www.lg.com/global/support/opensource/index/)
Motorola                        | various  | [Motorola Open Source](http://sourceforge.net/motorola)
Nvidia                          | Tegra    | [Tegra Gitweb](http://nv-tegra.nvidia.com/gitweb/)
Qualcomm                        | MSM/QSD  | [Code Aurora Forum](https://www.codeaurora.org/)
Samsung                         | various  | [Samsung Open Source](http://opensource.samsung.com/)
Texas Instruments               | OMAP     | [OmapZoom](http://www.omapzoom.com/) [Omappedia](http://www.omappedia.org/)
Source:[http://wiki.cyanogenmod.org/w/Doc:\_porting_intro#Getting\_help\_from\_the\_manufacturers\_.26\_vendors](http://wiki.cyanogenmod.org/w/Doc:_porting_intro#Getting_help_from_the_manufacturers_.26_vendors)  
it can be a little hard to figure out what the hell to do. And check this out.
Click that Samsung link up there and open it in a new tab. Now click the 
CodeAurora forum link. Now click the Google source code link. Wildly disparate,
right? Samsung doesn't even have Git repositories for their devices, you can 
find kernel sources, but Samsung's changes are *not* well documented and it's
totally unclear whether any of the changes were upstreamed. The good news,
however, is that various usually means Qualcomm, and while Qualcomm's had it's
own issues with Open Source support, for right now, Code Aurora is a way better
place to get your Kernel source code. In general, only bother with sources like
Samsung when absolutely necessary. Professionals use version control. There I
said it. I mean, I kid, they obviously use version control internally and most
of these kernels aren't recieving updates, but that's like, exactly the problem.
Prefer git and thank me later. 

But the moral of that whole story is that the actual hardware may not, and in
fact probably does not, correspond to the brand name. We've already figured it
out back in Chapter Two, but now let's go into more detail as to what that
means. In case you haven't done it already, go ahead and pull your build.prop
from your device. You're going to need to look for a line that says 
ro.board.platform or ro.product.board. For example, the first and last lines of
of the following snippet contain the first bits of information we'll need.

        ro.product.board=7x27
        ro.product.cpu.abi=armeabi-v7a
        ro.product.cpu.abi2=armeabi
        ro.product.manufacturer=samsung
        ro.product.locale.language=en
        ro.product.locale.region=US
        ro.wifi.channels=
        ro.board.platform=msm7627a

In this case, we have a Qualcomm MSM7627A CPU. What a coincidence, that's the
phone I'm writing this book on. You might have a different sort of device. For
instance, if you have an Exynos device, it will say something like "S5P." 
MediaTek hardware starts with "MT" or "MTK". Texas Instruments hardware starts
with "OMAP." AllWinner hardware is usually just 3 letters, and it is almost
always one of the following "A10" "A20" "A31" "A31s" "A33." So check out the
repository for the Linux kernel appropriate for your hardware by the actual
manufacturer, without undue regard for the name on the label, by

  * finding a git repository for the real manufacturer of the device
  * and cloning the best-fit stable Android Kernel branch for the Android Version you want to compile.

For example, to clone version 3.4.0 of the aosp-common branch of the Code Aurora
Android Kernel, do:

        git clone git://codeaurora.org/quic/la/kernel/msm -b aosp-common/android-3.4

If you can't find your processor in my explanation above, try looking [here](http://pdadb.net/index.php?m=cpu)
for the processor in that list, and you can cross-reference the manufacturer.

###Part Two: Configuring Your Kernel
Once you have that essential information, you'll need to get the rest of the
essential hardware information for your phone. [pdadb.net](http://pdadb.net) is
a good place to start. As a general rule, GPU's and CPU's on the same chip tend
to be designed by the same companies, so an MSM board will probably have an
Adreno GPU and a Hexagon DSP, *but not always*. One place where it's often 
difficult to deduce the type of hardware is with the WiFi, which is why there's
a whole [section on it in Chapter 4](https://github.com/cmotc/android_porting_guidebook/blob/master/04PartFour/01PartFourHowTodmesg.md). 
That information is even more important for this chapter, so make sure you know
as much as possible about your kernel.

In this section, you'll be using some software that I haven't explained before.

  * menuconfig
  * ./scripts/kconfig/merge_config.sh

In order to craft your device's new defconfig. Before we begin, take a look at
the arch/arm/configs/ folder in the source tree of your Linux kernel. If you 
list the contents in a terminal, you'll see something like this. These are
minimal kernel configurations and as you can see, some of them look like they
are designed for the hardware initials we looked for in your build.prop. We'll
be using those as the basis for the final defconfig for your kernel. Open one or
two of them and read the flags, but do not edit them.

        acs5k_defconfig                   corgi_defconfig        jornada720_defconfig  pxa3xx_defconfig
        acs5k_tiny_defconfig              cpu9260_defconfig      kirkwood_defconfig    pxa910_defconfig
        afeb9260_defconfig                cpu9g20_defconfig      kota2_defconfig       qil-a9260_defconfig
        ag5evm_defconfig                  da8xx_omapl_defconfig  ks8695_defconfig      raumfeld_defconfig
        am200epdkit_defconfig             davinci_all_defconfig  lart_defconfig        realview_defconfig
        amazing3g_cdma_00_defconfig       defconfig.patch        lpc32xx_defconfig     realview-smp_defconfig
        ap4evb_defconfig                  dove_defconfig         lpd270_defconfig      rpc_defconfig
        assabet_defconfig                 ebsa110_defconfig      lubbock_defconfig     s3c2410_defconfig
        at91rm9200_defconfig              edb7211_defconfig      mackerel_defconfig    s3c6400_defconfig
        at91sam9260_defconfig             em_x270_defconfig      magician_defconfig    s5p64x0_defconfig
        at91sam9261_defconfig             ep93xx_defconfig       mainstone_defconfig   s5pc100_defconfig
        at91sam9263_defconfig             eseries_pxa_defconfig  marzen_defconfig      s5pv210_defconfig
        at91sam9g20_defconfig             exynos4_defconfig      mini2440_defconfig    sam9_l9260_defconfig
        at91sam9g45_defconfig             ezx_defconfig          mmp2_defconfig        shannon_defconfig
        at91sam9rl_defconfig              footbridge_defconfig   msm_defconfig         shark_defconfig
        at91x40_defconfig                 fortunet_defconfig     mv78xx0_defconfig     simpad_defconfig
        badge4_defconfig                  g3evm_defconfig        mxs_defconfig         spear3xx_defconfig
        bcmring_defconfig                 g4evm_defconfig        neponset_defconfig    spear6xx_defconfig
        bonito_defconfig                  h3600_defconfig        netwinder_defconfig   spitz_defconfig
        cam60_defconfig                   h5000_defconfig        netx_defconfig        stamp9g20_defconfig
        cerfcube_defconfig                h7201_defconfig        nhk8815_defconfig     tct_hammer_defconfig
        cm_schS738c_defconfig             h7202_defconfig        nuc910_defconfig      tegra_defconfig
        cm_schS738c_defconfig.Ath9khtc    hackkit_defconfig      nuc950_defconfig      trizeps4_defconfig
        cm_schS738c_defconfig.MSMotg      imote2_defconfig       nuc960_defconfig      u300_defconfig
        cm_schS738c_defconfig.OLDVERSION  imx_v4_v5_defconfig    omap1_defconfig       u8500_defconfig
        cm_schS738c_defconfig.reloaded    imx_v6_v7_defconfig    omap2plus_defconfig   usb-a9260_defconfig
        cm_schS738c_defconfig.SELinux     integrator_defconfig   orion5x_defconfig     versatile_defconfig
        cm_x2xx_defconfig                 iop13xx_defconfig      palmz72_defconfig     vexpress_defconfig
        cm_x300_defconfig                 iop32x_defconfig       pcm027_defconfig      viper_defconfig
        cns3420vb_defconfig               iop33x_defconfig       pleb_defconfig        xcep_defconfig
        colibri_pxa270_defconfig          ixp2000_defconfig      pnx4008_defconfig     zeus_defconfig
        colibri_pxa300_defconfig          ixp23xx_defconfig      pxa168_defconfig
        collie_defconfig                  ixp4xx_defconfig       pxa255-idp_defconfig

And here is the contents of the msm_defconfig

        CONFIG_EXPERIMENTAL=y                                   CONFIG_MTD=y                                    CONFIG_VIDEO_OUTPUT_CONTROL=y
        CONFIG_IKCONFIG=y                                       CONFIG_MTD_PARTITIONS=y                         CONFIG_FB=y
        CONFIG_IKCONFIG_PROC=y                                  CONFIG_MTD_CMDLINE_PARTS=y                      CONFIG_FB_MODE_HELPERS=y
        CONFIG_BLK_DEV_INITRD=y                                 CONFIG_MTD_CHAR=y                               CONFIG_FB_TILEBLITTING=y
        CONFIG_SLAB=y                                           CONFIG_MTD_BLOCK=y                              CONFIG_FB_MSM=y
        # CONFIG_BLK_DEV_BSG is not set                         CONFIG_NETDEVICES=y                             # CONFIG_VGA_CONSOLE is not set
        # CONFIG_IOSCHED_DEADLINE is not set                    CONFIG_DUMMY=y                                  CONFIG_FRAMEBUFFER_CONSOLE=y
        # CONFIG_IOSCHED_CFQ is not set                         CONFIG_NET_ETHERNET=y                           CONFIG_NEW_LEDS=y
        CONFIG_ARCH_MSM=y                                       CONFIG_SMC91X=y                                 CONFIG_LEDS_CLASS=y
        CONFIG_MACH_HALIBUT=y                                   CONFIG_PPP=y                                    CONFIG_INOTIFY=y
        CONFIG_NO_HZ=y                                          CONFIG_PPP_ASYNC=y                              CONFIG_TMPFS=y
        CONFIG_HIGH_RES_TIMERS=y                                CONFIG_PPP_DEFLATE=y                            CONFIG_MAGIC_SYSRQ=y
        CONFIG_PREEMPT=y                                        CONFIG_PPP_BSDCOMP=y                            CONFIG_DEBUG_KERNEL=y
        CONFIG_AEABI=y                                          # CONFIG_INPUT_MOUSEDEV_PSAUX is not set        CONFIG_SCHEDSTATS=y
        # CONFIG_OABI_COMPAT is not set                         CONFIG_INPUT_EVDEV=y                            CONFIG_DEBUG_MUTEXES=y
        CONFIG_ZBOOT_ROM_TEXT=0x0                               # CONFIG_KEYBOARD_ATKBD is not set              CONFIG_DEBUG_SPINLOCK_SLEEP=y
        CONFIG_ZBOOT_ROM_BSS=0x0                                # CONFIG_INPUT_MOUSE is not set                 CONFIG_DEBUG_INFO=y
        CONFIG_CMDLINE="mem=64M console=ttyMSM,115200n8"        CONFIG_INPUT_TOUCHSCREEN=y                      CONFIG_DEBUG_LL=y
        CONFIG_PM=y                                             CONFIG_INPUT_MISC=y
        CONFIG_NET=y                                            # CONFIG_SERIO is not set
        CONFIG_UNIX=y                                           CONFIG_VT_HW_CONSOLE_BINDING=y
        CONFIG_INET=y                                           CONFIG_SERIAL_MSM=y
        # CONFIG_INET_XFRM_MODE_TRANSPORT is not set            CONFIG_SERIAL_MSM_CONSOLE=y
        # CONFIG_INET_XFRM_MODE_TUNNEL is not set               # CONFIG_LEGACY_PTYS is not set
        # CONFIG_INET_XFRM_MODE_BEET is not set                 # CONFIG_HW_RANDOM is not set
        # CONFIG_INET_DIAG is not set                           CONFIG_I2C=y
        # CONFIG_IPV6 is not set                                # CONFIG_HWMON is not set


So let's take this step-by-step.

###Part Three: Fixing Compilation Errors

  + 

###Part Four: Backporting Stuff

  + 

###Part Five: Choose Open Source

  + 
