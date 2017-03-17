sudo killall radeon-profile
cd ~/radeon-profile/radeon-profile
git pull
qmake && make
sudo cp radeon-profile /usr/bin/radeon-profile

cd ~/radeon-profile-daemon/radeon-profile-daemon
git pull
qmake-qt4 && make
sudo cp radeon-profile-daemon /usr/bin/radeon-profile-daemon
sudo service radeon-profile-daemon restart
radeon-profile &
