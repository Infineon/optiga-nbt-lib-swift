// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Decodes the NDEF (NFC Data Exchange Format) message. Returns a decoder
/// function that decodes an NDEF record from a file-like, byte-oriented stream
/// or a bytes object given by the stream_or_bytes argument.
public final class NdefMessageDecoder {
    /// Private instance of an NDEF message decoder to decode the NDEF message.
    private static let decoder = NdefMessageDecoder()

    /// Private instance of ``RecordDecoder`` to decode the NDEF record.
    private let recordDecoder = RecordDecoder()

    /// Private tag for the logger message header
    private let headerTag = "NdefMessageDecoder"

    /// Error if message begin record in the NDEF message is not present.
    private let errMissingMbRecord =
        "Missing Message Begin record in the NDEF Message"

    /// Error if message end record in the NDEF message is not present.
    private let errMissingMeRecord =
        "Missing message end record in the NDEF message"

    /// Private constructor to restrict object creation.
    private init() {
            // Private constructor to restrict object creation.
    }

    /// Returns the instance of NDEF message decoder.
    ///
    /// - Returns: Returns the singleton instance of ``NdefMessageDecoder``.
    ///
    public static func instance() -> NdefMessageDecoder {
        return decoder
    }

    /// Decodes the NDEF message bytes with the specified offset and the NDEF message length.
    ///
    /// - Parameters:
    ///   - ndefMessage: NDEF message as bytes.
    ///   - offset:  Start offset from which the data to be decoded.
    ///   - length:  Length of data to be decoded.
    ///
    /// - Returns: Returns the decoded ``NdefMessage``.
    ///
    /// - Throws: Throws an ``NdefError`` if unable to
    /// decode the NDEF message bytes.
    ///
    public func decode(ndefMessage: Data, offset: Int,
                       length: Int) throws -> NdefMessage {
        return try decode(stream: Utils.getSubData(offset: offset, data: ndefMessage, length: length))
    }

    /// Decodes the stream of input data of NDEF message
    /// and return the decoded NDEF Message
    ///
    /// - Parameter stream: Stream of data
    ///
    /// - Returns: Returns the decoded ``NdefMessage``.
    ///
    /// - Throws: Throws an ``NdefError`` if unable to
    /// decode the NDEF message bytes.
    ///
    public func decode(stream: Data) throws -> NdefMessage {
        NdefManager.getLogger()?.debug(header: headerTag, data: stream)
        do {
            var records = [AbstractRecord]()
            var index = 0
            while index < stream.count {
                let header = try Utils.getUInt8WithIndex(index: index, data: stream)
                let abstractRecord = try recordDecoder.decodeRecord(header: header, record: stream, index: &index)
                if records.isEmpty && (header & NdefConstants.mbFlag) == 0 {
                    NdefManager.getLogger()?.error(header: headerTag,
                                                  message: errMissingMbRecord)
                    throw NdefError(description: errMissingMbRecord)
                }

                if (index == stream.count) && (header & NdefConstants.meFlag) == 0 {
                    NdefManager.getLogger()?.error(header: headerTag,
                                                  message: errMissingMeRecord)
                    throw NdefError(description: errMissingMeRecord)
                }
                records.append(abstractRecord)
            }
            NdefManager.getLogger()?.info(header: headerTag, message: "Payload decoded successfully.")
            return NdefMessage(ndefRecords: records)
        } catch {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: RecordDecoderUtils.errMessageInvalidPayload)
            throw NdefError(description: RecordDecoderUtils.errMessageInvalidPayload)
        }
    }

    /// Decodes the NDEF message input stream and returns the list of NDEF records.
    ///
    /// - Parameter stream: Stream of data
    ///
    /// - Returns: Returns the collection of NDEF records that is decoded.
    ///
    /// - Throws: Throws an NDEF error if unable to
    /// decode stream of input data of NDEF message.
    ///
    public func decodeToRecords(stream: Data) throws -> [AbstractRecord] {
        return try decode(stream: stream).getNdefRecords()
    }
}
