#!/bin/sh
flutter channel beta
flutter upgrade
flutter config --enable-web
make || exit 1
echo moving
mv -f bin/* /usr/local/var/www/
