#!/bin/bash

# Enable extended globbing.
shopt -s extglob

# Display error message in STDERR and exit.
# $1 error message (default: 1)
# $2 exit code
function error {
  >&2 echo "Error: $1"
  exit ${2:-1}
}

# Constants.
elodie_url='https://github.com/jmathai/elodie'
elodie="${ELODIE:-elodie}"
source_path=$1
destination_path=$2
now=$(date -u +'%Y-%m-%dT%H-%M-%S')
imports_relative_path="imports"
import_relative_path="imports/$now"
import_path="$source_path/$import_relative_path"
import_log_path="$import_path/import.log"
lockfile_name=".import.lockfile"

# Check that elodie script is available.
if [ -z $(which $elodie) ]; then
  error "Elodie script '$elodie' not found, make sure it's installed ($elodie_url) and accessible with ELODIE environment variable."
fi

# Check that source path exists.
if [ ! -d $source_path ]; then
  error "Source path '$source_path' is not a directory."
fi

# Check that destination path exists.
if [ ! -d $destination_path ]; then
  error "destination path '$destination_path' is not a directory."
fi

# Verify there is something to import else, exit.
number_import_files=$(ls 2>/dev/null -Ub1 /mnt/data/memories/import/!(imports|.import.lockfile) | wc -l)
if [ $number_import_files -eq 0 ]; then
  exit 0
fi

# Create import directory.
mkdir -p --verbose $import_path

# Move all file and directory in import directory except lock file and imports directory.
mv --verbose $source_path/!($imports_relative_path|$lockfile_name) $import_path
# mv --verbose $import_path/.[^.]* $import_directory

# Import.
$elodie import \
    --debug \
    --trash \
    --source=$source_path/. \
    --destination=$destination_path | tee -a $import_log_path
