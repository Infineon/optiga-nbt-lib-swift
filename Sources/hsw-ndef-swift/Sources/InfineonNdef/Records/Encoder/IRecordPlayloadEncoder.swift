// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Interface to encode the payload of the NDEF record.
public protocol IRecordPayloadEncoder {
    /// Encodes the record payload.
    ///
    /// - Parameter abstractRecord: Library-known NDEF record
    ///
    /// - Returns: NDEF record payload data
    ///
    /// - Throws: ``NdefError`` If unable to encode the record payload
    ///
    func encodePayload(abstractRecord: AbstractRecord) throws -> Data
}
