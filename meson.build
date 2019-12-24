# Copyright (c) Dima Krasner, 2019.
# NetHack may be freely redistributed.  See license for details.

# Meson build system definitions with the Linux ncurses port as the default.

project('nethack', 'c', 'cpp')

hackdir = join_paths('/',
                     get_option('localstatedir'),
                     'games/nethack')

add_global_arguments('-DMESON',
                     '-DNOTPARMDECL',
                     '-DDLB',
                     '-DTIMED_DELAY',
                     '-DHACKDIR="@0@"'.format(hackdir),
                     '-DCONFIG_ERROR_SECURE=FALSE',
                     language: ['c', 'cpp'])

add_global_arguments('-std=c++11',
                     language: 'cpp')

win_deps = []

if not meson.is_cross_build()
	win_deps += dependency('ncurses')

	gzip = find_program('gzip')
	add_global_arguments('-DCOMPRESS="@0@"'.format(gzip.path()),
	                     '-DCOMPRESS_EXTENSION=".gz"',
	                     '-DCURSES_GRAPHICS',
	                     '-DSECURE',
	                     '-DSYSCF',
	                     '-DSYSCF_FILE="@0@/sysconf"'.format(hackdir),
	                     language: ['c', 'cpp'])
endif

curses_srcs = [
	'win/curses/cursmain.c',
	'win/curses/curswins.c',
	'win/curses/cursmisc.c',
	'win/curses/cursdial.c',
	'win/curses/cursstat.c',
	'win/curses/cursinit.c',
	'win/curses/cursmesg.c',
	'win/curses/cursinvt.c',
]

posix_regex_srcs = [
	'sys/share/posixregex.c'
]

linux_srcs = [
	'sys/unix/unixmain.c',
	'sys/unix/unixunix.c',
	'sys/unix/unixres.c',
	'sys/share/ioctl.c',
	'sys/share/unixtty.c'
]

win_srcs = meson.get_cross_property('win_srcs', curses_srcs)
sys_srcs = meson.get_cross_property('sys_srcs', linux_srcs)
regex_srcs = meson.get_cross_property('regex_srcs', posix_regex_srcs)

add_global_arguments('-DMESON',
                     '-DNOTPARMDECL',
                     '-DDLB',
                     language: ['c', 'cpp'],
                     native: true)

includes = [include_directories('include')]

if meson.is_cross_build()
	includes += [include_directories(meson.get_cross_property('sys_dir'))]

	if meson.get_cross_property('pdcurses', false)
		add_global_arguments('-DPDCURSES',
		                     '-DCURSES_GRAPHICS',
		                     language: ['c', 'cpp'])
		includes += [include_directories('pdcurses')]
		win_srcs += curses_srcs
		win_srcs += ['pdcurses/pdcurses/addch.c', 'pdcurses/pdcurses/addchstr.c', 'pdcurses/pdcurses/addstr.c', 'pdcurses/pdcurses/attr.c', 'pdcurses/pdcurses/beep.c', 'pdcurses/pdcurses/bkgd.c', 'pdcurses/pdcurses/border.c', 'pdcurses/pdcurses/clear.c', 'pdcurses/pdcurses/color.c', 'pdcurses/pdcurses/delch.c', 'pdcurses/pdcurses/deleteln.c', 'pdcurses/pdcurses/getch.c', 'pdcurses/pdcurses/getstr.c', 'pdcurses/pdcurses/getyx.c', 'pdcurses/pdcurses/inch.c', 'pdcurses/pdcurses/inchstr.c', 'pdcurses/pdcurses/initscr.c', 'pdcurses/pdcurses/inopts.c', 'pdcurses/pdcurses/insch.c', 'pdcurses/pdcurses/insstr.c', 'pdcurses/pdcurses/instr.c', 'pdcurses/pdcurses/kernel.c', 'pdcurses/pdcurses/keyname.c', 'pdcurses/pdcurses/mouse.c', 'pdcurses/pdcurses/move.c', 'pdcurses/pdcurses/outopts.c', 'pdcurses/pdcurses/overlay.c', 'pdcurses/pdcurses/pad.c', 'pdcurses/pdcurses/panel.c', 'pdcurses/pdcurses/printw.c', 'pdcurses/pdcurses/refresh.c', 'pdcurses/pdcurses/scanw.c', 'pdcurses/pdcurses/scr_dump.c', 'pdcurses/pdcurses/scroll.c', 'pdcurses/pdcurses/slk.c', 'pdcurses/pdcurses/termattr.c', 'pdcurses/pdcurses/touch.c', 'pdcurses/pdcurses/util.c', 'pdcurses/pdcurses/window.c', 'pdcurses/pdcurses/debug.c']
	endif
