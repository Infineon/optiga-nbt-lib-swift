// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Encodes the NDEF (NFC Data Exchange Format) message. Returns a encoder
/// function that encodes NDEF record objects into an NDEF message octet
/// sequence.
public final class NdefMessageEncoder {
    /// Short Record Max Length
    public static let maxLengthForShortRecord = 255

    /// Private instance of NDEF message encoder to encode the NDEF message
    private static let encoder = NdefMessageEncoder()

    /// Private tag for the logger message header
    private let headerTag = "NdefMessageEncoder"

    /// Private constructor to restrict object creation.
    private init() {
            // Private constructor to restrict object creation.
    }

    /// Returns the instance of NDEF message encoder.
    ///
    /// - Returns: Returns the singleton instance of ``NdefMessageEncoder``.
    ///
    public static func instance() -> NdefMessageEncoder {
        return encoder
    }

    /// Encodes the collection of NDEF records and return as raw byte array
    ///
    /// - Parameter ndefRecords: Collection of NDEF records that are
    /// to be encoded to raw byte array data
    ///
    /// - Returns:  Raw byte array data that is encoded
    ///
    /// - Throws: Throws an ``NdefError`` if unable to encode the
    /// NDEF message bytes.
    ///
    public func encode(ndefRecords: [AbstractRecord]) throws -> Data {
        if ndefRecords.isEmpty {
            NdefManager.getLogger()?.warning(header: headerTag,
                                          message: "No records found")
            return Data([0xd0, 0x00, 0x00])
        }
        var stream = Data()
        var header = NdefConstants.mbFlag
        var index = 0

        while index < ndefRecords.count {
            let tempRecord = ndefRecords[index]
            if index == ndefRecords.count - 1 {
                header |= NdefConstants.meFlag
            }
            let record = try RecordEncoder().encodeRecord(header: header, abstractRecord: tempRecord)
            stream.append(record)
            header = 0x00
            index += 1
        }
        NdefManager.getLogger()?.debug(header: headerTag, data: stream)
        NdefManager.getLogger()?.info(header: headerTag, message: "Payload encoded successfully.")
        return stream
    }

    /// Encodes the list of abstract records into bytes.
    ///
    /// - Parameters:
    ///   - records: Collection of abstract records.
    ///   - data: Byte array data to write the NDEF message.
    ///
    /// - Returns: Raw byte array data that is encoded
    ///
    /// - Throws: Throws an ``NdefError`` if unable to
    /// encode the NDEF message bytes.
    ///
    public func encode(records: [AbstractRecord], data: Data) throws -> Data {
        var newData = data
        let bytes = try encode(ndefRecords: records)
        newData.append(bytes)
        return newData
    }
}
