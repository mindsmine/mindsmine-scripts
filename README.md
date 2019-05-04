# mindsmine-scripts #

[![Build Status](https://travis-ci.org/mindsmine/mindsmine-scripts.svg?branch=master)](https://travis-ci.org/mindsmine/mindsmine-scripts)

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
$ curl https://raw.githubusercontent.com/mindsmine/mindsmine-scripts/master/src/setup_dev_env.sh -o setup_dev_env.sh -s

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
$ curl https://raw.githubusercontent.com/mindsmine/mindsmine-scripts/master/src/setup_ssh_keys.sh -o setup_ssh_keys.sh -s

#
# Run the script
#
$ sh setup_ssh_keys.sh
```

---

### Miscellaneous - Using Scripts ###

All scripts have ```--help | -h``` option. When in doubt, use it for clarification

```bash
$ sh <downloaded script> --help
```

---

### Releases ###

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