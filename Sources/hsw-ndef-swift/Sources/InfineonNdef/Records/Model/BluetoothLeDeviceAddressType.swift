// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Enumeration representing the Bluetooth LE address types.
public enum BluetoothLeDeviceAddressType: UInt8 {
    /// LSB = 1, random device address.
    case randomDevice = 0x01

    /// LSB = 0, public device address.
    case publicDevice = 0x00

    ///  Gets the LE address type enumeration with respect to the input value.
    ///
    /// - Parameter value: Bluetooth LE address value
    /// - Returns: Returns the LE address type enumeration.
    ///
    public static func getEnumByValue(value: UInt8) ->
        BluetoothLeDeviceAddressType? {
        if let enumCategory = BluetoothLeDeviceAddressType(rawValue: value) {
            return enumCategory
        }
        return nil
    }
}
