// swift-tools-version: 5.8.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import PackageDescription

let packageName = "InfineonApdu"
let packageVersion = "0.4.2"

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
        .watchOS(.v7),
        .tvOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: packageName,
            targets: ["InfineonApdu"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // Adds a remote package dependency given a branch requirement.
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(path: "../hsw-utils-swift"),
        .package(path: "../hsw-channel-swift"),
        .package(path: "../hsw-logger-swift")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "InfineonApdu",
            dependencies: [.product(name: "InfineonUtils", package: "hsw-utils-swift"),
                           .product(name: "InfineonChannel", package: "hsw-channel-swift"),
                           .product(name: "InfineonLogger", package: "hsw-logger-swift")]),
    ])
