#!/bin/sh -E
#Using Bourne Shell


#The submodules for the various dependencies should already be setup
#This is a good resource for submodules
#http://gaarai.com/2009/04/20/git-submodules-adding-using-removing-and-updating/


if [ ! -d "build" ]; then
    echo "Creating build directory."
    mkdir "build"
fi
