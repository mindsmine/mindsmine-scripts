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
# Tests the setup_ssh_keys.sh script
#
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# CONSTANTS

#
# Location of current script
#
declare -r THIS_FILE="${BASH_SOURCE[0]}"
declare -r THIS_FOLDER="$( cd "$( dirname "${THIS_FILE}" )" && pwd )"

#
# Error Codes
#
declare -r ERROR_RECOVERABLE=100      # Re-running the script properly might solve the problem
declare -r ERROR_IRRECOVERABLE=250    # Re-running may not solve the problem

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
# USAGE: test_function cmd code
#
function test_function {
    if [[ $# -eq 2 ]]
    then
        echo_message --began "TESTING '${1}'"

        eval "${1}"
        STATUS_TEST="$?"

        if [[ ${STATUS_TEST} -eq ${2} ]]
        then
            echo ""
            printf "\033[32m+++++++++++++++++++++++\033[0m\n"
            echo_message --success "TEST PASSED"
            printf "\033[32m+++++++++++++++++++++++\033[0m\n"
        else
            echo ""
            printf "\033[31m+++++++++++++++++++++++\033[0m\n"
            echo_message --error "TEST FAILED - ${STATUS_TEST}"
            printf "\033[31m+++++++++++++++++++++++\033[0m\n"

            exit ${STATUS_TEST}
        fi

        echo_message --ended "TESTING '${1}'"
    else
        echo_message --error "Invalid function usage: test_function"

        exit ${ERROR_IRRECOVERABLE}
    fi
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DEFAULT COMMANDS

#
# Test setup_ssh_keys.sh
#
declare -r FOLDER_SRC="${THIS_FOLDER}/../src"
declare -r FILE_NAME="setup_ssh_keys.sh"

declare -r TEST_FILE="${FOLDER_SRC}/${FILE_NAME}"

TEST_CALLS[0]="bash ${FILE_NAME} -h"
TEST_CALLS[1]="bash ${FILE_NAME}"
TEST_CALLS[2]="sudo bash ${FILE_NAME}"
TEST_CALLS[3]="bash ${FILE_NAME} -f=test_setup"
TEST_CALLS[4]="bash ${FILE_NAME} --filename=test_setup"

for (( i = 0; i < ${#TEST_CALLS[@]}; i++ ))
do
    cp ${TEST_FILE} .

    test_function "${TEST_CALLS[i]}" 0

    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
done
