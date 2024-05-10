// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Decodes the payload byte array of error record type.
public class ErrorRecordPayloadDecoder: IRecordPayloadDecoder {
    /// Defines the minimum length of the error record payload data.
    private let minLength = 1

    /// Defines the error reason field index.
    private let errorReasonFieldIndex = 0

    /// Private tag for the logger message header
    private let headerTag = "ErrorRecordPayloadDecoder"

    /// Defines the error data field start index.
    private var errorDataFieldStartIndex = 1

    /// Decodes the error record payload byte array into the record data structure.
    ///
    /// - Parameter payload: ErrorRecord payload data
    ///
    /// - Returns: Abstract record data structure
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    public func decodePayload(payload: Data) throws -> AbstractRecord {
        NdefManager.getLogger()?.debug(header: headerTag, data: payload)
        do {
            try RecordDecoderUtils.validatePayload(
                payload: payload, minExpectedLength: minLength)

            let errorDataFieldLength = payload.count - 1

            let errorRecord = try ErrorRecord(errorReason: Utils.getUInt8WithIndex(index: errorReasonFieldIndex, data: payload),
                                   errorData: Utils.getDataFromStream(
                                       length: errorDataFieldLength, data: payload,
                                       index: &errorDataFieldStartIndex))
            NdefManager.getLogger()?.info(header: headerTag, message: "Payload decoded successfully.")
            return errorRecord

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
