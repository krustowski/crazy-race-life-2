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

## Vademecum

### Real Estate

Each property ID has to be unique server-wide. It is recommended to use 5-digit format like `40605`, where:

+ `4` stands for the greater zone ID 
+ `06` stands for a district/block ID (incremented)
+ `05` stands for a property ID within the same district/block

Greater zone IDs:

```
1 - San Fierro
2 - Desert
3 - Las Venturas
4 - Countryside, Farms
5 - Los Santos
```

## omp for Linux

```
-h "95.216.7.113" -p "39876" -n "krusty" -g "C:\\Program Files (x86)\\Rockstar Games\\GTA San Andreas\\"
```
