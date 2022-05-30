# Playground

The purpose is to showcase how the `set -e` affects the working of the script. Important to note that **no** information is lost and the wrapper function always retains the control.

## When `set -e` is used

**Non-Verbose Output**

```bash
    $ ./work.sh

    This section of the code will always be reached.
    The script exited with exit code = 0
```

**Verbose Output**

```bash
    $ ./work.sh --verbose

    FROM INSIDE 'pass.sh' FILE.
    This file will always pass.
    Exiting in next line.

    This section of the code will always be reached.
    The script exited with exit code = 0

    FROM INSIDE 'fail.sh' FILE.
    This file will always fail with the exit code '100'.
    Exiting in next line.
```

## When `set -e` is NOT used

**Non-Verbose Output**

```bash
    $ ./work.sh

    This section of the code will always be reached.
    The script exited with exit code = 0

    This section of the code will always be reached.
    The script exited with exit code = 100
```

**Verbose Output**

```bash
    $ ./work.sh --verbose

    FROM INSIDE 'pass.sh' FILE.
    This file will always pass.
    Exiting in next line.

    This section of the code will always be reached.
    The script exited with exit code = 0

    FROM INSIDE 'fail.sh' FILE.
    This file will always fail with the exit code '100'.
    Exiting in next line.

    This section of the code will always be reached.
    The script exited with exit code = 100
```
