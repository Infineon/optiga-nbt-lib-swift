// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Decodes the NDEF record.
public class RecordDecoder: IRecordDecoder {
    /// Payload length field length
    private let payloadLengthFieldLength = 4

    /// NDEF record payload decoder
    private var recordPayloadDecoder: IRecordPayloadDecoder?

    /// Private tag for the logger message header
    private let headerTag = "RecordDecoder"

    /// Checks if the library supports decoding the specified record type.
    ///
    /// - Parameter recordType: NDEF record type
    ///
    /// - Returns: Returns true, if record can be decoded by the library.
    ///
    public func canDecodeRecord(recordType: Data) -> Bool {
        recordPayloadDecoder = RecordUtils.getPayloadDecoder(
            recordType: RecordType(type: recordType))
        return recordPayloadDecoder != nil
    }

    /// Decodes the NDEF record.
    ///
    /// - Parameters:
    ///   - header: Header of the NDEF record.
    ///   - record: NDEF record
    ///   - index: Index to decode the data
    ///
    /// - Returns: Returns the decoded NDEF record.
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    public func decodeRecord(header: UInt8, record: Data, index: inout Int) throws -> AbstractRecord {
        NdefManager.getLogger()?.debug(header: headerTag, data: record)
        do {
            // Incrementing index as we already took header out
            index += 1
            // Decode the record header.
            let tnf: UInt8 = .init(header & NdefConstants.tnfMask)
            let typeLength = try Int(Utils.getUInt8WithIndex(index: index, data: record))
            index += 1
            let payloadLength = try getPayloadLength(isShortRecord: (header & NdefConstants.srFlag) != 0,
                                                     data: record,
                                                     index: &index)
            let idLength = try getIdLength(isIdLengthPresent: (header & NdefConstants.ilFlag) != 0,
                                           data: record,
                                           index: &index)
            let chuncked = (header & NdefConstants.cfFlag) != 0
            let type = try Utils.getDataFromStream(length: typeLength, data: record, index: &index)
            let id = try Utils.getDataFromStream(length: idLength, data: record, index: &index)
            let payload = try Utils.getDataFromStream(length: payloadLength, data: record, index: &index)

            // Check if library can decode the record.
            if canDecodeRecord(recordType: type) {
                let abstractRecord = try recordPayloadDecoder?.decodePayload(payload: payload)
                abstractRecord?.setId(id: id)
                abstractRecord?.setRecordType(recordType: RecordType(type: type))
                abstractRecord?.setIsChunked(isChunked: chuncked)
                abstractRecord?.setPayload(payload: payload)
                guard let record = abstractRecord else {
                    throw NdefError(description: RecordDecoderUtils.errMessageInvalidPayload)
                }
                NdefManager.getLogger()?.info(header: headerTag, message: "Payload decoded successfully.")
                return record
            } else {
                // Creates an NDEF record if library is not supporting for decoding the
                // record.
                NdefManager.getLogger()?.info(header: headerTag, message: "Payload decoded successfully.")
                return NdefRecord(tnf: tnf, isChuncked: chuncked, type: type, id: id, payload: payload)
            }
        } catch {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: RecordDecoderUtils.errMessageInvalidPayload)
            throw NdefError(description: RecordDecoderUtils.errMessageInvalidPayload)
        }
    }

    /// Gets the length of the record ID filed.
    ///
    /// - Parameters:
    ///   - isIdLengthPresent: True if ID is present in the record bytes.
    ///   - data: From the ID length need to be read.
    ///   - index: Index to decode the data
    ///
    /// - Returns: Returns the length of the record ID filed.
    ///
    /// - Throws: ``NdefError`` if unable to read the bytes from the data.
    ///
    private func getIdLength(isIdLengthPresent: Bool, data: Data, index: inout Int) throws -> Int {
        if isIdLengthPresent {
            let idLength = try Utils.getUInt8WithIndex(index: index, data: data)
            index += 1
            return Int(idLength)
        }
        NdefManager.getLogger()?.warning(header: headerTag,
                                      message: "IdLength is not present")
        return 0
    }

    /// Gets the length of the record payload.
    ///
    /// - Parameters:
    ///   - isShortRecord: True if it is short record.
    ///   - data: From the record payload, length need to be read.
    ///   - index: Index to decode the data
    ///
    /// - Returns: Returns the record payload length.
    ///
    /// - Throws: ``NdefError`` if unable to read the bytes from the data.
    ///
    private func getPayloadLength(isShortRecord: Bool, data: Data, index: inout Int) throws -> Int {
        if isShortRecord {
            let payloadLength = try Utils.getUInt8WithIndex(index: index, data: data)
            index += 1
            return Int(payloadLength)
        }
        let buffer = try Utils.getDataFromStream(length: payloadLengthFieldLength, data: data, index: &index)
        return ((Int(buffer[0]) & 0xff) << 24) | ((Int(buffer[1]) & 0xff) << 16) |
            ((Int(buffer[2]) & 0xff) << 8) | (Int(buffer[3]) & 0xff)
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
