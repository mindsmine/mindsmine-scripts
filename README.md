# mindsmine-scripts #

[![Build Status](https://travis-ci.org/mindsmine/mindsmine-scripts.svg?branch=master)](https://travis-ci.org/mindsmine/mindsmine-scripts)

More often than not, DevOps are a crucial part of a developer's life. Setting up the development environment and making
sure the minimal software is installed on one's machine, are just but a few repetitive operations. **mindsmine-scripts**
makes a attempt at providing simple means to handle such scenarios.

---

<<<<<<< HEAD
### Releases ###

**1.0.0**
* Installs `node` (and `npm`)
* Installs `git`
=======
### Setup Development Environment ###

This script installs the minimum software (_at least_ ```git```, ```node```, etc.) that is necessary for the development
work. This is an _**idempotent**_ procedure, hence the script can be run frequently to stay up-to-date.

```bash
#
# Download the script
#
$ curl https://raw.githubusercontent.com/mindsmine/mindsmine-scripts/master/src/dev_setup.sh -o dev_setup.sh -s

#
# Run the script
#
$ sh dev_setup.sh
```

---

### Miscellaneous - Using Scripts ###

All scripts have ```--help | -h``` option. When in doubt, use it for clarification

```bash
$ sh <downloaded script> --help
```
>>>>>>> 53e7f2209e724e74eda56010bb24fb4017cd2b06
