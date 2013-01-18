#!/bin/sh -E
#Using Bourne Shell


#The submodules for the various dependencies should already be setup
#This is a good resource for submodules
#http://gaarai.com/2009/04/20/git-submodules-adding-using-removing-and-updating/


BASEDIR=$(cd $(dirname $0) && pwd)
SRCDIR=$BASEDIR/submodules
BUILDDIR=$BASEDIR/build
CMAKEPROGRAM=$BUILDDIR/cmake/bin/cmake

MULTITHREADING=8

#Create build directory if it doesn't exist
if [ ! -d "build" ]; then
    echo "Creating build directory."
    mkdir "build"
fi



#Build QT
#https://qt-project.org/wiki/Building_Qt_5_from_Git
#http://stackoverflow.com/questions/5587141/recommended-flags-for-a-minimalistic-qt-build
buildQT() {(
  echo "Starting QT build..."
  cd $SRCDIR/qt
  ./configure -opensource -confirm-license -fast -no-phonon -no-phonon-backend -no-webkit -no-multimedia -nomake examples -nomake tests -prefix $BUILDDIR/qt
  gmake -j $MULTITHREADING
  gmake install
 )
}

#Build CMake
buildCMake() {(
  echo "Starting CMake build..."
  mkdir -p $BUILDDIR/cmake
  cd $SRCDIR/cmake
  ./bootstrap --prefix=$BUILDDIR/cmake
  make -j $MULTITHREADING
  make install
 )
}


#Build LuaBind
buildLuaBind() {(
  echo "Starting LuaBind build..."
  mkdir -p $BUILDDIR/luabind && cd $BUILDDIR/luabind
  rm -f CMakeCache.txt
  $CMAKEPROGRAM $SRCDIR/luabind \
  -DCMAKE_BUILD_TYPE=Release
  make -j $MULTITHREADING
 )
}

#Build OSG
buildOSG() {(
  echo "Starting OSG build..."
  mkdir -p $BUILDDIR/osg && cd $BUILDDIR/osg
  rm -f CMakeCache.txt
  $CMAKEPROGRAM $SRCDIR/osg \
  -DCMAKE_BUILD_TYPE=Release
  make -j $MULTITHREADING
 )
}




#Start running through the build process

#buildQT
#buildCMake
#buildLuaBind
buildOSG
