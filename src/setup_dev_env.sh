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
# Configures Development Environment
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
    echo "This script installs the minimum software necessary for development work."
    echo " "
    echo "The operations handled by this script are:"
    echo " "
    echo "For Macintosh:"
    echo "  0. Install command line tools (if not already installed)"
    echo "  1. Install and/or Update Homebrew"
    echo "  2. Install and/or Update git (and related tools)"
    echo "  3. Install and/or Update Node.js (and related tools)"
    echo " "
    echo "For Linux:"
    echo "  1. Install and/or Update yum repositories"
    echo "  2. Install and/or Update git (and related tools)"
    echo "  3. Install and/or Update Node.js (and related tools)"
    echo " "
    echo " "
    echo "  [options]"
    echo "     -h, --help       - Displays this message"
    echo " "
    echo " "
    echo "NOTE: It is an idempotent procedure, hence the script can be run frequently to stay up-to-date."
    echo "====           ----------"
    echo " "
    echo "NOTE: This script has been validated for the following Operating Systems:"
    echo "===="
    echo "      * macOS Sierra: Version 10.12.4"
    echo "      * CentOS Linux release 7.2.1511 (Core)"
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
# URIs to be handled
#
declare -r URI_BREW="https://raw.githubusercontent.com/Homebrew/install/master/install"
declare -r URI_NODE_JS="https://nodejs.org/dist"

