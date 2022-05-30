# Playground

The purpose is to showcase how the `set -e` affects the working of the script. Important to note that **no** information is lost and the wrapper function always retains the control.

## When `set -e` is used

As can be seen, the wrapper script **loses** control and there is no way to `catch` the issue and therefore cannot react to it.

**Non-Verbose Output**

```bash
$ ./work.sh

Calling 'pass.sh' file.

This portion is in the wrapper script.
The 'pass.sh' script exited with exit code = 0
NO information is ever lost. Exit code is maintained. And this wrapper script retains control.

Calling 'fail.sh' file.
```

**Verbose Output**

```bash
$ ./work.sh --verbose

Calling 'pass.sh' file.

FROM INSIDE 'pass.sh' FILE.
This file will always pass.
Exiting from inside the 'pass.sh' file.

This portion is in the wrapper script.
The 'pass.sh' script exited with exit code = 0
NO information is ever lost. Exit code is maintained. And this wrapper script retains control.

Calling 'fail.sh' file.

FROM INSIDE 'fail.sh' FILE.
This file will always fail with the exit code '100'.
Exiting from inside the 'fail.sh' file.
```

## When `set -e` is **NOT** used

As can be seen, the wrapper script **retains** control and can `catch` the issue and therefore can react to it.

**Non-Verbose Output**

```bash
$ ./work.sh

Calling 'pass.sh' file.

This portion is in the wrapper script.
The 'pass.sh' script exited with exit code = 0
NO information is ever lost. Exit code is maintained. And this wrapper script retains control.

Calling 'fail.sh' file.

This portion is in the wrapper script and will be reached when 'set -e' is NOT used.
The 'fail.sh' script exited with exit code = 100
NO information is ever lost. Exit code is maintained. And this wrapper script retains control.
```

**Verbose Output**

```bash
$ ./work.sh --verbose

Calling 'pass.sh' file.

FROM INSIDE 'pass.sh' FILE.
This file will always pass.
Exiting from inside the 'pass.sh' file.

This portion is in the wrapper script.
The 'pass.sh' script exited with exit code = 0
NO information is ever lost. Exit code is maintained. And this wrapper script retains control.

Calling 'fail.sh' file.

FROM INSIDE 'fail.sh' FILE.
This file will always fail with the exit code '100'.
Exiting from inside the 'fail.sh' file.

This portion is in the wrapper script and will be reached when 'set -e' is NOT used.
The 'fail.sh' script exited with exit code = 100
NO information is ever lost. Exit code is maintained. And this wrapper script retains control.
```
