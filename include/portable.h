/* Copyright (c) Dima Krasner, 2019. */
/* NetHack may be freely redistributed.  See license for details. */

#ifndef PORTABLE_H
#define PORTABLE_H

#ifdef MESON
#	include <arpa/inet.h>
#	define Htonl htonl
#	define Ntohl ntohl
#	define Htons htons
#	define Ntohs ntohs
#else
#	define Htonl(x) x
#	define Ntohl(x) x
#	define Htons(x) x
#	define Ntohs(x) x
#endif

#endif /* PORTABLE_H */
