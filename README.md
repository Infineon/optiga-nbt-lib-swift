<!--
SPDX-FileCopyrightText: Copyright (c) 2024-2026 Infineon Technologies AG
SPDX-License-Identifier: CC-BY-4.0
-->

# OPTIGA™ Authenticate NBT Host Library for Swift

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)
[![REUSE](https://github.com/Infineon/optiga-nbt-lib-swift/actions/workflows/reuse-lint.yml/badge.svg?branch=main)](https://github.com/Infineon/optiga-nbt-lib-swift/actions/workflows/reuse-lint.yml)
[![Swift build](https://github.com/Infineon/optiga-nbt-lib-swift/actions/workflows/swift-build.yml/badge.svg?branch=main)](https://github.com/Infineon/optiga-nbt-lib-swift/actions/workflows/swift-build.yml)

This is the OPTIGA™ Authenticate NBT Host Library for Swift, which supports the utilization of the [OPTIGA™ Authenticate NBT](https://www.infineon.com/part/optiga-authenticate-nbt) in Swift-based applications.

## Overview

The OPTIGA™ Authenticate NBT Host Library for Swift offers an extensive API to interact with the OPTIGA™ Authenticate NBT and to utilize its full functionality. The host library is mainly intended to be used in Swift-based iOS apps interfacing to the OPTIGA™ Authenticate NBT via NFC.

### Features

- Sends command APDUs (C-APDU) and receives response APDUs (R-APDU) from the OPTIGA™ Authenticate NBT
- Configuration of OPTIGA™ Authenticate NBT via its configurator application
- Personalization and operational commands to support simplified interaction with the OPTIGA™ Authenticate NBT
- Enables the host application to build, encode, and decode NDEF records and messages with the NDEF library
- Supports building and parsing NDEF records of types "NFC Forum well known type" and "NFC Forum external type"
- Supports OPTIGA™ Authenticate NBT brand protection record

### User guide

This host library's [user guide](https://infineon.github.io/optiga-nbt/projects/optiga-nbt-lib-swift) is available as part of the online documentation for the host software offering of the OPTIGA™ Authenticate NBT on [GitHub.io](https://infineon.github.io/optiga-nbt).

## Getting started

This section contains information on how to setup the OPTIGA™ Authenticate NBT Host Library for Swift and integrate it into custom Swift-based iOS/macOS applications.

### Setup and requirements

Minimum required versions:

- iOS version 15 and higher
- macOS version 11 and higher

### Project layout

```text
├── docs/            # Includes documentation sources and images
├── LICENSES/        # list of licenses used in this project
└── Sources/         # Includes dependent modules of the host library
```

### Build

The host library uses the Swift Package Manager to build.

```sh
# Build the code
swift build
```

To build the documentation use the following command

```sh
swift package generate-documentation
```

### Usage

See this host library's [user guide](https://infineon.github.io/optiga-nbt/projects/optiga-nbt-lib-swift) for more information.

## Additional information

This section lists additional resources and information related to this repository.

### Contact

In case of questions regarding this repository and its contents, refer to [MAINTAINERS.md](MAINTAINERS.md) for the contact details of this project's maintainers.

### Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution instructions and refer to our [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

### Licensing

Please see our [LICENSE](LICENSE) for copyright and license information.

This project follows the [REUSE](https://reuse.software/) approach, so copyright and licensing
information is available for every file (including third party components) either in the file
header, an individual *.license file or the [REUSE.toml](REUSE.toml) file. All licenses can be found in the
[LICENSES](LICENSES) folder.

### Related resources

- [OPTIGA™ Authenticate NBT: Host software overview](https://github.com/Infineon/optiga-nbt)
- [OPTIGA™ Authenticate NBT: Host software documentation](https://infineon.github.io/optiga-nbt)
  - [Host Library for Swift](https://infineon.github.io/optiga-nbt/projects/optiga-nbt-lib-swift)
- [OPTIGA™ Authenticate NBT: Product page](https://www.infineon.com/part/optiga-authenticate-nbt)
