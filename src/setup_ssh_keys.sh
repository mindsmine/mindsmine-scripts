#!/bin/bash

#
# Copyright 2008-present Shaiksphere, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Flushes and creates SSH key pair
#
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function usage_display {
    echo " "
    echo "Usage: ${THIS_FILE} [options]"
    echo " "
    echo "This script flushes out the stale SSH keys and creates new SSH key pair based upon 'RSA' algorithm."
    echo " "
    echo "The operations handled by this script are:"
    echo " "
    echo "  1. Flush out stale SSH key pairs (with the provided filename, when provided)"
    echo "  2. Generate SSH key pair (using the filename, when provided)"
    echo " "
    echo " "
    echo "  [arguments]"
    echo "     --filename=FILENAME   - Specifies name of the file in which to store the created key."
    echo "     -f=FILENAME           - Specifies name of the file in which to store the created key."
    echo " "
    echo " "
    echo "  [options]"
    echo "     -h, --help       - Displays this message"
    echo " "
    echo " "
    echo "NOTE: This script should only be used when SSH keys need to be flushed and renewed."
    echo "====                     ----"
    echo " "
    echo "NOTE: This script has been validated for the following Operating Systems:"
    echo "===="
    echo "      * Mac OS X 10.15.7"
    echo "      * Ubuntu 16.04.6"
    echo " "
    echo " "
    echo "Version: 2.0.0"
    echo " "
    echo " "
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# CONSTANTS

#
# Error Codes
#
declare -r ERROR_RECOVERABLE=100      # Re-running the script properly might solve the problem
declare -r ERROR_IRRECOVERABLE=250    # Re-running may not solve the problem

#
# System
#
declare -r OS_NAME="$( uname -s )"

#
# Default Filename
#
declare -r DEFAULT_FILENAME="id_rsa"

#
# Script related
#
declare -r THIS_FILE="${BASH_SOURCE[0]}"
declare -r THIS_FOLDER="$( cd "$( dirname "${THIS_FILE}" )" && pwd )"

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# UTILITY FUNCTIONS

#
# USAGE: echo_message --type message
#
function echo_message {
    #
    # Colours
    #
    declare -r RED="\033[31m"
    declare -r GREEN="\033[32m"
    declare -r YELLOW="\033[33m"
    declare -r CYAN="\033[36m"
    declare -r OFF="\033[0m"

    ECHO_TYPE="[ ${RED}ERROR${OFF} ]"

    if [[ $# -eq 2 ]]
    then
        case $1 in
            --info)
                ECHO_TYPE="[ ${CYAN}INFO${OFF} ]"
                ;;
            --began)
                ECHO_TYPE="[ ${CYAN}INFO${OFF} ] Began -"
                ;;
            --ended)
                ECHO_TYPE="[ ${CYAN}INFO${OFF} ] Ended -"
                ;;
            --debug)
                ECHO_TYPE="[ ${YELLOW}DEBUG${OFF} ]"
                ;;
            --error)
                ;;
            --success)
                ECHO_TYPE="[ ${GREEN}SUCCESS${OFF} ]"
                ;;
            *)
                ;;
        esac

        echo ""
        printf "${ECHO_TYPE} ${2}\n"
        echo ""
    else
        echo ""
        printf "${ECHO_TYPE} Invalid function usage: echo_message\n"
        echo ""

        exit ${ERROR_IRRECOVERABLE}
    fi
}

#
# USAGE: echo_message_with_epoch message epoch
#
function echo_message_with_epoch {
    READ_TIME=""

    if [[ $# -eq 2 ]]
    then
        case ${OS_NAME} in
            Darwin)
                READ_TIME="$( date -u -r ${2} +%T )"
                ;;
            *)
                READ_TIME="$( date -u -d @${2} +%T )"
                ;;
        esac

        echo_message --success "${1} Elapsed Time: ${READ_TIME}"
    else
        echo_message --error "Invalid function usage: echo_message_with_epoch"

        exit ${ERROR_IRRECOVERABLE}
    fi
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# SSH SPECIFIC FUNCTIONS

function _cleanup_ssh_keys {
    rm -f ~/.ssh/${FILENAME}
    rm -f ~/.ssh/${FILENAME}.pub

    find ~/.ssh -type f -name "${FILENAME}*" | xargs rm -rf > /dev/null 2>&1

    echo_message --info "Cleaned up previous SSH keys"
}

function _generate_ssh_keys {
    ssh-keygen -N "" -f ~/.ssh/${FILENAME} -t rsa -b 4096 -C "$( hostname )_${OS_NAME}_$( date +"%Y%m%d_%H%M%S" )" -q

    STATUS_KEYGEN="$?"

    if [[ ${STATUS_KEYGEN} -ne 0 ]]
    then
        echo_message --error "Failed to generate the SSH key pair."

        exit ${ERROR_IRRECOVERABLE}
    fi

    chmod 600 ~/.ssh/${FILENAME}

    echo_message --info "Generated SSH key pair"
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# WRAPPER FUNCTIONS

function ssh_setup {
    _cleanup_ssh_keys

    _generate_ssh_keys
}

function verify_ssh {
    GENERATED_KEY="$( ssh-keygen -lf ~/.ssh/${FILENAME} )"

    if [[ ${GENERATED_KEY} != *"$( hostname )_${OS_NAME}"* ]]
    then
        echo_message --error "The SSH keys were not created. Re-run the script."

        exit ${ERROR_RECOVERABLE}
    fi
}

function script_cleanup {
    case ${OS_NAME} in
        Darwin)
            rm -P "${THIS_FOLDER}/${THIS_FILE}"
            ;;
        *)
            shred -u "${THIS_FOLDER}/${THIS_FILE}"
            ;;
    esac
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DEFAULT COMMANDS

TIME_START=$( date +%s )

FILENAME=""

for i in "$@"
do
    case ${i} in
        --filename=*)
            FILENAME="${i#*=}"
            shift
            ;;
        -f=*)
            FILENAME="${i#*=}"
            shift
            ;;
        -h | --help)
            usage_display
            exit 0
            ;;
        *)
            echo_message --error "Invalid option. Use -h option for more information."

            exit ${ERROR_RECOVERABLE}
            ;;
    esac
done

if [ -z ${FILENAME} ]
then
    FILENAME="${DEFAULT_FILENAME}"
fi

ssh_setup

verify_ssh

TIME_END=$( date +%s )

echo_message_with_epoch "Completed SSH key pair generation." "$((${TIME_END} - ${TIME_START}))"

script_cleanup