#
# Other Constants
#
declare -r REGEX_VERSION="[a-z]([0-9]+\.)+[0-9]"
declare -r EXTENSION_NODE_JS="linux-x64.tar.gz"

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

    if [ $# -eq 2 ]
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
# MAC SPECIFIC FUNCTIONS

function _darwin_xcode {
    xcode-select --print-path > /dev/null 2>&1

    STATUS_XCODE="$?"

    if [ ${STATUS_XCODE} -ne 0 ]
    then
        echo_message --began "Installing Command Line Developer Tools"

        echo_message --info "RE-RUN this script after 'Command Line Developer Tools' finishes installation."

        xcode-select --install
        sleep 1
        osascript <<EOD
  tell application "System Events"
    tell process "Install Command Line Developer Tools"
      keystroke return
      click button "Agree" of window "License Agreement"
    end tell
  end tell
EOD
        echo_message --ended "Installing Command Line Developer Tools"

        exit 0

    # else
        # Command Line Developer Tools already installed. Do nothing.
    fi
}

function _darwin_brew {
    which -s brew

    STATUS_BREW="$?"

    if [ ${STATUS_BREW} -ne 0 ]
    then
        echo_message --began "Installing Brew"

        /usr/bin/ruby -e "$( curl --fail --silent --show-error --location "${URI_BREW}" )"

        STATUS_INSTALL="$?"

        if [ ${STATUS_INSTALL} -ne 0 ]
        then
            echo_message --error "Brew installation failed."

            exit ${ERROR_IRRECOVERABLE}
        fi

        echo_message --ended "Installing Brew"

    else
        echo_message --began "Updating Brew"

        brew update

        STATUS_UPDATE="$?"

        if [ ${STATUS_UPDATE} -ne 0 ]
        then
            echo_message --error "Brew update failed."

            exit ${ERROR_IRRECOVERABLE}
        fi

        echo_message --ended "Updating Brew"

    fi

    #
    # To avoid anonymous tracking by Homebrew (https://git.io/brew-analytics)
    #
    brew analytics off
}

function _darwin_install_using_brew {
    declare -ra FORMULAE_NAMES=( git node )
    declare -ra FORMULAE_URIS=( https://git-scm.com https://nodejs.org )

    for (( i = 0; i < ${#FORMULAE_NAMES[@]}; i++ ))
    do
        which -s ${FORMULAE_NAMES[i]}

        STATUS_FORMULA="$?"

        if [ ${STATUS_FORMULA} -ne 0 ]
        then
            echo_message --began "Installing ${FORMULAE_NAMES[i]}"

            brew install ${FORMULAE_NAMES[i]}

            STATUS_INSTALL="$?"

            if [ ${STATUS_INSTALL} -ne 0 ]
            then
                echo_message --error "'${FORMULAE_NAMES[i]}' installation FAILED (through Brew). Visit ${FORMULAE_URIS[i]} to manually install."

                exit ${ERROR_IRRECOVERABLE}
            fi

            echo_message --ended "Installing ${FORMULAE_NAMES[i]}"

        else
            THROUGH_BREW="$( brew list --versions ${FORMULAE_NAMES[i]} | wc -l )"

            if [ ${THROUGH_BREW} -ne 0 ]
            then
                echo_message --info "'${FORMULAE_NAMES[i]}' was installed using Brew. It will be upgraded if a newer version exists."

                brew outdated ${FORMULAE_NAMES[i]}

                NEWER_VERSION_AVAILABLE="$?"

                if [ ${NEWER_VERSION_AVAILABLE} -ne 0 ]
                then
                    echo_message --info "A newer version of '${FORMULAE_NAMES[i]}' exists. It will be upgraded."

                    brew upgrade ${FORMULAE_NAMES[i]}

                    STATUS_UPGRADE="$?"

                    if [ ${STATUS_UPGRADE} -ne 0 ]
                    then
                        echo_message --error "Upgrading '${FORMULAE_NAMES[i]}' (through brew) FAILED."

                        exit ${ERROR_IRRECOVERABLE}
                    fi
                fi
            else
                echo_message --info "'${FORMULAE_NAMES[i]}' was installed independent of Brew. Visit ${FORMULAE_URIS[i]} to manually upgrade."
            fi
        fi
    done
}

function darwin_setup {
    _darwin_xcode

    _darwin_brew

    _darwin_install_using_brew
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# LINUX SPECIFIC FUNCTIONS

function _linux_yum {
    which yum > /dev/null 2>&1

    STATUS_YUM="$?"

    if [ ${STATUS_YUM} -ne 0 ]
    then
        echo_message --error "The command 'yum' does not exist."

        exit ${ERROR_IRRECOVERABLE}
    fi

    echo_message --info "Cleaning yum cache"

    yum -y -q clean all

    yum -y -q update

    echo_message --began "Installing 'Development Tools'"

    yum -y -q groups mark install "Development Tools"

    yum -y -q groups mark convert "Development Tools"

    yum -y -q groupinstall "Development Tools"

    echo_message --ended "Installing 'Development Tools'"
}

function _linux_install_using_yum {
    declare -ra PACKAGE_NAMES=( git )

    for (( i = 0; i < ${#PACKAGE_NAMES[@]}; i++ ))
    do
        yum list installed ${PACKAGE_NAMES[i]} > /dev/null 2>&1

        THROUGH_YUM="$?"

        if [ ${THROUGH_YUM} -ne 0 ]
        then
            echo_message --began "Installing ${PACKAGE_NAMES[i]}"

            yum -y -q install ${PACKAGE_NAMES[i]}

            STATUS_INSTALL="$?"

            if [ ${STATUS_INSTALL} -ne 0 ]
            then
                echo_message --error "'${PACKAGE_NAMES[i]}' installation FAILED (through yum). Install it manually."

                exit ${ERROR_IRRECOVERABLE}
            fi

            echo_message --ended "Installing ${PACKAGE_NAMES[i]}"
        else
            echo_message --began "Upgrading ${PACKAGE_NAMES[i]} (if a newer version exists)"

            yum -y -q upgrade ${PACKAGE_NAMES[i]}

            STATUS_UPGRADE="$?"

            if [ ${STATUS_UPGRADE} -ne 0 ]
            then
                echo_message --error "Upgrading '${PACKAGE_NAMES[i]}' (through yum) FAILED."

                exit ${ERROR_IRRECOVERABLE}
            fi

            echo_message --ended "Upgrading ${PACKAGE_NAMES[i]}"
        fi
    done
}

function _linux_install_node_js {
    declare -r VERSION_NODE_JS="$( curl --silent --list-only "${URI_NODE_JS}/latest/" | grep "${EXTENSION_NODE_JS}" | grep --extended-regexp --max-count=1 --only-matching "${REGEX_VERSION}" | head -n 1 )"

    STATUS_EXTRACT_VERSION="$?"

    if [ ${STATUS_EXTRACT_VERSION} -ne 0 ]
    then
        echo_message --error "Unable to extract Node.js version information."
        exit ${ERROR_IRRECOVERABLE}
    fi

    declare -r FILE_TAR_NODE_JS="node-${VERSION_NODE_JS}-${EXTENSION_NODE_JS}"

    echo_message --debug "Latest version of NodeJS = ${VERSION_NODE_JS}"
    echo_message --debug "File to be downloaded = ${FILE_TAR_NODE_JS}"

    echo_message --began "Installing/Upgrading NodeJS"

    curl --remote-name ${URI_NODE_JS}/${VERSION_NODE_JS}/${FILE_TAR_NODE_JS} --silent

    STATUS_DOWNLOAD="$?"

    if [ ${STATUS_DOWNLOAD} -ne 0 ]
    then
        echo_message --error "Unable to download ${FILE_TAR_NODE_JS}"
        exit ${ERROR_IRRECOVERABLE}
    fi

    tar --extract --overwrite --gzip --file=${FILE_TAR_NODE_JS} --directory="/usr/local" --strip-components 1

    STATUS_EXTRACT_TAR="$?"

    if [ ${STATUS_EXTRACT_TAR} -ne 0 ]
    then
        echo_message --error "Unable to extract ${FILE_TAR_NODE_JS}"
         exit ${ERROR_IRRECOVERABLE}
    fi

    rm --force ${FILE_TAR_NODE_JS}

    echo_message --ended "Installing/Upgrading NodeJS"
}

function linux_setup {
    _linux_yum

    _linux_install_using_yum

    _linux_install_node_js
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# WRAPPER FUNCTIONS

function verify_access {
    case ${OS_NAME} in
        Darwin)
            if [ ${CURRENT_USER_ID} -eq ${DARWIN_DISALLOWED_USER_ID} ]
            then
                echo_message --error "FATAL: This script can NOT be run as ${DARWIN_DISALLOWED_USER_NAME}. Current user: '${CURRENT_USER_NAME}'"

                echo_message --debug "On a Mac machine, due to Brew requirements, this script can NOT be run as ${DARWIN_DISALLOWED_USER_NAME}."

                exit ${ERROR_RECOVERABLE}
            fi
            ;;
        Linux)
            if [ ${CURRENT_USER_ID} -ne ${LINUX_PERMITTED_USER_ID} ]
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

function machine_setup {
    case ${OS_NAME} in
        Darwin)
            darwin_setup
            ;;
        Linux)
            linux_setup
            ;;
        *)
            echo_message --error "Not yet supported for ${OS_NAME}"
            exit ${ERROR_IRRECOVERABLE}
            ;;
    esac
}

function verify_setup {
    declare -ra INSTALLS=( git node npm )

    for INSTALL in "${INSTALLS[@]}"
    do
        type ${INSTALL} > /dev/null 2>&1

        STATUS_INSTALL="$?"

        if [ ${STATUS_INSTALL} -ne 0 ]
        then
            echo_message --error "The '${INSTALL}' command is not installed. Re-run the script."

            exit ${ERROR_RECOVERABLE}
        fi
    done
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

if [ $# -eq 1 ]
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

verify_access

machine_setup

verify_setup

echo_message --success "Completed configuration of the machine."

script_cleanup
