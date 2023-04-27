#!/usr/bin/env bash
# ############################################################################
# # PATH: ./GentooGuide                           AUTHOR: Hoefkens.j@gmail.com
# # FILE: install2system.sh
# ############################################################################
#
# set -o errexit
# set -o xtrace
function merge2sys() {
	local HELP="
${FUNCNAME[0]} [-h]|[-aqd] [COMMAND] [SRC] [DST]

COMMANDS:

    install           use the install tool to copy everything
    
    link              use the ln tool to link everything


ARGS:
    
    <SRC>             root of the tree to copy/link/install files and directories from

    <MATCH>           root of the tree tocopy/link/install files and directories to

OPTIONS:
    -h,  --help       Show this help text
    -a,  --ask        ask confirmation for each file   
    -q,  --quiet      Quiet/Silent/Script, Dont produce any output
    -d,	 --debug      enabel xtrace for this script   

	";
	function batcat ()
	{
		local _cat _bat LANG STRING COLOR
		function _bat()
		{
			bat	--plain  --language="$LANG" <<< "$1"			
		}

		LANG="$1"
		shift 1
		STRING="$@"
		_cat=$( which "cat" )
		_bat=$( which "bat" )
		[[ -n "$_bat" ]] &&  _bat "$STRING"
		[[ -z $_bat ]] && echo $( printf '%s' "$@" ) | $( printf '%s' "$_cat"  ) 
	};	
    function _main() {

		function _install() {		
			# for DIR in "${DIRLIST[@]}" ; do
			# 	DST=$( echo "${DSTROOT}${DIR}")
			# 	SRC=$( echo "${SRCROOT}/${DIR}")
			# 	printf './%s/* -> %s \n' "${SRC}" "${DST}"
			# 	install  -vD  "$SRC"/* "$DIR"
			for FILE in "${FILELIST[@]}" ; do
				DST=$( echo "${DSTROOT}/${FILE}")
				SRC=$( echo "${SRCROOT}/${FILE}")
				printf './%s/* -> %s \n' "${SRC}" "${DST}"
				install  -v  $SRC $DST
			done;
		}

		function _slink() {
			for FILE in "${FILELIST[@]}" ; do
				DST=$( echo "${DSTROOT}/${FILE}")
				SRC=$( echo "${SRCROOT}/${FILE}")
				printf '%s < - < - < %s \n'  "${SRC}" "${DST}"
				ln -svf $SRC $DST
			done;
		}

	local SRCROOT DSTROOT DIRLIST FILELIST SRCDIR SRCROOT SRC DST
	SRCROOT=$( realpath "$1" )
	DSTROOT=$( realpath "$2" )
	DIRLIST=($( find "$SRCROOT"  -type d -printf '%P\n' ))
	FILELIST=($( find "$SRCROOT"  -type f -printf '%P\n' ))

	}

	local CASE SELECTED I;
		case "$1" in 
			-h | --help | '')
				batcat help "$HELP" 
			;;
			-d | --debug)
				shift && set -o xtrace && ${FUNCNAME[0]} "$@"
			;;
			-q | --quiet)
				shift 1 && ${FUNCNAME[0]} "$@" &> /dev/null
			;;
			-a | --ask)
				shift 1 && CASE="-i" && ${FUNCNAME[0]} "$@"
			;;
			*)
				_main "$@"
			;;
		esac;
		unset _m _G _progress _mask _state _sourcefiles _main _cat
}
merge2sys $@
unset merge2sys