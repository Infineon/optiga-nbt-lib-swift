// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Encodes the handover select record type to payload byte array.
public class HandoverSelectRecordPayloadEncoder: IRecordPayloadEncoder {
    /// Private tag for the logger message header
    private let headerTag = "HandoverSelectRecordPayloadEncoder"

    /// Encodes the handover select record data structure into the record payload byte array.
    ///
    /// - Parameter abstractRecord: WellKnownRecord ``HandoverSelectRecord``
    ///
    /// - Returns: Record payload data
    ///
    /// - Throws: ``NdefError`` If unable to encode the record payload
    ///
    public func encodePayload(abstractRecord: AbstractRecord) throws -> Data {
        var data = Data()
        var records = [AbstractRecord]()
        guard let handoverSelectRecord =
            abstractRecord as? HandoverSelectRecord
        else {
            NdefManager.getLogger()?.warning(header: headerTag,
                                          message: "WellKnownRecord is not type of HandoverSelectRecord")
            return Data()
        }
        records.append(
            contentsOf: handoverSelectRecord.getAlternativeCarrierRecords())
        if let errorRecord = handoverSelectRecord.getErrorRecord() {
            records.append(errorRecord)
        }

        guard let majorVersion = handoverSelectRecord.getMajorVersion(),
              let minorVersion = handoverSelectRecord.getMinorVersion()
        else {
            NdefManager.getLogger()?.warning(header: headerTag,
                                          message: "Version is empty")
            return Data()
        }
        let version = UInt8((majorVersion << 4) |
            (minorVersion & 0xff))
        data.append(version)
        data = try NdefMessageEncoder.instance().encode(records: records, data: data)
        NdefManager.getLogger()?.debug(header: headerTag, data: data)
        NdefManager.getLogger()?.info(header: headerTag, message: "Payload encoded successfully.")
        return data
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
