PMP_ROOT=$HOME/git/pmp

if [ "$1" == "Release" ] || [ "$1" == "Debug" ]; then
    SLN="$1"
    echo "$1 selected"
else
    echo "Use 'Release' or 'Debug'"
    exit
fi

sudo killall plexmediaplayer

cd $PMP_ROOT/mpv-build
git pull
./update
#./clean
#./rebuild -j16 2>&1 | tee $HOME/mpv_build.log
./build -j16 2>&1 | tee $HOME/mpv_build.log
sudo ./install
sudo ldconfig

sudo -H pip install --upgrade pip
sudo -H pip install -U conan
pip install -U conan
conan remote add plex https://conan.plex.tv
conan remote update plex https://conan.plex.tv
conan search -r plex *@*/public

cd $PMP_ROOT/plex-media-player
git pull
sudo rm -R build/
mkdir build
cd build
conan install ..
cmake -DCMAKE_BUILD_TYPE=$SLN -DCMAKE_EXPORT_COMPILE_COMMANDS=on -DQTROOT=/opt/Qt5.9.1/5.9.1/gcc_64 -DCMAKE_INSTALL_PREFIX=/usr/local/ .. 2>&1 | tee $HOME/pmp_build.log
make -j16 2>&1 | tee -a $HOME/pmp_build.log
sudo make install 2>&1 | tee -a $HOME/pmp_build.log

#cmake params
#-DCMAKE_EXPORT_COMPILE_COMMANDS=on
#-DLINUX_X11POWER=on
#-DQTROOT=/opt/Qt5.9.1/5.9.1/gcc_64