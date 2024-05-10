// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

///  Decodes the payload byte array of handover select record type.
public class HandoverSelectRecordPayloadDecoder: IRecordPayloadDecoder {
    /// Defines the minimum length of the handover select record data bytes.
    private let minLength = 2

    /// Defines the offest value to decode message
    private let messageDecryptOffset = 1

    /// Defines the index of payload version
    private let payloadVersionIndex = 0

    /// Defines the mask for major version.
    private let majorVersionMask: UInt8 = 0xf0

    /// Defines the mask for minor version.
    private let minorVersionMask: UInt8 = 0x0f

    /// Private tag for the logger message header
    private let headerTag = "HandoverSelectRecordPayloadDecoder"

    /// Error message if unable to decode the payload.
    public static let errMessageEmptyRecords =
        "Record needs at least 1 record. Both alternate-carrier and error is not present"

    /// Decodes the handover select record payload byte array
    /// into the handover select record structure.
    ///
    /// - Parameter payload: Handover select record payload data
    ///
    /// - Returns: Abstract record data structure
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    public func decodePayload(payload: Data) throws -> AbstractRecord {
        try RecordDecoderUtils.validatePayload(
            payload: payload, minExpectedLength: minLength)
        NdefManager.getLogger()?.debug(header: headerTag, data: payload)
        do {
            let version = try Utils.getUInt8WithIndex(index: payloadVersionIndex, data: payload)
            let handoverSelectRecord = HandoverSelectRecord()
            handoverSelectRecord.setMinorVersion(
                minorVersion: version & minorVersionMask)
            handoverSelectRecord.setMajorVersion(
                majorVersion: (version & majorVersionMask) >> 4)
            var stream = Data()
            try stream.append(Utils.getSubData(offset: messageDecryptOffset, data: payload, length: payload.count))
            let records = try NdefMessageDecoder.instance().decode(stream: stream).getNdefRecords()
            for abstractRecord: AbstractRecord in records {
                if let acr = abstractRecord as? AlternativeCarrierRecord {
                    handoverSelectRecord.addAlternativeCarrierRecord(
                        alternativeCarrierRecord: acr)
                } else if let errorRecord = abstractRecord as? ErrorRecord {
                    handoverSelectRecord.setErrorRecord(errorRecord: errorRecord)
                }
                // Ignoring other record types as per the specification.
            }
            if handoverSelectRecord.getAlternativeCarrierRecords().isEmpty &&
                handoverSelectRecord.getErrorRecord() != nil {
                NdefManager.getLogger()?.error(header: headerTag,
                                              message: HandoverSelectRecordPayloadDecoder.errMessageEmptyRecords)
                throw NdefError(description:
                    HandoverSelectRecordPayloadDecoder.errMessageEmptyRecords)
            }
            NdefManager.getLogger()?.info(header: headerTag, message: "Payload decoded successfully.")
            return handoverSelectRecord
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
