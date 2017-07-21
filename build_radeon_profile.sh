sudo killall radeon-profile
cd ~/radeon-profile/radeon-profile
git pull
qmake && make
sudo cp radeon-profile /usr/bin/radeon-profile

sudo service radeon-profile-daemon stop
cd ~/radeon-profile-daemon/radeon-profile-daemon
git pull
qmake && make
sudo cp radeon-profile-daemon /usr/bin/radeon-profile-daemon
sudo service radeon-profile-daemon start
radeon-profile &
