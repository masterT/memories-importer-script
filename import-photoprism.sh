#!/bin/bash

source_path=$1
destination=$2
credentials=$3

delay=1

# Check that source path exists (file or directory)
if [[ ! -e $source_path ]]; then
  error "Source path '$source_path' does not exist."
fi

if [[ ! -d $source_path ]]; then
  error "Source path '$source_path' is not a directory."
fi

if [[ -z $destination ]]; then
  error "Destination is required."
fi

if [[ -z $credentials ]]; then
  error "Destination credentials is required."
fi

echo "Importing $source_path to $destination on $delay seconds..."
sleep $delay

# List all file in source path (recursively) and run in parallel.
find $source_path -type f -print0 | xargs -0 -P 20 -I {} curl -s -w "%{http_code} (%{time_total} sec) %{url_effective} (%{size_upload} bytes)\n" -o /dev/null -T {} -u $credentials $destination
