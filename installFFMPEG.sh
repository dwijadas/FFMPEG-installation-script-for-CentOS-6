#!/bin/bash
# FFMPEG installation script
RED='\E[0;31m'
NC='\033[0m' # No Color
PATH_STR=':/usr/local/ffmpeg/bin'
PKG_CONF_PATH=':/usr/local/ffmpeg/lib/pkgconfig'
FILE1=/etc/profile
FFMPEG_HOME='/usr/local/ffmpeg'

function check_prerequisite
{
  if ! rpm -q "autoconf"; then
    echo "autoconf NOT FOUND..."
    echo "##############################"
    auto_conf=1
  else
    echo "autoconf FOUND..."
    auto_conf=0
    echo "##############################"
  fi

  if ! rpm -q "automake"; then
    echo "automake NOT FOUND..."
    echo "##############################"
    auto_make=1
  else
    echo "automake FOUND..."
    echo "##############################"
    auto_make=0
  fi

  if ! rpm -q "cmake"; then
    echo "cmake NOT FOUND..."
    echo "##############################"
    cmake=1
  else
    echo "cmake FOUND..."
  echo "##############################"
    cmake=0
  fi

  if ! rpm -q "freetype-devel"; then
    echo "freetype-devel NOT FOUND..."
    echo "##############################"
    freetype=1
  else
    echo "freetype-devel FOUND..."
    echo "##############################"
    freetype=0
  fi

  if ! rpm -q "gcc"; then
    echo "gcc NOT FOUND..."
    echo "##############################"
    gcc=1
  else
    echo "gcc FOUND..."
    echo "##############################"
    gcc=0
  fi

  if ! rpm -q "git"; then
    echo "git NOT FOUND..."
    echo "##############################"
    git=1
  else
    echo "git FOUND..."
    echo "##############################"
    git=0
  fi

  if ! rpm -q "libtool"; then
    echo "libtool NOT FOUND..."
    echo "##############################"
    libtool=1
  else
    echo "libtool FOUND..."
    echo "##############################"
    libtool=0
  fi

  if ! rpm -q "make"; then
    echo "make NOT FOUND..."
    echo "##############################"
    make=1
  else
    echo "make FOUND..."
    echo "##############################"
    make=0
  fi

  if ! rpm -q "mercurial"; then
    echo "mercurial NOT FOUND..."
    echo "##############################"
    mercurial=1
  else
    echo "mercurial FOUND..."
    echo "##############################"
    mercurial=0
  fi

  if ! rpm -q "nasm"; then
    echo "nasm NOT FOUND..."
    echo "##############################"
    nasm=1
  else
    echo "nasm FOUND..."
    echo "##############################"
    nasm=0
  fi

  if ! rpm -q "pkgconfig"; then
    echo "pkgconfig NOT FOUND..."
    echo "##############################"
    pkgconfig=1
  else
    echo "pkgconfig FOUND..."
    echo "##############################"
    pkgconfig=0
  fi

  if ! rpm -q "zlib-devel"; then
    echo "zlib-devel NOT FOUND..."
    echo "##############################"
    zlib=1
  else
    echo "zlib-devel FOUND..."
    echo "##############################"
    zlib=0
  fi
   echo "$auto_conf" "$auto_make" "$cmake" "$freetype" "$gcc" "$git" "$libtool" "$make"  "$mercurial" "$nasm" "$pkgconfig" "$zlib"
 if  [ $zlib -eq 1 ] || [ $pkgconfig -eq 1 ] || [ $nasm -eq 1 ] || [ $mercurial -eq 1 ] || [ $make -eq 1 ] || [ $libtool -eq 1 ] || [ $git -eq 1 ] || [ $gcc -eq 1 ] || [ $cmake -eq 1 ] || [ $freetype -eq 1 ] || [ $auto_make -eq 1 ] || [ $auto_conf -eq 1 ] ; then

	  echo "Do you want to install the prerequisites(Y/N) ?"
  	  read REPLY

 	  if [[ $REPLY =~ ^[Yy]$ ]];  then
   	 	 install_prerequisite $auto_conf $auto_make $cmake $freetype $gcc $git $libtool $make $mercurial $nasm $pkgconfig $zlib 
  	  fi
else
         echo "Pre-requisites packages are already installed"
fi

}

function install_prerequisite() {
   if [ "$1" == "1" ]; then
      echo "Installing autoconf..."
      yum install autoconf
   fi
   if [ "$2" == "1" ]; then
      echo "Installing automake..."
      yum install automake
   fi
   if [ "$3" == "1" ]; then
      echo "Installing cmake..."
      yum install cmake
   fi
   if [ "$4" == "1" ]; then
      echo "Installing freetype-devel..."
      yum install freetype-devel
   fi
   if [ "$5" == "1" ]; then
      echo "Installing gcc..."
      yum install gcc
      yum install gcc-c++
   fi
  
   if [ "$6" == "1" ]; then
      echo "Installing git..."
      yum install git
   fi 
   if [ "$7" == "1" ]; then
      echo "Installing libtool..."
      yum install libtool
   fi
   if [ "$8" == "1" ]; then
      echo "Installing make..."
      yum install make
   fi
   if [ "$9" == "1" ]; then
      echo "Installing mercurial..."
      yum install mercurial
   fi
   if [ "$10" == "00" ]; then
      echo "Installing nasm..."
      yum install nasm
   fi
   if [ "$11" == "00" ]; then
      echo "Installing pkgconfig..."
      yum install pkgconfig
   fi
   if [ "$12" == "00" ]; then
      echo "Installing zlib-devel..."
      yum install zlib-devel
   fi

}

