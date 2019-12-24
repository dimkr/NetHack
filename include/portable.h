/* Copyright (c) Dima Krasner, 2019. */
/* NetHack may be freely redistributed.  See license for details. */

#ifndef PORTABLE_H
#define PORTABLE_H

#ifdef MESON
#	ifdef _WIN32
#		include <winsock2.h>
#	elif defined(__DJGPP__)
#		include <netinet/in.h>
#	else
#		include <arpa/inet.h>
#	endif
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
