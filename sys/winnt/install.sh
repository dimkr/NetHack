#!/bin/sh -xe

# Copyright (c) Dima Krasner, 2020.
# NetHack may be freely redistributed.  See license for details.

# Installation script for the Windows TTY port.

install -D -m 755 $MESON_BUILD_ROOT/nethack.exe $DESTDIR/NetHack.exe
install -m 755 $MESON_BUILD_ROOT/recover.exe $DESTDIR/recover.exe

for i in $MESON_BUILD_ROOT/nhdat \
         $MESON_SOURCE_ROOT/doc/nethack.txt \
         $MESON_SOURCE_ROOT/doc/recover.txt \
         $MESON_SOURCE_ROOT/dat/license \
         $MESON_SOURCE_ROOT/doc/Guidebook.txt \
         $MESON_SOURCE_ROOT/dat/opthelp \
         $MESON_SOURCE_ROOT/sys/winnt/sysconf.template \
         $MESON_SOURCE_ROOT/sys/winnt/.nethackrc.template \
         $MESON_BUILD_ROOT/nhdefkey.dll
do
	install -m 644 $i $DESTDIR/`basename $i`
done

install -m 644 $MESON_SOURCE_ROOT/dat/symbols $DESTDIR/symbols.template

for i in perm record logfile xlogfile
do
	touch $DESTDIR/$i
done

for i in libstdc++-6.dll libgcc_s_seh-1.dll
do
	install -m 644 /usr/lib/gcc/x86_64-w64-mingw32/*-win32/$i $DESTDIR/$i
done