function install_yasm() {
 echo "Checking whether YASM is installed..."
 echo "##############################"
 if ! rpm -q "yasm"; then
    echo "Installing YASM.."
    echo "##############################"
    yum install yasm
 else

    echo "YASM is already installed"
    echo "##############################"
 fi

}

function install_libx264() {
# mkdir /usr/src/ffmpeg
 cd /usr/src/ffmpeg
 git clone --depth 1 git://git.videolan.org/x264
 cd x264
 ./configure --prefix="$FFMPEG_HOME" --bindir="$FFMPEG_HOME/bin" --enable-static
 make
 make install
 make distclean
 ldconfig
 echo -e '\E[37;44m'"\033[1mlibx264 installation is complete\033[0m"

 echo "############################################################"

}

function install_libx265() {

 cd /usr/src/ffmpeg
 hg clone https://bitbucket.org/multicoreware/x265
 cd /usr/src/ffmpeg/x265/build/linux
 cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$FFMPEG_HOME" -DENABLE_SHARED:bool=off ../../source
 make
 make install
 ldconfig
 echo -e '\E[37;44m'"\033[1mlibx265 installation is complete\033[0m"

 echo "############################################################"

}

function install_libfdk_aac() {
 cd /usr/src/ffmpeg
 git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
 cd fdk-aac
 autoreconf -fiv
 ./configure --prefix="$FFMPEG_HOME" --disable-shared
 make
 make install
 make distclean
 ldconfig
 echo -e '\E[37;44m'"\033[1mlibfdk_aac installation is complete\033[0m"

 echo "############################################################"

}

function install_libmp3lame() {
cd /usr/src/ffmpeg
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$FFMPEG_HOME" --bindir="$FFMPEG_HOME/bin" --disable-shared --enable-nasm
make
make install
make distclean
ldconfig
echo -e '\E[37;44m'"\033[1mlibmp3lame installation is complete\033[0m"

echo "############################################################"

}

function install_libopus() {
cd /usr/src/ffmpeg
git clone http://git.opus-codec.org/opus.git
cd opus
autoreconf -fiv
./configure --prefix="$FFMPEG_HOME" --disable-shared
make
make install
make distclean
ldconfig
echo -e '\E[37;44m'"\033[1mlibopus installation is complete\033[0m"

echo "############################################################"

}


function install_libogg(){
cd /usr/src/ffmpeg
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix="$FFMPEG_HOME" --disable-shared
make
make install
make distclean
ldconfig
echo -e '\E[37;44m'"\033[1mlibogg installation is complete\033[0m"

echo "############################################################"
}

function install_libvorbis() {
cd /usr/src/ffmpeg
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
LDFLAGS="-L$FFMPEG_HOME/lib" 
CPPFLAGS="-I$FFMPEG_HOME/include" 
./configure --prefix="$FFMPEG_HOME" --with-ogg="$FFMPEG_HOME" --disable-shared
make
make install
make distclean
ldconfig
echo -e '\E[37;44m'"\033[1mlibvorbis installation is complete\033[0m"

echo "############################################################"
}

function install_libvpx() {
cd /usr/src/ffmpeg
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="$FFMPEG_HOME" --disable-examples
make
make install
make clean
ldconfig
echo -e '\E[37;44m'"\033[1mlibvpx installation is complete\033[0m"

echo "############################################################"
}

function install_ffmpeg() {
#source /etc/profile
export PKG_CONFIG_PATH=/usr/local/ffmpeg/lib/pkgconfig/
cd /usr/src/ffmpeg
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
./configure --prefix="$FFMPEG_HOME" --extra-cflags="-I$FFMPEG_HOME/include" --extra-ldflags="-L$FFMPEG_HOME/lib" --bindir="$FFMPEG_HOME/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame  --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265  --enable-libopus 
make
make install
make distclean
hash -r
echo "############################################################"
}

function setup_env () {

echo "############################################################"
echo -e "\033[1m Creating source location inside /usr/local\033[0m"
dir="/usr/src/ffmpeg"

echo "##############################"

if [[ ! -e $dir ]]; then
    mkdir -p $dir
elif [[ ! -d $dir ]]; then
    echo "$dir already exists but is not a directory" 1>&2
echo "####################################################"
fi

#echo -e ${RED} " FFMPEG installation script will compile and install FFMPEG and its dependencies ${NC}\n"

echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/ffmpeg/lib/pkgconfig" >> /etc/profile

	if grep -q $PKG_CONF_PATH "$FILE1";
     		then
		     echo "Written FFMPEG Package config path in /etc/profile:"
                     echo "###################################################"
	else
		     echo "Error: Could not write FFMPEG package config PATH variable in /etc/profile: "
		     echo "Exiting..."
                     echo "##########################################################################"
		     exit 0
	fi

echo "export PATH=$PATH:/usr/local/ffmpeg/bin" >> /etc/profile
	
	if grep -q $PATH_STR "$FILE1";
                then
                     echo "Written FFMPEG path in /etc/profile:"
                     echo "####################################"
        else
                     echo "Error: Could not write FFMPEG  PATH variable in /etc/profile: "
                     echo "Exiting..."
                     echo "############################################################"
                     exit 0
        fi


# echo -e '\E[37;44m'"\033[1mContact List\033[0m"
}

setup_env
check_prerequisite
install_yasm
install_libx264
install_libx265
install_libfdk_aac
install_libmp3lame
install_libopus
install_libogg
install_libvorbis
install_libvpx
install_ffmpeg

echo -e '\E[37;44m'"\033[1mThe FFMPEG installation is complete.\033[0m"

echo "The FFMPEG home directory is "$FFMPEG_HOME"";
echo "The  FFMPEG bin directory is "$FFMPEG_HOME"/bin"
echo "The FFMPEG lib directory is "$FFMPEG_HOME"/lib"

ffmpeg
