#!/bin/sh -E
#Using Bourne Shell


#The submodules for the various dependencies should already be setup
#This is a good resource for submodules
#http://gaarai.com/2009/04/20/git-submodules-adding-using-removing-and-updating/


BASEDIR=$(cd $(dirname $0) && pwd)
SRCDIR=$BASEDIR/submodules
BUILDDIR=$BASEDIR/build
INSTALLDIR=$BASEDIR/install
CMAKEPROGRAM=$BUILDDIR/cmake/bin/cmake

MULTITHREADING=8

#Create build directory if it doesn't exist
mkdir -p $BUILDDIR && cd $BUILDDIR

#Create install directory if it doesn't exist
mkdir -p $INSTALLDIR


#Build QT
#https://qt-project.org/wiki/Building_Qt_5_from_Git
#http://stackoverflow.com/questions/5587141/recommended-flags-for-a-minimalistic-qt-build
buildQT() {(
  echo "Starting QT build..."
  cd $SRCDIR/qt
  ./configure -opensource -release -confirm-license -fast -no-script -no-scripttools -no-qt3support -no-phonon -no-phonon-backend -no-webkit -no-audio-backend -no-multimedia -nomake demos -nomake examples -nomake tests -prefix $BUILDDIR/qt
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
#This is included already in VRJugglua
#buildLuaBind() {(
#  echo "Starting LuaBind build..."
#  mkdir -p $BUILDDIR/luabind && cd $BUILDDIR/luabind
#  rm -f CMakeCache.txt
#  $CMAKEPROGRAM $SRCDIR/luabind \
#  -DCMAKE_BUILD_TYPE=Release
#  make -j $MULTITHREADING
# )
#}

#Build OSG
buildOSG() {(
  echo "Starting OSG build..."
  mkdir -p $BUILDDIR/osg && cd $BUILDDIR/osg
  rm -f CMakeCache.txt
  $CMAKEPROGRAM $SRCDIR/osg \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR
  make -j $MULTITHREADING
  make install
 )
}

#Build CPPDom
buildCPPDom() {(
  echo "Starting CPPDom build..."
  mkdir -p $BUILDDIR/cppdom && cd $BUILDDIR/cppdom
  rm -f CMakeCache.txt
  $CMAKEPROGRAM $SRCDIR/cppdom \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR
  make -j $MULTITHREADING
  make install
 )
}

#Build VRPN
buildVRPN() {(
  echo "Starting VRPN build..."
  mkdir -p $BUILDDIR/vrpn && cd $BUILDDIR/vrpn
  rm -f CMakeCache.txt
  $CMAKEPROGRAM $SRCDIR/vrpn \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR
  make -j $MULTITHREADING
  make install
 )
}

#Build VRJuggler
buildVRJuggler() {(
  echo "Starting VRJuggler build..."
  mkdir -p $BUILDDIR/vrjuggler && cd $BUILDDIR/vrjuggler
  rm -f CMakeCache.txt
  $CMAKEPROGRAM $SRCDIR/vrjuggler \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
  -DCMAKE_PREFIX_PATH=$INSTALLDIR \
  -DCPPDOM_INCLUDE_DIR=$SRCDIR/cppdom/ \
  -DBUILD_JAVA=OFF /
  -DBUILD_TESTING=OFF
  make -j $MULTITHREADING
  make install
 )
}

#Build VRJugglua
buildVRJugglua() {(
  echo "Starting VRJugglua build..."
  mkdir -p $BUILDDIR/vrjugglua && cd $BUILDDIR/vrjugglua
  rm -f CMakeCache.txt
  $CMAKEPROGRAM $SRCDIR/vrjugglua \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
  -DCMAKE_PREFIX_PATH=$BUILDDIR/vrjugger \
  make -j $MULTITHREADING
  make install
 )
}



#Start running through the build process

#buildQT
#buildCMake

#This is already part of VRJugglua
#buildLuaBind

#buildOSG
#buildCPPDom
#buildVRPN
buildVRJuggler
#buildVRJugglua
