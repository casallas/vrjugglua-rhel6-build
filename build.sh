#!/bin/sh -E
#Using Bourne Shell


#The submodules for the various dependencies should already be setup
#This is a good resource for submodules
#http://gaarai.com/2009/04/20/git-submodules-adding-using-removing-and-updating/


BASEDIR=$(cd $(dirname $0) && pwd)
SRCDIR=$BASEDIR/submodules
BUILDDIR=$BASEDIR/build


#Create build directory if it doesn't exist
if [ ! -d "build" ]; then
    echo "Creating build directory."
    mkdir "build"
fi



#Build QT
#https://qt-project.org/wiki/Building_Qt_5_from_Git
buildQT() {(
  echo "Starting QT build..."
  cd $SRCDIR/qt
  ./configure -opensource -confirm-license -fast -no-phonon -no-phonon-backend -no-webkit -no-multimedia -nomake examples -nomake tests -prefix $BUILDDIR/qt
  gmake -j 8
  gmake install
 )
}

#Build CMake
buildCMake() {(
  echo "Starting CMake build..."
  mkdir -p $BUILDDIR/cmake
  cd $SRCDIR/cmake
  ./bootstrap --prefix=$BUILDDIR/cmake
  make -j 8
  make install
  CMAKEPROGRAM=$BUILDDIR/cmake/bin/cmake
 )
}


#Build LuaBind
buildLuaBind() {(
  echo "Starting LuaBind build..."
  mkdir -p $BUILDDIR/luabind && cd $BUILDDIR/luabind
  $CMAKEPROGRAM $SRCDIR/luabind \
  -DCMAKE_BUILD_TYPE=Release
  make -j 8
 )
}




#Start running through the build process

#buildQT
buildCMake
buildLuaBind
