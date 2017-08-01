cd ~/xbmc
git pull
cd kodi-build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build . -- VERBOSE=1 -j16
sudo make install -j16
