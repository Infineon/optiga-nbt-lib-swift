// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonNdef

/// Decodes the payload of the brand protection record.
public class BrandProtectionRecordPayloadDecoder: IRecordPayloadDecoder {
    /// Private tag for the logger message header
    private let headerTag = "BrandProtectionRecordPayloadDecoder"

    /// Decodes the brand protection record payload bytes into the record
    /// data structure.
    ///
    /// - Parameter payload: Payload of the brand protection record
    /// containing the X.509 v3 certificate.
    ///
    /// - Returns: Brand protection record data structure.
    ///
    /// - Throws: ``CertificateError`` If unable to decode the
    /// payload X.509 v3 certificate
    ///
    public func decodePayload(payload: Data) throws -> AbstractRecord {
        NdefManager.getLogger()?.debug(header: headerTag, data: payload)
        NdefManager.getLogger()?.info(header: headerTag,
                                      message: "Payload decoded successfully.")
        return BrandProtectionRecord(certificate: payload)
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
