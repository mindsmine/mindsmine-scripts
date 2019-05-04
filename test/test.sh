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
# Tests the scripts
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

#
# System
#
declare -r OS_NAME="$( uname -s )"

declare -r CURRENT_USER_ID="$( id -u )"
declare -r CURRENT_USER_NAME="$( id -u -n )"

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
# Test setup_dev_env.sh
#
declare -r TEST_1_FILE="${THIS_FOLDER}/../src/setup_dev_env.sh"

case ${OS_NAME} in
    Darwin)
        declare -ra TEST_1_DARWIN_CALLS=( "bash ${TEST_1_FILE} -h" "bash ${TEST_1_FILE}" "sudo bash ${TEST_1_FILE}" )
        declare -ra TEST_1_DARWIN_CODES=( 0 1 ${ERROR_RECOVERABLE} )

        for (( i = 0; i < ${#TEST_1_DARWIN_CALLS[@]}; i++ ))
        do
            test_function "${TEST_1_DARWIN_CALLS[i]}" "${TEST_1_DARWIN_CODES[i]}"

            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        done
        ;;
    Linux)
        declare -ra TEST_1_LINUX_CALLS=( "bash ${TEST_1_FILE} -h" "bash ${TEST_1_FILE}" )
        declare -ra TEST_1_LINUX_CODES=( 0 ${ERROR_RECOVERABLE} )

        for (( j = 0; j < ${#TEST_1_LINUX_CALLS[@]}; j++ ))
        do
            test_function "${TEST_1_LINUX_CALLS[j]}" "${TEST_1_LINUX_CODES[j]}"

            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        done

        echo_message --began "TESTING 'sudo bash ${TEST_1_FILE}'"

        cp ${TEST_1_FILE} .

        docker build --file ${THIS_FOLDER}/Dockerfile --tag script-demo .

        docker run --name demo script-demo

        STATUS_TEST="$?"

        if [[ ${STATUS_TEST} -eq 0 ]]
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

        echo_message --ended "TESTING 'sudo bash ${TEST_1_FILE}'"
        ;;

esac
