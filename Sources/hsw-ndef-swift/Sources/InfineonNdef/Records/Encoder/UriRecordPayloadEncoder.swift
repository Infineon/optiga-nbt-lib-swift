// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Encodes the URI record type to payload byte array.
public class UriRecordPayloadEncoder: IRecordPayloadEncoder {
    /// Error message if URI record is empty.
    private static let errMessageEmptyUri = "UriRecord does not have URI"

    /// Error message if URI record is invalid.
    private static let errMessageInvalidUri = "UriRecord have invalid URI"

    /// Private tag for the logger message header
    private let headerTag = "UriRecordPayloadEncoder"

    /// Encodes the URI record data structure into the record payload byte array.
    ///
    /// - Parameter abstractRecord: URI record
    ///
    /// - Returns: Record payload data
    ///
    /// - Throws: ``NdefError`` If unable to encode the record payload
    ///
    public func encodePayload(abstractRecord: AbstractRecord) throws -> Data {
        guard let uriRecord = abstractRecord as? UriRecord else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: UriRecordPayloadEncoder.errMessageInvalidUri)
            throw NdefError(description: UriRecordPayloadEncoder.errMessageInvalidUri)
        }
        if uriRecord.getUri().isEmpty {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: UriRecordPayloadEncoder.errMessageEmptyUri)
            throw NdefError(description: UriRecordPayloadEncoder.errMessageEmptyUri)
        }
        guard let uriAsBytes = getUriAsBytes(uri: uriRecord.getUri()) else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: UriRecordPayloadEncoder.errMessageInvalidUri)
            throw NdefError(description: UriRecordPayloadEncoder.errMessageInvalidUri)
        }
        var payload = Data()
        payload.append(UInt8(uriRecord.getUriIdentifier().rawValue))
        payload.append(uriAsBytes)
        NdefManager.getLogger()?.debug(header: headerTag, data: payload)
        NdefManager.getLogger()?.info(header: headerTag, message: "Payload encoded successfully.")
        return payload
    }

    /// Converting URI string to data bytes
    ///
    /// - Parameter uri: URI to be converted
    ///
    /// - Returns: Converted URI bytes
    ///
    private func getUriAsBytes(uri: String) -> Data? {
        uri.data(using: UriRecord.defaultUriCharset)
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
