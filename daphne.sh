#!/bin/bash

DAPHNE_USER=~/.daphne
SCRIPT_DIR=/usr/share/daphne
DAPHNE_BIN=$SCRIPT_DIR/daphne.bin
VLDP_DIR=$DAPHNE_USER/framefile

GAMES="ace astron badlands bega cliff cobra esh galaxyr gpworld interstellar lair lair2 mach3 roadblaster sdq tq uvt"

function STDERR () {
	/bin/cat - 1>&2
}

echo "Daphne Launcher : Script dir is $SCRIPT_DIR, User dir is $DAPHNE_USER"
#cd "$DAPHNE_USER"

# point to our linked libs that user may not have
export LD_LIBRARY_PATH=$SCRIPT_DIR:$DAPHNE_USER:$LD_LIBRARY_PATH

if [ "$1" = "-fullscreen" ]; then
    FULLSCREEN="-fullscreen"
    shift
fi

GAME=$1

if [ -z "${GAME}" ] ; then
    echo "Specify a game to try: " | STDERR
    echo
    echo "$0 [-fullscreen] <gamename>" | STDERR

    for g in ${GAMES}; do
	if ls ${VLDP_DIR}/${g}/${g}.txt >/dev/null 2>&1; then
	    installed="$installed $g"
	else
	    uninstalled="$uninstalled $g"
	fi
    done
    if [ "$uninstalled" ]; then
	echo
	echo "Games not found in ${VLDP_DIR}: " | STDERR
	echo "$uninstalled" | fold -s -w60 | sed 's/^ //; s/^/\t/' | STDERR
    fi
    if [ -z "$installed" ]; then
	cat <<EOF 

Error: No games installed. DVDs can be purchased from DigitalLeisure.com.
       Please put the required files in ${VLDP_DIR}
EOF
    else   
	echo
	echo "Games available: " | STDERR
	echo "$installed" | fold -s -w60 | sed 's/^ //; s/^/\t/' | STDERR
    fi
    exit 1
fi

case "$1" in
    lair|lair2|ace|tq)
	FASTBOOT="-fastboot"		   
	;;
esac

# Set where we *think* the game frame control file should be
GAME_FILE="${VLDP_DIR}/${GAME}/${GAME}.txt"
if [ ! -f "${GAME_FILE}" ]; then
	# Did not find control file where we thought it should be...
	# Look for it as a path to the frame control file
	if [ -f "${GAME}" ]; then
		GAME_FILE="${GAME}"
	else
		echo "Game ${GAME} file ${GAME}.txt not found."
		exit 1
	fi
fi

#strace -o strace.txt \
$DAPHNE_BIN $1 vldp \
  $FASTBOOT \
  $FULLSCREEN \
  -framefile "${GAME_FILE}" \
  -homedir "${DAPHNE_USER}" \
  -datadir "${DAPHNE_USER}" \
  -blank_searches \
  -min_seek_delay 1000 \
  -seek_frames_per_ms 20 \
  -sound_buffer 2048 \
  -noserversend \
  -x 640 \
  -y 480

#-bank 0 11111001 \
#-bank 1 00100111 \

EXIT_CODE=$?

if [ "$EXIT_CODE" -ne "0" ] ; then
	if [ "$EXIT_CODE" -eq "127" ]; then
		echo ""
		echo "Daphne failed to start." | STDERR
		echo "This is probably due to a library problem." | STDERR
		echo "Run ./daphne.bin directly to see which libraries are missing." | STDERR
		echo ""
	else
		echo "DaphneLoader failed with an unknown exit code : $EXIT_CODE." | STDERR
	fi
	exit $EXIT_CODE
fi

