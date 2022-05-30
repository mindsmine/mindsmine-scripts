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

VERBOSE=false

CMD_PASS="echo 'damn sure' | sh pass.sh > /dev/null 2>&1"
CMD_FAIL="echo 'damn sure' | sh fail.sh > /dev/null 2>&1"

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# MAIN FLOW

if [ $# -eq 1 ]
then
    case $1 in
        -v | --verbose)
            VERBOSE=true

            CMD_PASS="echo 'damn sure' | sh pass.sh"
            CMD_FAIL="echo 'damn sure' | sh fail.sh"
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

# set -e
#          When 'set -e' is used, this wrapper script loses control and exits as soon as 'fail.sh' is called.
#          Without it, 'fail.sh' will still fail, but this wrapper script will not exit and retain control.

set -u

if [ ${VERBOSE} = true ]
then
    echo 'damn sure' | ./pass.sh
else
    echo 'damn sure' | ./pass.sh  > /dev/null 2>&1
fi

STATUS_SCRIPT="$?"

if [ ${STATUS_SCRIPT} -ne 0 ]
then
    echo ""
    echo "This section of the code will never be reached."
    exit ${STATUS_SCRIPT}   # Exits with the same code as that of the script being called. So, no information is lost.
else
    echo ""
    echo "This section of the code will always be reached."
    echo "The script exited with exit code = ${STATUS_SCRIPT}"
fi

if [ ${VERBOSE} = true ]
then
    echo 'damn sure' | ./fail.sh
else
    echo 'damn sure' | ./fail.sh  > /dev/null 2>&1
fi

STATUS_SCRIPT="$?"

if [ ${STATUS_SCRIPT} -ne 0 ]
then
    echo ""
    echo "This section of the code will always be reached."
    echo "The script exited with exit code = ${STATUS_SCRIPT}"
    exit ${STATUS_SCRIPT}   # Exits with the same code as that of the script being called. So, no information is lost.
else
    echo ""
    echo "This section of the code will never be reached."
    echo "The script exited with exit code = ${STATUS_SCRIPT}"
fi
