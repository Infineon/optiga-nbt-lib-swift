// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonNdef

/// Encodes the payload bytes of the brand protection record.
public class BrandProtectionRecordPayloadEncoder: IRecordPayloadEncoder {
    /// Error message if the abstract record is not an instance of the
    /// brand protection record.
    public static let errMessageUnknownRecord =
        "Abstract record should be instance of brand protection record"

    /// Error message if the payload is invalid.
    private let errMessagePayloadNull = "Payload should not be null"

    /// Private tag for the logger message header
    private let headerTag = "BrandProtectionRecordPayloadEncoder"

    /// Encodes the brand protection record data structure into the record
    /// payload bytes.
    ///
    /// - Parameter abstractRecord: Brand protection record containing the
    /// certificate.
    ///
    /// - Returns: Encoded record payload as byte data.
    ///
    /// - Throws: ``NdefError`` If unable to encode the payload X.509 v3
    /// certificate bytes.
    ///
    public func encodePayload(abstractRecord: AbstractRecord) throws -> Data {
        guard let record = abstractRecord as? BrandProtectionRecord else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: BrandProtectionRecordPayloadEncoder.errMessageUnknownRecord)
            throw NdefError(description: BrandProtectionRecordPayloadEncoder.errMessageUnknownRecord)
        }
        guard let payload = record.getPayload() else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errMessagePayloadNull)
            throw NdefError(description: errMessagePayloadNull)
        }
        NdefManager.getLogger()?.debug(header: headerTag,
                                      data: payload)
        NdefManager.getLogger()?.info(header: headerTag,
                                      message: "Payload encoded successfully.")
        return payload
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
