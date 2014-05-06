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
#Hmm, I guess our version actually is relatively up-to-date, this is not needed
#https://qt-project.org/wiki/Building_Qt_5_from_Git
#http://stackoverflow.com/questions/5587141/recommended-flags-for-a-minimalistic-qt-build
#buildQT() {(
#  echo "Starting QT build..."
#  cd $SRCDIR/qt
#  ./configure -opensource -release -confirm-license -fast -no-script -no-scripttools -no-qt3support -no-phonon -no-phonon-backend -no-webkit -no-audio-backend -no-multimedia -nomake demos -nomake examples -nomake tests -prefix $BUILDDIR/qt
#  gmake -j $MULTITHREADING
#  gmake install
# )
#}

#Build CMake
buildCMake() {(
  echo "Starting CMake build..."
  mkdir -p $BUILDDIR/cmake
  cd $SRCDIR/cmake
  ./bootstrap --prefix=$BUILDDIR/cmake --qt-gui
  make -j $MULTITHREADING
  make install
 )
}



#Build OSG
buildOSG() {(
  echo "Starting OSG build..."
  mkdir -p $BUILDDIR/osg && cd $BUILDDIR/osg
  rm -f CMakeCache.txt
  $CMAKEPROGRAM $SRCDIR/osg \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_OSG_WRAPPERS=ON \
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
#DBoost_NO_BOOST_CMAKE=ON
#This gets around a bug in RHEL6: https://bugzilla.redhat.com/show_bug.cgi?id=849791
#where it uses an incorrect Boost.cmake file.
buildVRJuggler() {(
  echo "Starting VRJuggler build..."
  mkdir -p $BUILDDIR/vrjuggler && cd $BUILDDIR/vrjuggler
  rm -f CMakeCache.txt
  $CMAKEPROGRAM $SRCDIR/vrjuggler \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
  -DBUILD_JAVA=OFF \
  -DBUILD_TESTING=OFF \
  -DGMTL_INCLUDE_DIR=$SRCDIR/gmtl \
  -DBoost_NO_BOOST_CMAKE=ON \
  -DCMAKE_PREFIX_PATH=\"$INSTALLDIR;$INSTALLDIR/include/cppdom-1.2.0\"
  make -j $MULTITHREADING
  make install
 )
}

#Build VRJugglua
buildVRJugglua() {(
  echo "Starting VRJugglua build..."
  mkdir -p $BUILDDIR/vr-jugglua && cd $BUILDDIR/vr-jugglua
  rm -f CMakeCache.txt
  $CMAKEPROGRAM $SRCDIR/vr-jugglua \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
  -DCMAKE_LIBRARY_PATH=$INSTALLDIR \
  -DBUILD_WITHOUT_TERMINAL=OFF \
  -DBoost_NO_BOOST_CMAKE=ON \
  -DGMTL_INCLUDE_DIR=$SRCDIR/gmtl \
  -DCMAKE_PREFIX_PATH=\"$INSTALLDIR;$SRCDIR/osg/include\"
  make -j $MULTITHREADING
  make install
 )
}



#Start running through the build process

#QT is apparently fairly up-to-date, this is not needed
#buildQT

buildCMake


buildOSG
buildCPPDom
buildVRPN
buildVRJuggler
buildVRJugglua
