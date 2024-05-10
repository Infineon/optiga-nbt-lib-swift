// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Decodes the payload byte array of the URI record type.
public class UriRecordPayloadDecoder: IRecordPayloadDecoder {
    /// Private tag for the logger message header
    private let headerTag = "UriRecordPayloadDecoder"

    /// Decodes the URI record payload byte array into the URI record structure.
    ///
    /// - Parameter payload: URI record payload data
    ///
    /// - Returns: Abstract record data structure
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    public func decodePayload(payload: Data) throws -> AbstractRecord {
        NdefManager.getLogger()?.debug(header: headerTag, data: payload)
        do {
            if payload.isEmpty {
                NdefManager.getLogger()?.error(header: headerTag,
                                              message: RecordDecoderUtils.errMessageInvalidPayload)
                throw NdefError(description: RecordDecoderUtils.errMessageInvalidPayload)
            }
            let identifierCode = try Int(Utils.getUInt8WithIndex(index: 0,
                                                        data: payload))
            guard let uri = try String(bytes: Utils.getSubData(offset: 1,
                                                               data: payload,
                                                               length: payload.count),
                                       encoding: .utf8)
            else {
                NdefManager.getLogger()?.error(header: headerTag,
                                              message: RecordDecoderUtils.errMessageInvalidPayload)
                throw NdefError(description: RecordDecoderUtils.errMessageInvalidPayload)
            }
            let uriRecord = try UriRecord(
                identifierCode: identifierCode, uri: uri)
            NdefManager.getLogger()?.info(header: headerTag, message: "Payload decoded successfully.")
            return uriRecord
        } catch {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: RecordDecoderUtils.errMessageInvalidPayload)
            throw NdefError(description: RecordDecoderUtils.errMessageInvalidPayload)
        }
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
