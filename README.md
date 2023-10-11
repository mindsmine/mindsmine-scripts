# mindsmine-scripts #

[![Build](https://github.com/mindsmine/mindsmine-scripts/actions/workflows/test.mac.yml/badge.svg)](https://github.com/mindsmine/mindsmine-scripts/actions/workflows/test.mac.yml)

[![Build](https://github.com/mindsmine/mindsmine-scripts/actions/workflows/test.linux.yml/badge.svg)](https://github.com/mindsmine/mindsmine-scripts/actions/workflows/test.linux.yml)

More often than not, DevOps are a crucial part of a developer's life. Setting up the development environment, making sure
the minimal software is installed on one's machine, maintaining keys, etc., are just but a few repetitive operations.
**mindsmine-scripts** makes a attempt at providing simple means to handle such scenarios.

---

### Setup Development Environment ###

This script installs the minimum software necessary for development work. This is an _**idempotent**_ procedure, hence
the script can be run frequently to stay up-to-date.

```bash
#
# Download the script
#
$ curl https://raw.githubusercontent.com/mindsmine/mindsmine-scripts/main/src/setup_dev_env.sh -o setup_dev_env.sh -s

#
# Run the script
#
$ sh setup_dev_env.sh
```

---

### Setup SSH Keys ###

This script flushes out the stale SSH keys and creates new SSH key pair based upon `RSA` algorithm. This script should
_**only**_ be used when SSH keys need to be flushed and renewed.

```bash
#
# Download the script
#
$ curl https://raw.githubusercontent.com/mindsmine/mindsmine-scripts/main/src/setup_ssh_keys.sh -o setup_ssh_keys.sh -s

#
# Run the script with default filename
#
$ sh setup_ssh_keys.sh

#
# Access the generated public SSH key
#
$ cat ~/.ssh/id_rsa.pub

#
# Run the script with filename
#
$ sh setup_ssh_keys.sh --filename=setup_ssh

#
# Access the generated public SSH key
#
$ cat ~/.ssh/setup_ssh.pub
```

---

### Miscellaneous - Using Scripts ###

All scripts have ```--help | -h``` option. When in doubt, use it for clarification

```bash
$ sh <downloaded script> --help
```

---

### Releases ###

**2.0.2**
* Updated supported operating systems
* Using Github actions in lieu of Travis CI

**2.0.1**
* Updated supported operating systems
* Remove unnecessary code

**2.0.0**
* Updated `setup_ssh_keys` to support filename argument
* Updated supported operating systems
* Remove unnecessary code

**1.1.2**
* Updated help information with version details

**1.1.1**
* Updated `setup_dev_env.sh` for the non-ruby script for Homebrew

**1.1.0**
* Updated tests for `setup_dev_env.sh`
  * Uses `docker` for testing within Travis CI setup
* Added `setup_ssh_keys.sh`
  * Supports Linux (RHEL and CentOS) and MacOS
  * Flushes old keys and creates new `RSA` based keys
* Added tests for `setup_ssh_keys.sh`

**1.0.0**
* Added `setup_dev_env.sh`
  * Supports Linux (RHEL and CentOS) and MacOS
  * Installs `git`, `node` (and `npm`)
