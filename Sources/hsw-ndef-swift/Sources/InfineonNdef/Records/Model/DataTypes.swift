// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Enumeration representing the common data types.
public enum DataTypes: UInt8 {
    /// Bluetooth flags
    case flags = 0x01

    /// Incomplete list of 16-­bit service class UUIDs
    case incompleteServiceClassUuid16Bit = 0x02

    /// Complete list of 16-­bit service class UUIDs
    case completeServiceClassUuid16Bit = 0x03

    /// Incomplete list of 32-­bit service class UUIDs
    case incompleteServiceClassUuid32Bit = 0x04

    /// Complete list of 32-­bit service class UUIDs
    case completeServiceClassUuid32Bit = 0x05

    /// Incomplete list of 128-­bit service class UUIDs
    case incompleteServiceClassUuid128Bit = 0x06

    /// Complete list of 128-­bit service class UUIDs
    case completeServiceClassUuid128Bit = 0x07

    /// Shortened local name
    case shortenedLocalName = 0x08

    /// Complete local name
    case completeLocalName = 0x09

    /// Tx power level
    case txPowerLevel = 0x0a

    /// Class of device
    case deviceClass = 0x0d

    /// Simple pairing hash C-­192
    case simplePairingHashC192 = 0x0e

    /// Simple pairing randomizer R-­192
    case simplePairingRandomizerR192 = 0x0f

    /// Security manager TK value
    case securityManagerTkValue = 0x10

    /// Security manager out of band flags
    case securityManagerOobFlags = 0x11

    /// List of 16­-bit service solicitation UUIDs
    case serviceSolicitationUuids16Bit = 0x14

    /// List of 128­-bit service solicitation UUIDs
    case serviceSolicitationUuids128Bit = 0x15

    /// Service data ­16-­bit UUID
    case serviceDataUuids16Bit = 0x16

    /// Public target address
    case publicTargetAddress = 0x17

    /// Random target address
    case randomTargetAddress = 0x18

    /// Appearance
    case appearance = 0x19

    /// Advertising interval
    case advertisingInterval = 0x1a

    /// LE bluetooth device address
    case leBluetoothDeviceAddress = 0x1b

    /// LE bluetooth Role
    case leBluetoothRole = 0x1c

    /// Simple pairing hash C-­256
    case simplePairingHashC256 = 0x1d

    /// Simple pairing randomizer R-256
    case simplePairingRandomizerR256 = 0x1e

    /// List of 32­-bit service solicitation UUIDs
    case serviceSolicitationUuids32Bit = 0x1f

    /// Service data ­32-­bit UUID
    case serviceDataUuids32Bit = 0x20

    /// Service data ­128-­bit UUID
    case serviceDataUuids128Bit = 0x21

    /// LE secure connections confirmation Value
    case leBluetoothSecureConnectionsConfirmationValue = 0x22

    /// LE secure connections random value
    case leBluetoothSecureConnectionsRandomValue = 0x23

    /// URI
    case uri = 0x24

    /// Indoor positioning
    case indoorPositioning = 0x25

    /// Transport discovery data
    case transportDiscoveryData = 0x26

    /// LE supported features
    case leBluetoothSupportedFeatures = 0x27

    /// Channel map update indication
    case channelMapUpdateIndication = 0x28

    /// PB-­ADV: A provisioning bearer used to provision a device over the
    /// Bluetooth advertising channels.
    case pbAdv = 0x29

    /// Mesh message
    case meshMessage = 0x2a

    /// Mesh beacon
    case meshBeacon = 0x2b

    /// Big info
    case bigInfo = 0x2c

    /// Broadcast code
    case broadcastCode = 0x2d

    /// Resolvable set identifier
    case resolvableSetIdentifier = 0x2e

    /// Advertising interval ­long
    case advertisingIntervalLong = 0x2f

    /// Broadcast name
    case broadcastName = 0x30

    /// 3D information data
    case informationData3d = 0x3d

    /// Manufacturer specific data
    case manufacturerSpecificData = 0xff

    /// Gets the data type enumeration with respect to the input value.
    ///
    /// - Parameter value: Data type value
    /// - Returns: Returns the data type enumeration.
    ///
    public static func getEnumByValue(value: UInt8) -> DataTypes? {
        if let enumCategory = DataTypes(rawValue: value) {
            return enumCategory
        }
        return nil
    }
}
