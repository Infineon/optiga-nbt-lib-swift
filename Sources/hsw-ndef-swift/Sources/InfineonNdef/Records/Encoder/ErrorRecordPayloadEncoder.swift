// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Encodes the error record type to payload byte array.
public class ErrorRecordPayloadEncoder: IRecordPayloadEncoder {
    /// Defines empty error data reference size.
    private let emptyErrorDataSize = 0

    /// Defines start error data reference size.
    private let errorDataByteStartOffset = 0

    /// Private tag for the logger message header
    private let headerTag = "ErrorRecordPayloadEncoder"

    /// Defines the length.
    private let defLen = 1

    /// Defines the error reason field index.
    private let errorReasonFieldIndex = 0

    /// Defines the error data field start index.
    private let errorDataFieldStartIndex = 1

    /// Encodes the error record data structure into the record payload byte array.
    ///
    /// - Parameter abstractRecord: WellKnownRecord ``ErrorRecord``
    ///
    /// - Returns: Record payload data
    ///
    public func encodePayload(abstractRecord: AbstractRecord) -> Data {
        guard let errorRecord = abstractRecord as? ErrorRecord else {
            NdefManager.getLogger()?.warning(header: headerTag,
                                          message: "WellKnownRecord is not type of ErrorRecord")
            // Handle appropriately if the wellKnownRecord is not of type ErrorRecord
            return Data()
        }

        var errorRecordPayloadAsBytes: Data
        if let errorData = errorRecord.getErrorData(),
           errorData.count != emptyErrorDataSize {
            errorRecordPayloadAsBytes = Data(repeating: 0,
                                             count: errorData.count + defLen)
            _ = Utils.dataCopy(src: errorData,
                               srcOffset: errorDataByteStartOffset,
                               dest: &errorRecordPayloadAsBytes,
                               destOffset: errorDataFieldStartIndex,
                               length: errorData.count)
        } else {
            errorRecordPayloadAsBytes = Data(repeating: 0, count: defLen)
        }
        guard let errorResponse = errorRecord.getErrorReason() else {
            NdefManager.getLogger()?.warning(header: headerTag,
                                          message: "ErrorReason is empty")
            return Data()
        }
        errorRecordPayloadAsBytes[errorReasonFieldIndex] = errorResponse
        NdefManager.getLogger()?.debug(header: headerTag, data: errorRecordPayloadAsBytes)
        NdefManager.getLogger()?.info(header: headerTag, message: "Payload encoded successfully.")
        return errorRecordPayloadAsBytes
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
