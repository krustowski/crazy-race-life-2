# CrazyRaceLife2 (CRL2)

A GTA SA:MP gamemode scripted in the pawn lang.

## how to build

Fetch the `sampctl` tool for the `pawn` package management.

```
dnf install sampctl
```

Clone this repo and try to build it using the `build` command (warnings are omitted to see the possible errors clearly):

```
sampctl ensure
sampctl build | grep errors
```

The compiled `.amx` gamemode file should then pop up in the `gamemodes` directory.

## how to run

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

### additional files (optional)

To run the gamemode properly, some other files may be needed as well. Files should be created automatically after the mode start-up. The path then would be:

+ `scriptfiles/_data_RealEstateProperties` (housing, real estate data)

An example housing data file can look like this:

```ini
properties=0,10101
[10101]
id=10101
label=SF The Very First House for Sell
cost=1500000
locationOffer=-2685.81,201.33,4.32,0.00
locationEntrance=-2688.62,198.50,7.15,0.00
locationVehicle=-2691.87,204.52,3.99,0.15
vehicleID=560
occupied=0
```

This configuration would be loaded after the server start, eventually creating the linked elements (pickups and vehicle). Generated elements would show in San Fierro downtown (west seaside) with a vehicle spawned there too.

It is vital to list the property IDs on the very first line, because that the loading function's entrypoint while reading the file. This (string) array is then "exploded" into tokens containing the numeric value of such bit. This is then used to navigate through the file sections (see `10101` property ID being listed on the first line, then being the name of the very next section).

## gamemode vademecum
