# `sampctl`

1.11.3 -  <>

## Commands (14)

### `sampctl init`

Usage: `sampctl init`

Helper tool to bootstrap a new package or turn an existing project into a package.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration
- `--dir value`: working directory for the project - by default, uses the current directory (default: ".")

---

### `sampctl ensure`

Usage: `sampctl ensure`

Ensures dependencies are up to date based on the `dependencies` field in `pawn.json`/`pawn.yaml`.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration
- `--dir value`: working directory for the project - by default, uses the current directory (default: ".")
- `--update`: update cached dependencies to latest version

---

### `sampctl install`

Usage: `sampctl install [package definition]`

Installs a new package by adding it to the `dependencies` field in `pawn.json`/`pawn.yaml` and downloads the contents.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration
- `--dir value`: working directory for the project - by default, uses the current directory (default: ".")
- `--dev`: for specifying dependencies only necessary for development or testing of the package

---

### `sampctl uninstall`

Usage: `sampctl uninstall [package definition]`

Uninstalls package by removing it from the `dependencies` field in `pawn.json`/`pawn.yaml` and deletes the contents.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration
- `--dir value`: working directory for the project - by default, uses the current directory (default: ".")
- `--dev`: for specifying development dependencies

---

### `sampctl release`

Usage: `sampctl release`

Creates a release version and tags the repository with the next version number, creates a GitHub release with archived package files.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration
- `--dir value`: working directory for the project - by default, uses the current directory (default: ".")

---

### `sampctl config`

Usage: `configure config options`

Allows configuring the field values for the config

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration

---

### `sampctl get`

Usage: `sampctl get [package definition] (target path)`

Clones a GitHub package to either a directory named after the repo or, if the cwd is empty, the cwd and then ensures the package.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration

---

### `sampctl build`

Usage: `sampctl build [build name]`

Builds a package defined by a `pawn.json`/`pawn.yaml` file.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration
- `--dir value`: working directory for the project - by default, uses the current directory (default: ".")
- `--forceEnsure`: forces dependency ensure before build
- `--dryRun`: does not run the build but outputs the command necessary to do so
- `--watch`: keeps sampctl running and triggers builds whenever source files change
- `--buildFile value`: declares a file to store the incrementing build number for easy versioning
- `--relativePaths`: force compiler output to use relative paths instead of absolute

---

### `sampctl run`

Usage: `sampctl run`

Compiles and runs a package defined by a `pawn.json`/`pawn.yaml` file.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration
- `--dir value`: working directory for the server - by default, uses the current directory (default: ".")
- `--container`: starts the server as a Linux container instead of running it in the current directory
- `--build --forceBuild`: build configuration to use if --forceBuild is set
- `--forceBuild`: forces a build to run before executing the server
- `--forceEnsure --forceBuild`: forces dependency ensure before build if --forceBuild is set
- `--noCache --forceEnsure`: forces download of plugins if --forceEnsure is set
- `--watch`: keeps sampctl running and triggers builds whenever source files change
- `--buildFile value`: declares a file to store the incrementing build number for easy versioning
- `--relativePaths`: force compiler output to use relative paths instead of absolute

---

### `sampctl template`

Usage: `sampctl template <subcommand>`

Provides commands for package templates

#### Subcommands (3)

### `sampctl template make`

Usage: `sampctl template make [name]`

Creates a template package from the current directory if it is a package.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration
- `--dir value`: working directory for the package - by default, uses the current directory (default: ".")
- `--update`: update cached dependencies to latest version

### `sampctl template build`

Usage: `sampctl template build [template] [filename]`

Builds the specified file in the context of the given template.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration

### `sampctl template run`

Usage: `sampctl template run [template] [filename]`

Builds and runs the specified file in the context of the given template.

#### Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration
- `--version value`: the SA:MP server version to use (default: "0.3.7")
- `--mode value`: runtime mode, one of: server, main, y_testing (default: "main")


---

### `sampctl version`

Show version number - this is also the version of the container image that will be used for `--container` runtimes.

---

### `sampctl completion`

output bash autocomplete code

---

### `sampctl docs`

Usage: `sampctl docs > documentation.md`

Generate documentation in markdown format and print to standard out.

---

### `sampctl help`

Usage: `Shows a list of commands or help for one command`

---

## Global Flags

- `--verbose`: output all detailed information - useful for debugging
- `--platform windows`: manually specify the target platform for downloaded binaries to either windows, `linux` or `darwin`.
- `--bare`: skip all pre-run configuration
- `--help, -h`: show help
- `--appVersion, -V, --version`: sampctl version


