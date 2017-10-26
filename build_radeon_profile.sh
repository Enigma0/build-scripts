ROOT="$HOME/svn"
QTROOT="qt5opt"
CORE_COUNT="16"

svn update
sudo apt-get install subversion qt5-default

if [ ! -d "$ROOT" ]; then
  mkdir "$HOME/svn"
fi

if [ ! -d "$ROOT/radeon-profile" ]; then
    svn checkout https://github.com/marazmista/radeon-profile.git/trunk/radeon-profile
else
    svn update $ROOT/radeon-profile
fi

sudo killall radeon-profile
cd "$ROOT/radeon-profile"
make clean
qmake -qt=$QTROOT
make -j$CORE_COUNT
sudo cp radeon-profile /usr/bin/radeon-profile
sudo cp "$ROOT/radeon-profile/extra/radeon-profile.desktop" "/usr/share/applications/"
sudo cp "$ROOT/radeon-profile/extra/radeon-profile.png" "/usr/share/icons/"

if [ ! -d "$ROOT/radeon-profile-daemon" ]; then
    svn checkout https://github.com/marazmista/radeon-profile-daemon.git/trunk/radeon-profile-daemon
else
    svn update $ROOT/radeon-profile-daemon
fi

if [ ! -f "/etc/systemd/system/radeon-profile-daemon.service" ]; then
  sudo cp "$ROOT/radeon-profile-daemon/extra/radeon-profile-daemon.service" "/etc/systemd/system/"
  sudo systemctl enable radeon-profile-daemon.service
fi

sudo service radeon-profile-daemon stop
cd "$ROOT/radeon-profile-daemon"
make clean
qmake -qt=$QTROOT
make -j$CORE_COUNT
sudo cp radeon-profile-daemon /usr/bin/radeon-profile-daemon
sudo service radeon-profile-daemon start

radeon-profile &
