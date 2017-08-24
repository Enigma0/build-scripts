PMP_ROOT="$HOME/git/pmp"
CORE_COUNT="16"

if [ "$1" == "Release" ] || [ "$1" == "Debug" ]; then
    SLN="$1"
    echo "$1 selected"
else
    echo "Use 'Release' or 'Debug'"
    exit
fi

sudo killall plexmediaplayer

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
#./clean
#./rebuild -j16 2>&1 | tee $HOME/mpv_build.log
./build -j$CORE_COUNT 2>&1 | tee $HOME/mpv_build.log
sudo ./install
sudo ldconfig

sudo -H pip install --upgrade pip
sudo -H pip install -U conan
pip install -U conan
conan remote add plex https://conan.plex.tv
conan remote update plex https://conan.plex.tv
conan search -r plex *@*/public

cd $PMP_ROOT

if [ ! -d "$PMP_ROOT/plex-media-player" ]; then
    git clone git://github.com/plexinc/plex-media-player
fi

cd $PMP_ROOT/plex-media-player
git pull plex-media-player
sudo rm -R build/
mkdir build
cd build
conan install ..
cmake -DCMAKE_BUILD_TYPE=$SLN -DCMAKE_EXPORT_COMPILE_COMMANDS=on -DQTROOT=/opt/Qt5.9.1/5.9.1/gcc_64 -DCMAKE_INSTALL_PREFIX=/usr/local/ .. 2>&1 | tee $HOME/pmp_build.log
make -j$CORE_COUNT 2>&1 | tee -a $HOME/pmp_build.log
sudo make install 2>&1 | tee -a $HOME/pmp_build.log

#cmake params
#-DCMAKE_EXPORT_COMPILE_COMMANDS=on
#-DLINUX_X11POWER=on
#-DQTROOT=/opt/Qt5.9.1/5.9.1/gcc_64
