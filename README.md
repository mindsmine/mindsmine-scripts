# mindsmine-scripts #

[![Build Status](https://travis-ci.org/mindsmine/mindsmine-scripts.svg?branch=master)](https://travis-ci.org/mindsmine/mindsmine-scripts)

More often than not, DevOps are a crucial part of a developer's life. Setting up the development environment and making
sure the minimal software is installed on one's machine, are just but a few repetitive operations. **mindsmine-scripts**
makes a attempt at providing simple means to handle such scenarios.

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

### Miscellaneous - Using Scripts ###

All scripts have ```--help | -h``` option. When in doubt, use it for clarification

```bash
$ sh <downloaded script> --help
```

---

### Releases ###

**1.0.0**
* Added `setup_dev_env.sh`
  * Supports Linux (RHEL and CentOS) and MacOS
  * Installs `git`, `node` (and `npm`) 