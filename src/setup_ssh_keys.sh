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
    echo "This script flushes the stale SSH keys and creates new SSH key pair."
    echo " "
    echo "The operations handled by this script are:"
    echo " "
    echo "  1. Flush out stale SSH key pairs"
    echo "  2. Generate SSH key pair"
    echo " "
    echo " "
    echo "  [options]"
    echo "     -h, --help       - Displays this message"
    echo " "
    echo " "
    echo "NOTE: This script has been validated for the following Operating Systems:"
    echo "===="
    echo "      * macOS High Sierra: Version 10.13.3"
    echo "      * CentOS Linux release 7.6.1810 (Core)"
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

declare -r CURRENT_USER_ID="$( id -u )"
declare -r CURRENT_USER_NAME="$( id -u -n )"

#
# Darwin disallowed user
#
declare -r DARWIN_DISALLOWED_USER_ID=0
declare -r DARWIN_DISALLOWED_USER_NAME="root"

#
# Linux permitted user
#
declare -r LINUX_PERMITTED_USER_ID=0
declare -r LINUX_PERMITTED_USER_NAME="root"

#
# SSH values
#
declare -r SSH_KEY="id_rsa"

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# VARIABLES

THIS_FILE="${BASH_SOURCE[0]}"
THIS_FOLDER="$( cd "$( dirname "${THIS_FILE}" )" && pwd )"

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

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# SSH SPECIFIC FUNCTIONS

function _cleanup_ssh_keys {
    rm -f ~/.ssh/${SSH_KEY}
    rm -f ~/.ssh/${SSH_KEY}.pub

    find ~/.ssh -type f -name "${SSH_KEY}*" | xargs rm -rf > /dev/null 2>&1

    echo_message --info "Cleaned up previous SSH keys"
}

function _generate_ssh_keys {
    ssh-keygen -N "" -f ~/.ssh/${SSH_KEY} -t rsa -b 4096 -C $( hostname )_${OS_NAME}_$( date +"%Y%m%d_%H%M%S" ) -q

    STATUS_KEYGEN="$?"

    if [[ ${STATUS_KEYGEN} -ne 0 ]]
    then
        echo_message --error "Failed to generate the SSH key pair."

        exit ${ERROR_IRRECOVERABLE}
    fi

    chmod 600 ~/.ssh/${SSH_KEY}

    echo_message --info "Generated SSH key pair"
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# WRAPPER FUNCTIONS

function verify_access {
    case ${OS_NAME} in
        Darwin)
            if [[ ${CURRENT_USER_ID} -eq ${DARWIN_DISALLOWED_USER_ID} ]]
            then
                echo_message --error "FATAL: This script can NOT be run as ${DARWIN_DISALLOWED_USER_NAME}. Current user: '${CURRENT_USER_NAME}'"

                echo_message --debug "On a Mac machine, due to Brew requirements, this script can NOT be run as ${DARWIN_DISALLOWED_USER_NAME}."

                exit ${ERROR_RECOVERABLE}
            fi
            ;;
        Linux)
            if [[ ${CURRENT_USER_ID} -ne ${LINUX_PERMITTED_USER_ID} ]]
            then
                echo_message --error "FATAL: This script can ONLY be run as ${LINUX_PERMITTED_USER_NAME}. Current user: '${CURRENT_USER_NAME}'"

                echo_message --debug "On a Linux machine, due to yum requirements, this script can ONLY be run as ${LINUX_PERMITTED_USER_NAME}."

                exit ${ERROR_RECOVERABLE}
            fi
            ;;
        *)
            echo_message --error "Not yet supported for ${OS_NAME}"
            exit ${ERROR_IRRECOVERABLE}
            ;;
    esac
}

function ssh_setup {
    _cleanup_ssh_keys

    _generate_ssh_keys
}

function verify_setup {
    GENERATED_KEY="$( ssh-keygen -lf ~/.ssh/${SSH_KEY} )"

    if [[ ${GENERATED_KEY} != *"$( hostname )_${OS_NAME}"* ]]
    then
        echo_message --error "The SSH keys were not created. Re-run the script."

        exit ${ERROR_RECOVERABLE}
    fi
}

function script_cleanup {
    case ${OS_NAME} in
        Darwin)
            rm -P ${THIS_FOLDER}/${THIS_FILE}
            ;;
        *)
            shred -u ${THIS_FOLDER}/${THIS_FILE}
            ;;
    esac
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DEFAULT COMMANDS

if [[ $# -eq 1 ]]
then
    case $1 in
        -h | --help)
            usage_display
            exit 0
            ;;
        *)
            echo_message --error "Invalid option. Use -h option for more information."

            exit ${ERROR_RECOVERABLE}
            ;;
    esac
fi

#verify_access

ssh_setup

verify_setup

echo_message --success "Completed SSH key pair generation."

script_cleanup
