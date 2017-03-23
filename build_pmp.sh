if [ "$1" = "Release" ] || [ "$1" = "Debug" ]; then
    SLN="$1"
    echo "$1 selected"
else
    echo "Use 'Release' or 'Debug'"
    exit
fi

cd ~/pmp/mpv-build
git pull
./update
./clean
./rebuild -j4
sudo ./install
sudo ldconfig

sudo -H pip install --upgrade pip
sudo -H pip install -U conan
pip install -U conan
conan remote update plex https://conan.plex.tv
conan search -r plex *@*/public

cd ~/pmp/plex-media-player
git pull
sudo rm -R build/
mkdir build
cd build
conan install ..
cmake -DCMAKE_BUILD_TYPE=$SLN -DCMAKE_EXPORT_COMPILE_COMMANDS=on -DLINUX_X11POWER=on -DQTROOT=/opt/Qt5.7.1/5.7/gcc_64/ -DCMAKE_INSTALL_PREFIX=/usr/local/ .. 2>&1 | tee pmp_build.log
make -j4
sudo make install
