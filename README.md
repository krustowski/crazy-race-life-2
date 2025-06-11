# CrazyRaceLife2 (CRL2)

A GTA SA:MP gamemode scripted in the pawn lang.


## Features

+ ATM for banking services
    + At least one ATM per city/town/village
+ Real Estate
    + Custom spawn point
    + Custom vehicle attached
    + Custom safehouse


## How to build

Fetch the `sampctl` tool for the `pawn` package management.

```
dnf install sampctl
```

Clone this repo and try to build it using the `build` command (warnings are omitted to see the possible errors clearly):

```
sampctl ensure
sampctl build
```

The compiled `.amx` gamemode file should then pop up in the `gamemodes` directory.


## How to run

Simply put the compiled `.amx` gamemode file into the `gamemodes` directory of your SAMP server's. Then update the server config file (`config.cfg`, or `config.json`) like this:

```
gamemode crl2
```

```json
[...]
        "main_scripts": [
            "crl2 1"
        ],
[...]
```

The examples above are shown respectively to the config file names mentioned.


