vrjugglua-rhel6-build
====================

This stores (via submodules) the various dependencies for VR-Jugglua.

It also includes a build script that will compile the entire system.  Current testing has been on VRAC RHEL6 only.

Make sure to clone with the recursive flag:

    git clone --recursive https://github.com/vancegroup/vrjugglua-rhel6-build.git
    
    
C6 Specific Notes
---------------------

Mappings for wand:

* VJButton0 - yellow button
* VJButton1 - red button
* VJButton2 - green button
* VJButton3 - blue button
* VJButton4 - joystick press
* VJButton5 - trigger


Launching applications:

The 'cluster' script that was used before is deprecated. We now have a newer script called,
'launcher-rhel6' that is located in /home/vr/apps/launcher/ but symbolically linked
to /usr/local/bin/launcher.

It is a self-contained shell script that can automatically perform the appropriate
ssh connections to all nodes in the C6.

    launcher -c6 <name_and_path_of_binary>

To kill the app, run:

    launcher -c6 -k <name_and_path_of_binary>
    
You can also access the help menu that has important scripts such as rebooting the entire
cluster or restarting graphics (for troubleshooting) by running:

    launcher --help

On the C6 cluster, the application is replicated and runs separately on each machine.
Therefore, it's important to make sure the application is killed on all the machines when
you're done.  Just closing it on the main computer node (zion.vrac.iastate.edu) is NOT
enough.

I usually open a separate terminal tab and then SSH into a random machine and then run `top`
to make sure the application is not running.  You can look in the .jconf file for the machine
names.  They're named according to the position on the screen, so for example:

    ssh top6
   
This logs you into `zion-46.vrac.iastate.edu`.

If you don't do this and you leave an application running accross the cluster, it would
slow down other apps so make sure it's killed!

JCONF files as provided by VRAC are in the following location:

`/home/vr/vjconfig/C6/`
