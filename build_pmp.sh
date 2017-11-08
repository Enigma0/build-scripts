DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
QT_ROOT="/opt/Qt5.9.1"
QT_SUBPATH="/5.9.1/gcc_64"
PMP_ROOT="$HOME/git/pmp"
CORE_COUNT="grep -c ^processor /proc/cpuinfo"

if [ "$1" == "help" ]; then
    echo "Example usage:"
    echo "./build_pmp.sh release rebuild 220"
    echo "./build_pmp.sh debug rebuild tv2"
    echo "./build_pmp.sh release build base"
    exit
fi

if [ "$1" == "release" ] || [ "$1" == "debug" ]; then
    SLN="$1"
    echo "$1 selected"
else
    echo "First parameter requires: 'release' or 'debug'"
    exit
fi

if [ "$2" == "rebuild" ] || [ "$2" == "build" ]; then
    PROFILE="$2"
    echo "$2 selected"
else
    echo "Second parameter requires: 'rebuild' or 'build'"
    exit
fi

if [ "$3" == "220" ] || [ "$3" == "tv2" ] || [ "$3" == "base" ]; then
    CONFIG="$3"
    echo "$3 selected"
else
    echo "Third parameter requires: '220', 'tv2' or 'base'"
    exit
fi

cd $DIR
svn update
sudo killall plexmediaplayer

if [ ! -f "/usr/share/applications/plexmediaplayer.desktop" ]; then
    sudo cp plexmediaplayer.desktop /usr/share/applications/
fi
sudo cp Plex*.png /usr/share/icons/

sudo apt-get install autoconf automake libtool libharfbuzz-dev libfreetype6-dev \
libfontconfig1-dev libx11-dev libxrandr-dev libvdpau-dev libva-dev mesa-common-dev \
libegl1-mesa-dev yasm libasound2-dev libpulse-dev libuchardet-dev zlib1g-dev \
libfribidi-dev git libgnutls*-dev libgl1-mesa-dev libsdl2-dev cmake

if [ ! -d "$QT_ROOT" ]; then
    cd $HOME/Downloads
    wget http://download.qt.io/official_releases/qt/5.9/5.9.1/qt-opensource-linux-x64-5.9.1.run
    chmod +x qt-opensource-linux-x64-5.9.1.run
    sudo ./qt-opensource-linux-x64-5.9.1.run    
fi

if [ ! -d "$HOME/git" ]; then
    cd $HOME
    mkdir git
fi

if [ ! -d "$PMP_ROOT" ]; then
    cd $HOME/git
    mkdir pmp
fi

cd $PMP_ROOT

if [ ! -d "$PMP_ROOT/mpv-build" ]; then
    git clone https://github.com/mpv-player/mpv-build.git
fi

cd $PMP_ROOT/mpv-build
git pull
echo --enable-libmpv-shared > mpv_options
#echo --disable-cplayer >> mpv_options
./update

if [ "$PROFILE" == "rebuild" ]; then
    ./clean
    ./rebuild -j$CORE_COUNT 2>&1 | tee $HOME/mpv_build.log
elif [ "$PROFILE" == "build" ]; then
    ./build -j$CORE_COUNT 2>&1 | tee $HOME/mpv_build.log
fi

sudo ./install
sudo ldconfig

sudo -H pip install --upgrade pip
sudo -H pip install -U conan
pip install -U conan
conan remote add plex https://conan.plex.tv
conan remote update plex https://conan.plex.tv
#conan search -r plex *@*/public

cd $PMP_ROOT

if [ "$CONFIG" == "base" ]; then
    if [ ! -d "$PMP_ROOT/plex-media-player" ]; then
        git clone git://github.com/plexinc/plex-media-player
    fi
    
    cd $PMP_ROOT/plex-media-player
    echo "'base' configuration selected"    
elif  "$CONFIG" == "tv2" ]; then
    if [ ! -d "$PMP_ROOT/tv2" ]; then
        git clone git://github.com/plexinc/plex-media-player -b tv2 tv2
    fi
    
    cd $PMP_ROOT/tv2
    echo "'tv2' configuration selected"
elif  "$CONFIG" == "220" ]; then
    if [ ! -d "$PMP_ROOT/dist-2.2.0-rc" ]; then
        git clone git://github.com/plexinc/plex-media-player -b dist-2.2.0-rc dist-2.2.0-rc
    fi

    cd $PMP_ROOT/dist-2.2.0-rc
    echo "'220' configuration selected"
fi

git pull

if [ "$PROFILE" == "rebuild" ]; then
    sudo rm -R build/
    mkdir build
fi

cd build
conan install ..
cmake -DCMAKE_BUILD_TYPE=$SLN -DCMAKE_EXPORT_COMPILE_COMMANDS=on -DQTROOT=$QT_ROOT$QT_SUBPATH -DLINUX_X11POWER=on -DCMAKE_INSTALL_PREFIX=/usr/local/ .. 2>&1 | tee $HOME/pmp_build.log
make -j$CORE_COUNT 2>&1 | tee -a $HOME/pmp_build.log
sudo make install 2>&1 | tee -a $HOME/pmp_build.log

#cmake params
#-DCMAKE_EXPORT_COMPILE_COMMANDS=on
#-DLINUX_X11POWER=on
#-DQTROOT=/opt/Qt5.9.1/5.9.1/gcc_64
