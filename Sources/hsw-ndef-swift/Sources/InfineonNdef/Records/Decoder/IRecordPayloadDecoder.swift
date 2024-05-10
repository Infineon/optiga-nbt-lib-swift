// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Interface is to decode the NDEF record payload byte array
public protocol IRecordPayloadDecoder {
    /// Decodes the NDEF record payload byte array into the record data structure.
    ///
    /// - Parameter payload: NDEF record payload data
    ///
    /// - Returns: Abstract record data structure
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    func decodePayload(payload: Data) throws -> AbstractRecord
}
