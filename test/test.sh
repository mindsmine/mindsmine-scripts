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
# Location of scripts to be tested
#
declare -r TEST_FILE_1="${THIS_FOLDER}/../src/setup_dev_env.sh"
declare -r TEST_FILE_2="${THIS_FOLDER}/../src/setup_ssh_keys.sh"

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
declare -r TEST_1_FOLDER="${THIS_FOLDER}/../src"
declare -r TEST_1_FILE="setup_dev_env.sh"

case ${OS_NAME} in
    Darwin)
        declare -r TEST_1_DARWIN_FILE="${TEST_1_FOLDER}/${TEST_FILE_1}"

        declare -ra TEST_1_DARWIN_CALLS=( "bash ${TEST_1_DARWIN_FILE} -h" "bash ${TEST_1_DARWIN_FILE}" "sudo bash ${TEST_1_DARWIN_FILE}" )
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
        cp ${TEST_1_FOLDER}/${TEST_1_FILE} .
        docker build --file ${THIS_FOLDER}/Dockerfile --tag script-demo .
        docker run --name demo script-demo
#        docker run -it --rm -v ${TEST_1_FOLDER}:/${TEST_1_FILE}:ro bash:latest bash /${TEST_1_FILE}
#        docker run -it --rm -v ${TEST_1_FOLDER}:/${TEST_1_FILE}:ro bash:latest bash -c "echo 'Hello World!'"
        ;;

esac

#declare -ra TEST_1_COMMANDS=( "bash ${TEST_FILE_1} -h" "bash ${TEST_FILE_1}" "sudo bash ${TEST_FILE_1}" )
#declare -ra TEST_1_CODES_DARWIN=( 0 1 ${ERROR_RECOVERABLE} )
#declare -ra TEST_1_CODES_LINUX=( 0 ${ERROR_RECOVERABLE} ${ERROR_IRRECOVERABLE} )
#
#for (( i = 0; i < ${#TEST_1_COMMANDS[@]}; i++ ))
#do
#    case ${OS_NAME} in
#        Darwin)
#            test_function "${TEST_1_COMMANDS[i]}" "${TEST_1_CODES_DARWIN[i]}"
#            ;;
#        Linux)
#            docker version
#            docker pull centos
#            docker run --volume ${TEST_FILE_1} --rm centos bash setup_dev_env.sh
#            docker run --volume ${TEST_FILE_1} --rm centos bash setup_dev_env.sh
#            docker run -it --rm -v /path/to/script.sh:/script.sh:ro bash:4.4 bash /script.sh
#            docker run -it --rm -v ${THIS_FOLDER}/../src:/setup_dev_env.sh:ro bash:4.4 bash /setup_dev_env.sh
#            sudo apt-get install yum*
#            sudo apt-get update
#            sudo apt-get install build-essential

#            test_function "${TEST_1_COMMANDS[i]}" "${TEST_1_CODES_LINUX[i]}"
#            ;;
#        *)
#            ;;
#    esac

#done
