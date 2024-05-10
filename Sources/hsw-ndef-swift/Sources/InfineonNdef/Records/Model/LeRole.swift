// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Enumeration representing the LE role data type which defines the LE role
/// capabilities of the device.
public enum LeRole: UInt8 {
    /// Only peripheral role is supported.
    case peripheral = 0x00

    /// Only central role is supported.
    case central = 0x01

    /// Peripheral and central roles are supported. Peripheral role is preferred
    /// for connection establishment.
    case peripheralCentral = 0x02

    /// Peripheral and central roles are supported. Central role is preferred for
    /// connection establishment.
    case centralPeripheral = 0x03

    /// Gets the LE role type enumeration with respect to input value.
    ///
    /// - Parameter value: Bluetooth LE role type value
    /// - Returns: Returns the LE role type enumeration.
    ///
    public static func getEnumByValue(value: UInt8) -> LeRole? {
        if let enumCategory = LeRole(rawValue: value) {
            return enumCategory
        }
        return nil
    }
}
