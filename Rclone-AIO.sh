#!/bin/bash

# Setting colors
GREEN='\033[0;32m'
RED='\033[0;31m'
WITHOUT_COLOR='\033[0m'

# Creates a log file to record the output of commands
LogFile="/var/log/Rclone/Rclone-AIO-$(date +%Y%m%d).log"
mkdir -p "$(dirname "$LogFile")"
touch "$LogFile"
exec > >(tee -a "$LogFile")
exec 2>&1

# Function for error messages
errorecho() { cat <<< "$@" 1>&2; }

# Function to add the --dry-run flag if -n is passed
add_dry_run() {
    if [[ "$DRY_RUN" == 'true' ]]; then
        RCLONE_FLAGS+=" --dry-run"
    fi
}

add_filter_from() {
    if [[ "$FILTER_FROM" == 'true' ]]; then
        RCLONE_FLAGS+=" --filter-from \"$FILTER_FILE\""
    fi
}

# Function to display the menu
display_menu() {
    echo "Usage: $0 [options] source destination [ -e flags_do_rclone]"
    echo
    echo "Options:"
    echo "  -c (Copy)	 Copy files from source to destination, ignoring identical files."
    echo "  -s (Sync) 	 Make the source and destination identical, modifying only the destination."
    echo "  -m (Move)	 Move files from source to destination."
    echo "  -d (delete)	 Remove files in the path."
    echo "  -r (rmdirs)	 Remove empty directories in the path."
    echo "  -C (cleanup) Clean up the remote if possible. Empty the recycle garbage can or delete old versions of files. Not supported by all remotes."
    echo "  -n 		 Adds the --dry-run flag to rclone."
    echo "  -f file	 Adds the --filter-from flag with the specified file to rclone."
    echo "  -e 		 Adds extra flags to the rclone command."
    echo
    echo "Examples:"
    echo "  $0 -c 'local:path/origin' 'cloud:path/destination'"
    echo "  $0 -c 'ftp:/path/origin' 'cloud:path/destination' -e --max-age=7d"
    echo "  $0 -c 'local:path/origin' 'cloud:path/destination' -f '/path/to/filter.lst'"
    echo "  $0 -s 'local:path/origin' 'cloud:path/destination'"
    echo "  $0 -s 'ftp:/path/origin' 'cloud:path/destination' -e --max-age=7d"
    echo "  $0 -m 'local:path/origin' 'cloud:path/destination'
    echo "  $0 -n -s 'local:path/origin' 'cloud:path/destination' -f '/path/to/filter.lst'"
    echo "  $0 -n -s 'local:path/origin' 'cloud:path/destination' -f '/path/to/filter.lst' -e --max-age=7d"
    echo "  $0 -C 'cloud:/'"
    echo "  $0 -d 'cloud:path/destination'"
    echo "  $0 -r 'cloud:path/destination'"
    echo
}

# Checks if no arguments have been passed and displays the menu
if [[ $# -eq 0 ]]; then
    display_menu
    exit 1
fi

# Initialize variables
RCLONE_FLAGS="-v --drive-chunk-size 128M --tpslimit 6 --drive-stop-on-upload-limit --drive-acknowledge-abuse --drive-keep-revision-forever --onedrive-no-versions --drive-pacer-min-sleep=0ms --drive-v2-download-min-size 1G --update --ignore-existing --checksum --no-update-modtime --transfers 4 --checkers 4 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 3 --stats 5s --stats-one-line --stats-file-name-length 0 --fast-list --user-agent='rclone/v1.66.0'"

# Function to add double quotes to paths, if necessary
add_quotes_if_needed() {
    local path="$1"
    if [[ "$path" =~ \  ]]; then
        echo "\"$path\""
    else
        echo "$path"
    fi
}

# Check the arguments passed
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
        display_menu
        exit 0
        ;;
        -n)
        DRY_RUN='true'
        shift # Remove -n from arguments
        ;;
        -f)
        FILTER_FROM='true'
        shift # Remove -f from arguments
        FILTER_FILE=$1
        shift # Removes the path of the filter file from the arguments
        ;;
        -c)
        MODE='copy'
        shift # Remove -c from arguments
        ;;
        -m)
        MODE='moveto'
        shift # Remove -m from arguments
        ;;
        -s)
        MODE='sync'
        shift # Remove -s from arguments
        ;;
        -d)
        MODE='delete'
        shift # Remove -d from arguments
        destination=$(add_quotes_if_needed "$1")
        shift # Remove the destination path from the arguments
        ;;
        -r)
        MODE='rmdirs'
        shift # Remove -r from arguments
        destination=$(add_quotes_if_needed "$1")
        shift # Remove the destination path from the arguments
        ;;
        -C)
        MODE='cleanup'
        shift # Remove -C from arguments
        destination=$(add_quotes_if_needed "$1")
        shift # Remove the destination path from the arguments
        ;;
        -e)
        shift # Remove -e from arguments
        EXTRAS="$@"
        break
        ;;
        *)
        if [[ -z "$source" ]]; then
            source=$(add_quotes_if_needed "$1")
        elif [[ -z "$destination" ]]; then
            destination=$(add_quotes_if_needed "$1")
        fi
        shift # Removes the current argument
        ;;
    esac
done

# Checks if origin or destination has not been supplied
if { [[ "$MODE" == 'copy' || "$MODE" == 'moveto' || "$MODE" == 'sync' ]] && { [[ -z "$source" ]] || [[ -z "$destination" ]]; }; } || { [[ "$MODE" == 'delete' || "$MODE" == 'rmdirs' || "$MODE" == 'cleanup' ]] && [[ -z "$destination" ]]; }; then
    display_menu
    exit 1
fi

# Add the --dry-run flag if necessary
add_dry_run

# Add the --filter-from flag if necessary
add_filter_from

# Sets the rclone command based on the selected mode
case $MODE in
    copy)
    COMMAND_RCLONE="rclone copy"
    ;;
    moveto)
    COMMAND_RCLONE="rclone moveto"
    ;;
    sync)
    COMMAND_RCLONE="rclone sync"
    RCLONE_FLAGS+=" --track-renames --track-renames-strategy size --delete-during"
    ;;
    delete)
    COMMAND_RCLONE="rclone delete"
    RCLONE_FLAGS+=" -v --onedrive-no-versions --user-agent='rclone/v1.66.0' --tpslimit 6"
    ;;
    rmdirs)
    COMMAND_RCLONE="rclone rmdirs"
    RCLONE_FLAGS+=" -v --onedrive-no-versions --user-agent='rclone/v1.66.0' --tpslimit 6"
    ;;
    cleanup)
    COMMAND_RCLONE="rclone cleanup"
    RCLONE_FLAGS+=" -v --onedrive-no-versions --user-agent='rclone/v1.66.0' --tpslimit 6"
    ;;
    *)
    echo -e "${RED}Mode not specified or invalid. Use -c, -m, -s, -d, -r, or -C.${WITHOUT_COLOR}"
    exit 1
    ;;
esac

# Runs the rclone command with the default options and those provided by the user
if [[ "$MODE" == 'copy' || "$MODE" == 'moveto' || "$MODE" == 'sync' ]]; then
    COMMAND="$COMMAND_RCLONE $RCLONE_FLAGS $EXTRAS $source $destination"
else
    COMMAND="$COMMAND_RCLONE $RCLONE_FLAGS $EXTRAS $destination"
fi

eval $COMMAND

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Operation completed successfully.${WITHOUT_COLOR}"
else
    echo -e "${RED}An error occurred during the operation.${WITHOUT_COLOR}"
fi
