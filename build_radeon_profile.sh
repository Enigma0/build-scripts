ROOT="$HOME"
#QTROOT="qt5opt"
CORE_COUNT="grep -c ^processor /proc/cpuinfo"

svn update
sudo apt-get install git qt5-default libqt5charts5* qt5-base libxrandr-dev libdrm2 libdrm-dev libdrm-radeon1 libdrm-common

#if [ ! -d "$ROOT" ]; then
#  mkdir "$HOME/svn"
#fi

if [ ! -d "$ROOT/radeon-profile" ]; then
    git clone https://github.com/marazmista/radeon-profile.git $ROOT/radeon-profile
else
    git -C "$ROOT/radeon-profile" pull
fi

sudo killall radeon-profile
cd "$ROOT/radeon-profile/radeon-profile"
make clean
#qmake -qt=$QTROOT
qmake
make -j$CORE_COUNT
sudo cp "radeon-profile" "/usr/bin/radeon-profile"
sudo cp "$ROOT/radeon-profile/radeon-profile/extra/radeon-profile.desktop" "/usr/share/applications/"
sudo cp "$ROOT/radeon-profile/radeon-profile/extra/radeon-profile.png" "/usr/share/icons/"

if [ ! -d "$ROOT/radeon-profile-daemon" ]; then
    git clone https://github.com/marazmista/radeon-profile-daemon.git $ROOT/radeon-profile-daemon
else
    git -C "$ROOT/radeon-profile-daemon" pull
fi

if [ ! -f "/etc/systemd/system/radeon-profile-daemon.service" ]; then
  sudo cp "$ROOT/radeon-profile-daemon/radeon-profile-daemon/extra/radeon-profile-daemon.service" "/etc/systemd/system/"
  sudo systemctl enable radeon-profile-daemon.service
fi

sudo service radeon-profile-daemon stop
cd "$ROOT/radeon-profile-daemon/radeon-profile-daemon"
make clean
#qmake -qt=$QTROOT
qmake
make -j$CORE_COUNT
sudo cp "target/radeon-profile-daemon" "/usr/bin/radeon-profile-daemon"
sudo service radeon-profile-daemon start

radeon-profile &
