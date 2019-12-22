# Copyright (c) Dima Krasner, 2019.
# NetHack may be freely redistributed.  See license for details.

# CI flow for DOS Meson port.

dnf install -y gcc gcc-c++ python3 bison flex unzip
curl -Lo ninja-linux.zip https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-linux.zip
unzip ninja-linux.zip
mv -f ninja /usr/local/bin/
pip3 install meson
curl -o djcrx-2.05-5.x86_64.rpm https://mirror.koddos.net/djgpp/rpms/djcrx-2.05-5.x86_64.rpm
dnf install -y djcrx-2.05-5.x86_64.rpm
curl -o djcross-binutils-2.30-1ap.x86_64.rpm https://mirror.koddos.net/djgpp/rpms/djcross-binutils-2.30-1ap.x86_64.rpm
dnf install -y djcross-binutils-2.30-1ap.x86_64.rpm
curl -o djcross-gcc-9.2.0-1ap.x86_64.rpm https://mirror.koddos.net/djgpp/rpms/djcross-gcc-9.2.0/djcross-gcc-9.2.0-1ap.x86_64.rpm
dnf install -y djcross-gcc-9.2.0-1ap.x86_64.rpm
curl -o djcross-gcc-c++-9.2.0-1ap.x86_64.rpm https://mirror.koddos.net/djgpp/rpms/djcross-gcc-9.2.0/djcross-gcc-c++-9.2.0-1ap.x86_64.rpm
dnf install -y djcross-gcc-c++-9.2.0-1ap.x86_64.rpm
meson --cross-file=sys/msdos/msdos.cross build
ninja -C build
