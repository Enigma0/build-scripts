ROOT=$HOME/svn

sudo apt-get install subversion qt5-default

if [ ! -d "$ROOT" ]; then
  mkdir $HOME/svn
fi

if [ ! -d "$ROOT/radeon-profile" ]; then
  svn checkout https://github.com/marazmista/radeon-profile.git/trunk/radeon-profile
else
    svn update $ROOT/radeon-profile
fi

sudo killall radeon-profile
cd "$ROOT/radeon-profile"
make clean
qmake
make
sudo cp radeon-profile /usr/bin/radeon-profile

if [ ! -d "$ROOT/radeon-profile-daemon" ]; then
  svn checkout https://github.com/marazmista/radeon-profile-daemon.git/trunk/radeon-profile-daemon
else
    svn update $ROOT/radeon-profile-daemon
fi

sudo service radeon-profile-daemon stop
cd "$ROOT/radeon-profile-daemon"
svn update
make clean
qmake
make
sudo cp radeon-profile-daemon /usr/bin/radeon-profile-daemon
sudo service radeon-profile-daemon start

radeon-profile &