else
	gdb = find_program('gdb', required: false)
	if gdb.found()
		add_global_arguments('-DDUMPLOG',
		                     language: ['c', 'cpp'])
	endif
endif

makedefs = executable('makedefs',
                      'util/makedefs.c', 'src/monst.c', 'src/objects.c',
                      include_directories: includes,
                      native: true)

foreach letter, files: {
	'o': ['onames.h'],
	'z': ['vis_tab.c', 'vis_tab.h'],
	'v': ['date.h', 'options'],
	's': ['bogusmon', 'epitaph', 'engrave'],
	'e': ['dungeon.pdf'],
	'd': ['data'],
	'r': ['rumors'],
	'q': ['quest.dat'],
	'h': ['oracles'],
	'p': ['pm.h']
}
	target = 'makedefs_' + letter
	set_variable(target,
	             custom_target(target,
	                           output: files,
	                           command : [makedefs, '-' + letter]))
endforeach

yacc = find_program('bison')

dgn_yacc = custom_target('dgn_yacc',
                         output : ['dgn_comp.c', 'dgn_comp.h'],
                         input: 'util/dgn_comp.y',
                         command : [yacc, '-d', '-o', '@OUTPUT0@', '@INPUT@'])

flex = find_program('flex')

dgn_lex = custom_target('dgn_lex',
                        output : ['dgn_lex.c', 'dgn_lex.h'],
                        input: 'util/dgn_comp.l',
                        command : [flex, '-o', '@OUTPUT0@', '--header-file=@OUTPUT1@', '@INPUT@'])

dgn_comp = executable('dgn_comp',
                      makedefs_v[0], dgn_yacc[0], dgn_lex[0], 'util/dgn_main.c', 'src/alloc.c', 'util/panic.c',
                      include_directories: includes,
                      native: true)

compiled_dungeon = custom_target('dungeon_comp',
                                 output: 'dungeon',
                                 input: makedefs_e,
                                 command : [dgn_comp, '@INPUT@'])

tilemap = executable('tilemap',
                     makedefs_p, 'win/share/tilemap.c',
                     include_directories: includes,
                     native: true)

tile = custom_target('tile',
                     output: 'tile.c',
                     command : [tilemap])
if target_machine.system() == 'windows'
	win_srcs += [tile]
endif

