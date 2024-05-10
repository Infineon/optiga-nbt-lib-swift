// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// A Record type can be any NDEF well known record types. E.g Smart poster record, Text Record, etc.
public class RecordType {
    private var type: Data

    /// Constructor to set the record type with the give byte array.
    ///
    /// - Parameter type: type record type which is of Data
    ///
    public init(type: Data) {
        self.type = type
    }

    /// Constructor to set the record type with the give string type.
    ///
    /// - Parameter type:  type record type of string e.g  RecordType("T")
    ///
    public init(type: String) {
        self.type = type.data(using: NdefConstants.defaultCharset)!
    }

    /// Gets the record type
    ///
    /// - Returns: The type of record as Data
    ///
    public func getType() -> Data {
        return type
    }

    /// Gets the record type
    ///
    /// - Returns: The type of record as String
    ///
    public func getTypeAsString() -> String? {
        return String(data: type, encoding: NdefConstants.defaultCharset)
    }
}
