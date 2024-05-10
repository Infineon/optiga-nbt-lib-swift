// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Encodes the records into NDEF records.
public class RecordEncoder: IRecordEncoder {
    /// Maximum length for the short record is 255.
    private let maxLengthForShortRecord = 255

    /// Private tag for the logger message header
    private let headerTag = "RecordEncoder"

    /// Error message for invalid id length
    private let errInvalidIdLength = "Expected record id length <= 255 bytes"

    /// Error message for invalid payload type
    private let errInvalidPayloadType = "Unable to find encoder for payload"

    /// Length of the payload
    private let payloadLengthSize = 4

    /// NDEF record payload encoder
    private var payloadEncoder: IRecordPayloadEncoder?

    /// Checks if the library supports encoding the specified record type.
    ///
    /// - Parameter recordType: NDEF ``RecordType``
    ///
    /// - Returns: Returns true, if record can be encoded by the library.
    ///
    public func canEncodeRecord(recordType: RecordType) -> Bool {
        payloadEncoder = RecordUtils.getPayloadEncoder(recordType: recordType)
        return payloadEncoder != nil
    }

    /// Encodes the NDEF record.
    ///
    /// - Parameters:
    ///   - header: Record header
    ///   - abstractRecord: NDEF record
    ///
    /// - Returns: Returns the encoded byte array of the NDEF record.
    ///
    /// - Throws: ``NdefError`` Throws an NDEF error if unable to
    /// encode the record.
    ///
    public func encodeRecord(header: UInt8, abstractRecord: AbstractRecord) throws -> Data {
        let id: Data? = abstractRecord.id
        if let id = id, id.count > 255 {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errInvalidIdLength)
            throw NdefError(description: errInvalidIdLength)
        }
        var stream = Data()
        var payload = Data()
        if let record = abstractRecord as? NdefRecord,
           let abstractPayload = record.getPayload() {
            payload = abstractPayload
        } else if let recordType = abstractRecord.getRecordType(),
                  canEncodeRecord(recordType: recordType),
                  let encoder = payloadEncoder {
            payload = try encoder.encodePayload(abstractRecord: abstractRecord)
        } else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errInvalidPayloadType)
            throw NdefError(description: errInvalidPayloadType)
        }
        stream = assembleRecordBytes(header: header, stream: stream, ndefRecord: abstractRecord, payload: payload)
        NdefManager.getLogger()?.debug(header: headerTag, data: stream)
        NdefManager.getLogger()?.info(header: headerTag, message: "Payload encoded successfully.")
        return stream
    }

    /// Assembles the record bytes in the structure frame.
    ///
    /// - Parameters:
    ///   - header: Record header
    ///   - stream: Data stream in which the assembled byte is stored.
    ///   - ndefRecord:  NDEF record
    ///   - payload:  Encoded payload byte array of the record.
    ///
    /// - Returns: Assembled record bytes as data
    ///
    private func assembleRecordBytes(header: UInt8,
                                     stream: Data,
                                     ndefRecord: AbstractRecord,
                                     payload: Data) -> Data {
        var newStream = stream
        newStream = appendHeader(header: header, stream: newStream, ndefRecord: ndefRecord, payload: payload)
        newStream.append(UInt8(ndefRecord.getType().count))
        newStream = appendPayloadLength(stream: newStream, length: payload.count)
        newStream = appendIdLength(stream: newStream, length: ndefRecord.getId().count)
        newStream = appendData(stream: newStream, data: ndefRecord.getType())
        newStream = appendData(stream: newStream, data: ndefRecord.getId())
        newStream = appendData(stream: newStream, data: payload)
        return newStream
    }

    /// Appends the header of the record.
    /// '
    /// - Parameters:
    ///   - header: Record header
    ///   - stream: Data stream in which the assembled byte is stored.
    ///   - ndefRecord: NDEF record
    ///   - payload:  Encoded payload byte array of the record.
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func appendHeader(header: UInt8,
                              stream: Data,
                              ndefRecord: AbstractRecord,
                              payload: Data) -> Data {
        var newStream = stream
        var header: UInt8 = header
        header = setShortRecord(header: header, payload: payload)
        header = setIdLength(header: header, ndefRecord: ndefRecord)
        header = setTypeNameFormat(header: header, ndefRecord: ndefRecord)
        newStream.append(header)
        return newStream
    }

    /// Appends the input data to the stream.
    ///
    /// - Parameters:
    ///   - stream: Data  stream in which the appended byte is stored.
    ///   - data: Data to be appended.
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func appendData(stream: Data, data: Data) -> Data {
        var newStream = stream
        if !data.isEmpty {
            newStream.append(contentsOf: data)
        }
        return newStream
    }

    /// Sets short record flag, if it is short.
    ///
    /// - Parameters:
    ///   - header: Header of the record.
    ///   - payload: Encoded payload byte array of the record.
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func setShortRecord(header: UInt8, payload: Data) -> UInt8 {
        var updatedHeader = header
        if payload.count <= maxLengthForShortRecord {
            updatedHeader |= NdefConstants.srFlag
        }
        return updatedHeader
    }

    /// Sets record ID flag, if record has record ID.
    ///
    /// - Parameters:
    ///   - header: Header of the record.
    ///   - ndefRecord: NDEF record
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func setIdLength(header: UInt8, ndefRecord: AbstractRecord) -> UInt8 {
        var updatedHeader = header
        if !ndefRecord.getId().isEmpty {
            updatedHeader |= NdefConstants.ilFlag
        }
        return updatedHeader
    }

    /// Sets the record TNF bits.
    ///
    /// - Parameters:
    ///   - header: Header of the record.
    ///   - ndefRecord: NDEF record
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func setTypeNameFormat(header: UInt8,
                                   ndefRecord: AbstractRecord) -> UInt8 {
        var updatedHeader = header
        if let tnf = ndefRecord.getTnf() {
            updatedHeader |= tnf
        }
        return updatedHeader
    }

    /// Appends the record payload length to the data stream.
    ///
    /// - Parameters:
    ///   - stream: Data stream in which the appended byte is stored.
    ///   - length: Record payload length
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func appendPayloadLength(stream: Data,
                                     length: Int) -> Data {
        var newStream = stream
        if length <= maxLengthForShortRecord {
            newStream.append(UInt8(length))
        } else {
            let payloadLengthArray = Utils.toData(value: length, length: payloadLengthSize)
            newStream.append(contentsOf: payloadLengthArray)
        }
        return newStream
    }

    /// Appends the record ID length to the data stream.
    ///
    /// - Parameters:
    ///   - stream: Data stream to append the record ID.
    ///   - length: Record ID length
    ///
    /// - Returns: Returns the updated header of the record.
    ///
    private func appendIdLength(stream: Data,
                                length: Int) -> Data {
        var newStream = stream
        if length > 0 {
            newStream.append(UInt8(length))
        }
        return newStream
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
