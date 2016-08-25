#!/bin/bash

#If installed, stop
sudo systemctl stop avahi-daemon
sudo systemctl stop netatalk

# Prereq's
sudo apt-get --yes --force-yes install \
build-essential \
libevent-dev \
libssl-dev \
libgcrypt11-dev \
libkrb5-dev \
libpam0g-dev \
libwrap0-dev \
libdb-dev \
libtdb-dev \
libmysqlclient-dev \
avahi-daemon \
libavahi-client-dev \
libacl1-dev \
libldap2-dev \
libcrack2-dev \
systemtap-sdt-dev \
libdbus-1-dev \
libdbus-glib-1-dev \
libglib2.0-dev \
libio-socket-inet6-perl \
tracker \
libtracker-sparql-1.0-dev \
libtracker-miner-1.0-dev

# Get 3.1.9
wget https://sourceforge.net/projects/netatalk/files/netatalk/3.1.9/netatalk-3.1.9.tar.bz2
tar xvf netatalk-3.1.9.tar.bz2
cd netatalk-3.1.9

./configure \
        --with-init-style=debian-systemd \
        --without-libevent \
        --without-tdb \
        --with-cracklib \
        --enable-krbV-uam \
        --with-pam-confdir=/etc/pam.d \
        --with-dbus-daemon=/usr/bin/dbus-daemon \
        --with-dbus-sysconf-dir=/etc/dbus-1/system.d \
        --with-tracker-pkgconfig-version=1.0

make
sudo make install

sudo mv -v /usr/local/etc/afp.conf /usr/local/etc/afp.conf_`date +%Y%m%d_%H%M`

sudo sh -c 'echo "[DIGIKAM_ROOT_ALBUM]" >>/usr/local/etc/afp.conf'
sudo sh -c 'echo "path = /DISK1/DIGIKAM_DATA/DIGIKAM_ROOT_ALBUM/" >> /usr/local/etc/afp.conf'
sudo sh -c 'echo "spotlight = no" >> /usr/local/etc/afp.conf'

sudo cat /usr/local/etc/afp.conf

sudo systemctl enable avahi-daemon
sudo systemctl enable netatalk
sudo systemctl start avahi-daemon
sudo journalctl -u avahi-daemon
sudo systemctl start netatalk
sudo journalctl -u avahi-daemon