nethack = executable('nethack',
                     makedefs_p,
                     makedefs_v[0],
                     makedefs_o,
                     makedefs_z[0],
                     'src/monst.c',
                     'src/objects.c',
                     'src/allmain.c',
                     'src/alloc.c',
                     'src/apply.c',
                     'src/artifact.c',
                     'src/attrib.c',
                     'src/ball.c',
                     'src/bones.c',
                     'src/botl.c',
                     'src/cmd.c',
                     'src/dbridge.c',
                     'src/decl.c',
                     'src/detect.c',
                     'src/dig.c',
                     'src/display.c',
                     'src/dlb.c',
                     'src/do.c',
                     'src/do_name.c',
                     'src/do_wear.c',
                     'src/dog.c',
                     'src/dogmove.c',
                     'src/dokick.c',
                     'src/dothrow.c',
                     'src/drawing.c',
                     'src/dungeon.c',
                     'src/eat.c',
                     'src/end.c',
                     'src/engrave.c',
                     'src/exper.c',
                     'src/explode.c',
                     'src/extralev.c',
                     'src/files.c',
                     'src/fountain.c',
                     'src/hack.c',
                     'src/hacklib.c',
                     'src/invent.c',
                     'src/isaac64.c',
                     'src/light.c',
                     'src/lock.c',
                     'src/mail.c',
                     'src/makemon.c',
                     'src/mapglyph.c',
                     'src/mcastu.c',
                     'src/mhitm.c',
                     'src/mhitu.c',
                     'src/minion.c',
                     'src/mklev.c',
                     'src/mkmap.c',
                     'src/mkmaze.c',
                     'src/mkobj.c',
                     'src/mkroom.c',
                     'src/mon.c',
                     'src/mondata.c',
                     'src/monmove.c',
                     'src/mplayer.c',
                     'src/mthrowu.c',
                     'src/muse.c',
                     'src/music.c',
                     'src/o_init.c',
                     'src/objnam.c',
                     'src/options.c',
                     'src/pager.c',
                     'src/pickup.c',
                     'src/pline.c',
                     'src/polyself.c',
                     'src/potion.c',
                     'src/pray.c',
                     'src/priest.c',
                     'src/quest.c',
                     'src/questpgr.c',
                     'src/read.c',
                     'src/rect.c',
                     'src/region.c',
                     'src/restore.c',
                     'src/rip.c',
                     'src/rnd.c',
                     'src/role.c',
                     'src/rumors.c',
                     'src/save.c',
                     'src/shk.c',
                     'src/shknam.c',
                     'src/sit.c',
                     'src/sounds.c',
                     'src/sp_lev.c',
                     'src/spell.c',
                     'src/sys.c',
                     'src/steal.c',
                     'src/steed.c',
                     'src/teleport.c',
                     'src/timeout.c',
                     'src/topten.c',
                     'src/track.c',
                     'src/trap.c',
                     'src/u_init.c',
                     'src/uhitm.c',
                     'src/vault.c',
                     'src/vision.c',
                     'src/weapon.c',
                     'src/were.c',
                     'src/wield.c',
                     'src/windows.c',
                     'src/wizard.c',
                     'src/worm.c',
                     'src/worn.c',
                     'src/write.c',
                     'src/zap.c',
                     'win/tty/getline.c',
                     'win/tty/termcap.c',
                     'win/tty/topl.c',
                     'win/tty/wintty.c',
                     'src/version.c',
                     sys_srcs,
                     win_srcs,
                     regex_srcs,
                     include_directories: includes,
                     dependencies: win_deps,
                     install: true)

recover = executable('recover',
                     'util/recover.c',
                     include_directories: includes,
                     install: true)

lev_yacc = custom_target('lev_yacc',
                         output : ['lev_comp.c', 'lev_comp.h'],
                         input: 'util/lev_comp.y',
                         command : [yacc, '-d', '-o', '@OUTPUT0@', '@INPUT@'])

lev_lex = custom_target('lev_lex',
                        output : ['lev_lex.c', 'lev_lex.h'],
                        input: 'util/lev_comp.l',
                        command : [flex, '-o', '@OUTPUT0@', '--header-file=@OUTPUT1@', '@INPUT@'])

lev_comp = executable('lev_comp',
                      makedefs_p, lev_yacc, lev_lex, 'util/lev_main.c', 'src/alloc.c', 'util/panic.c', 'src/drawing.c', 'src/decl.c', 'src/monst.c', 'src/objects.c',
                      include_directories: includes,
                      native: true)

