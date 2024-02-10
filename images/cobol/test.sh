#!/bin/bash

#set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

readonly yellow='\e[0;33m'
readonly green='\e[0;32m'
readonly red='\e[0;31m'
readonly reset='\e[0m'

# Usage: log [ARG]...
#
# Prints all arguments on the standard output stream
log() {
    printf "${yellow}($0)>> %s${reset}\n" "${*}"
}

# Usage: success [ARG]...
#
# Prints all arguments on the standard output stream
success() {
    printf "${green}($0)>> %s${reset}\n" "${*}"
}

# Usage: error [ARG]...
#
# Prints all arguments on the standard error stream
error() {
    printf "${red}($0)!!! %s${reset}\n" "${*}" 1>&2
}

# Usage: die MESSAGE
# Prints the specified error message and exits with an error status
die() {
    error "${*}"
    exit 1
}

success "Entered container"

log "Configure the exercism client"
exercism configure -w /workspaces/devc-images/src -t f871b9c8-d5e7-455d-8887-db8037144b17
if [[ $? -gt 0 ]]; then
    die "Failed to configure exercism cli"
fi

log "Download the cobol hello world exercise"
exercism download -t cobol -e hello-world --force
if [[ $? -gt 0 ]]; then
    die "Failed to download the hello-world exercise"
fi

log "Change into the hello-world exercise folder"
cd hello-world
if [[ $? -gt 0 ]]; then
    die "Failed to change into the hello-world exercise folder"
fi

log "Solve the hello-world exercise"
sed -i 's/Goodbye, Mars/Hello, World/g' src/hello-world.cob

log "Test the hello-world exercise"
exercism test
if [[ $? -gt 0 ]]; then
    die "Failed to test the hello-world exercise"
fi

log "Change out of the hello-world exercise folder and delete it"
cd ..
rm -r ./hello-world
if [[ $? -gt 0 ]]; then
    die "Unable to delete hello-world exercise"
fi

success "Done!"
