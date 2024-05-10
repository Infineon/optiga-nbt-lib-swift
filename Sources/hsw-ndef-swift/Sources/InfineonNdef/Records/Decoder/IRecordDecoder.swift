// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Interface to decode the NDEF well known record types.
public protocol IRecordDecoder {
    /// Checks if the library supports decoding the specified record type.
    ///
    /// - Parameter recordType: NDEF record type
    ///
    /// - Returns: Returns true, if the record can be decoded by the library.
    ///
    func canDecodeRecord(recordType: Data) -> Bool

    /// Decodes the NDEF record.
    ///
    /// - Parameters:
    ///   - header: Header of the NDEF record
    ///   - record: NDEF record
    ///   - index: Index to decode the data
    ///
    /// - Returns: Returns the decoded NDEF record.
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    func decodeRecord(header: UInt8, record: Data, index: inout Int) throws -> AbstractRecord
}