levels = {
	'bigroom': ['bigrm-1.lev', 'bigrm-2.lev', 'bigrm-3.lev', 'bigrm-4.lev', 'bigrm-5.lev', 'bigrm-6.lev', 'bigrm-7.lev', 'bigrm-8.lev', 'bigrm-9.lev', 'bigrm-10.lev'],
	'endgame': ['air.lev', 'astral.lev', 'earth.lev', 'fire.lev', 'water.lev'],
	'gehennom': ['asmodeus.lev', 'baalz.lev', 'juiblex.lev', 'orcus.lev', 'sanctum.lev', 'valley.lev'],
	'medusa': ['medusa-1.lev', 'medusa-2.lev', 'medusa-3.lev', 'medusa-4.lev'],
	'mines': ['minefill.lev', 'minend-2.lev', 'minetn-1.lev', 'minetn-3.lev', 'minetn-5.lev', 'minetn-7.lev', 'minend-1.lev', 'minend-3.lev', 'minetn-2.lev', 'minetn-4.lev', 'minetn-6.lev'],
	'sokoban': ['soko1-1.lev', 'soko1-2.lev', 'soko2-1.lev', 'soko2-2.lev', 'soko3-1.lev', 'soko3-2.lev', 'soko4-1.lev', 'soko4-2.lev'],
	'tower': ['tower1.lev', 'tower2.lev', 'tower3.lev'],
	'yendor': ['fakewiz1.lev', 'fakewiz2.lev', 'wizard1.lev', 'wizard2.lev', 'wizard3.lev'],
}

compiled_levels = []
foreach level: ['bigroom', 'castle', 'endgame', 'gehennom', 'knox', 'medusa', 'mines', 'oracle', 'sokoban', 'tower', 'yendor']
	compiled_levels += [
		custom_target('@0@_comp'.format(level),
		              input: join_paths(meson.source_root(), 'dat/@0@.des'.format(level)),
		              output: levels.get(level, '@0@.lev'.format(level)),
		              command : [lev_comp, '@INPUT@'])
	]
endforeach

compiled_roles = []
foreach role: ['Arch', 'Barb', 'Caveman', 'Healer', 'Knight', 'Monk', 'Priest', 'Ranger', 'Rogue', 'Samurai', 'Tourist', 'Valkyrie', 'Wizard']
	# TODO: is there a faster way to do this?
	short_name = run_command('sh', '-c', 'echo @0@ | cut -c 1-3'.format(role)).stdout().strip()

	compiled_roles += [
		custom_target('@0@_comp'.format(role),
		              input: join_paths(meson.source_root(), 'dat/@0@.des'.format(role)),
		              output: ['@0@-fila.lev'.format(short_name), '@0@-filb.lev'.format(short_name), '@0@-goal.lev'.format(short_name), '@0@-loca.lev'.format(short_name), '@0@-strt.lev'.format(short_name)],
		              command : [lev_comp, '@INPUT@'])
	]
endforeach

dlb = executable('dlb',
                 'util/dlb_main.c', 'src/dlb.c', 'src/alloc.c', 'util/panic.c',
                 include_directories: includes,
                 native: true)

nhdat = custom_target('nhdat',
                      input: [makedefs_v[1], makedefs_s, makedefs_d, makedefs_r, makedefs_q, makedefs_h, compiled_dungeon, compiled_levels, compiled_roles],
                      output: 'nhdat',
                      command: [dlb, 'cf', '@OUTPUT@', '@INPUT@', join_paths(meson.source_root(), 'dat/help'), join_paths(meson.source_root(), 'dat/hh'), join_paths(meson.source_root(), 'dat/cmdhelp'), join_paths(meson.source_root(), 'dat/keyhelp'), join_paths(meson.source_root(), 'dat/history'), join_paths(meson.source_root(), 'dat/opthelp'), join_paths(meson.source_root(), 'dat/wizhelp'), join_paths(meson.source_root(), 'dat/tribute')],
                      install: true,
                      install_dir: hackdir,
                      install_mode: 'rw-r--r--')

foreach file: ['perm', 'record', 'logfile', 'xlogfile']
	custom_target(file,
	              output: file,
	              command: ['touch', '@OUTPUT@'],
	              install: true,
	              install_dir: hackdir,
	              install_mode: 'rw-------')
endforeach

install_data('doc/Guidebook.txt',
             'dat/license',
             install_dir: join_paths(get_option('datadir'), 'doc/nethack'))

install_man('doc/nethack.6',
            'doc/recover.6')

install_data('sys/unix/sysconf',
             'dat/symbols',
             'dat/license',
             install_dir: hackdir,
             install_mode: 'rw-------')
