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

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function usage_display {
    echo " "
    echo " "
    echo "  [options]"
    echo "     -v, --verbose    - Displays extra logs"
    echo "     -h, --help       - Displays this message"
    echo " "
    echo " "
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# DEFAULT

LOGGING=""

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# MAIN FLOW

if [ $# -eq 1 ]
then
    case $1 in
        -v | --verbose)
            LOGGING="> /dev/null 2>&1"
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
fi

set -e
set -u

echo 'damn sure' | ./pass.sh ${LOGGING}

STATUS_SCRIPT="$?"

if [ ${STATUS_SCRIPT} -ne 0 ]
then
    echo "This section of the code will never be reached."
    exit ${STATUS_SCRIPT}   # Exits with the same code as that of the script being called. So, no information is lost.
else
    echo "This section of the code will always be reached."
    echo "The script exited with exit code = ${STATUS_SCRIPT}"
fi

echo 'damn sure' | ./fail.sh ${LOGGING}

STATUS_SCRIPT="$?"

if [ ${STATUS_SCRIPT} -ne 0 ]
then
    echo "This section of the code will always be reached."
    echo "The script exited with exit code = ${STATUS_SCRIPT}"
    exit ${STATUS_SCRIPT}   # Exits with the same code as that of the script being called. So, no information is lost.
else
    echo "This section of the code will never be reached."
    echo "The script exited with exit code = ${STATUS_SCRIPT}"
fi



# COMMAND="echo 'damn sure' | /usr/bin/time -v python alerter.py --sendemail --allusers --prodcron --slacklogging"
# [ $VERBOSE = true ] && OUTPUT="" || OUTPUT=" > /dev/null 2>&1"

# cd /home/ubuntu/v2.5/alerts

# if (eval ${COMMAND}${OUTPUT}) then
#     echo "SUCCESS. Alerts script completted successfully"
# else
#     echo "FAILED. Alerts script failed"
#     exit 1
# fi
