// swift-tools-version: 5.8.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import PackageDescription

let packageName = "InfineonNbt"
let packageVersion = "1.1.1"

let package = Package(
    name: packageName,
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
        .watchOS(.v7),
        .tvOS(.v14)
    ],
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    products: [
        .library(name: packageName, targets: ["InfineonNbt"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(path: "Sources/hsw-apdu-swift"),
        .package(path: "Sources/hsw-channel-swift"),
        .package(path: "Sources/hsw-logger-swift"),
        .package(path: "Sources/hsw-utils-swift"),
        .package(path: "Sources/hsw-ndef-swift"),
        .package(path: "Sources/hsw-ndef-bp-swift"),
        .package(path: "Sources/hsw-apdu-nbt-swift")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "InfineonNbt",
            dependencies: [
                .product(name: "InfineonApdu", package: "hsw-apdu-swift"),
                .product(name: "InfineonChannel", package: "hsw-channel-swift"),
                .product(name: "InfineonLogger", package: "hsw-logger-swift"),
                .product(name: "InfineonUtils", package: "hsw-utils-swift"),
                .product(name: "InfineonNdef", package: "hsw-ndef-swift"),
                .product(name: "InfineonNdefBrandProtection", package: "hsw-ndef-bp-swift"),
                .product(name: "InfineonApduNbt", package: "hsw-apdu-nbt-swift")
            ]
        )
    ]
)
