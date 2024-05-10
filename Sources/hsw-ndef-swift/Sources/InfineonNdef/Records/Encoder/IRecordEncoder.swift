// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Interface to encode the library known NDEF record types.
public protocol IRecordEncoder {
    /// Checks if the library supports encoding the specified record type.
    ///
    /// - Parameter recordType: NDEF record type
    ///
    /// - Returns: True if the record can be encoded by the library
    ///
    func canEncodeRecord(recordType: RecordType) -> Bool

    /// Encodes the NDEF record.
    ///
    /// - Parameters:
    ///   - header: Record header
    ///   - abstractRecord: NDEF record
    ///
    /// - Returns: Encoded NDEF record data
    ///
    /// - Throws: ``NdefError`` If unable to encode the NDEF record
    ///
    func encodeRecord(header: UInt8, abstractRecord: AbstractRecord) throws -> Data
}
