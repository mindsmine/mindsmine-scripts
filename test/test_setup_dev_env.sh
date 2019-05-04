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
# VARIABLES

THIS_FILE="${BASH_SOURCE[0]}"
THIS_FOLDER="$( cd "$( dirname "${THIS_FILE}" )" && pwd )"

TEST_FILE="${THIS_FOLDER}/../src/setup_dev_env.sh"

source ${THIS_FOLDER}/utility_functions.sh

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DEFAULT COMMANDS

declare -ra MESSAGES=( "TEST SETUP AS ${CURRENT_USER_NAME}" "TEST SETUP AS ROOT USER"  )
declare -ra COMMANDS=( "bash ${TEST_FILE}" "sudo bash ${TEST_FILE}" )
declare -ra DARWIN_CODES=( 1 ${ERROR_RECOVERABLE} )
declare -ra LINUX_CODES=( ${ERROR_RECOVERABLE} ${ERROR_IRRECOVERABLE} )

for (( i = 0; i < ${#COMMANDS[@]}; i++ ))
do
    case ${OS_NAME} in
        Darwin)
            test_function "${MESSAGES[i]}" "${COMMANDS[i]}" "${DARWIN_CODES[i]}"
            ;;
        Linux)
            test_function "${MESSAGES[i]}" "${COMMANDS[i]}" "${LINUX_CODES[i]}"
            ;;
        *)
            ;;
    esac

    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
done
