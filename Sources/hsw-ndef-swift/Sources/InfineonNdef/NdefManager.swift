// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils
import InfineonLogger

/// This is the Factory class that provides methods for creation, encode, decode of NDEF records.
public final class NdefManager {
    /// Private instance of the record encoder to encode the NDEF record.
    private static let recordEncoder = RecordEncoder()

    /// Private instance of the record decoder to decode the NDEF record.
    private static let recordDecoder = RecordDecoder()

    /// Private instance of the logger for logging different levels of messages.
    private static var logger:ILogger? = nil

    /// Creates an NDEF message along with ``NdefRecord`` using the raw byte array data.
    ///
    /// **Note:** NLEN should not be present in the input NDEF message.
    ///
    /// - Parameter data: Raw byte array data.
    ///
    /// - Returns: Returns the ``NdefMessage`` NDEF
    /// message along with ``NdefRecord``
    ///
    /// - Throws: Throws an ``NdefError``
    /// if unable to decode NDEF message data.
    ///
    public static func decode(data: Data) throws -> NdefMessage {
        return try NdefMessage(ndefMessage: data)
    }

    /// Encodes an NDEF message with the collection of NDEF records.
    ///
    /// - Parameter message: ``NdefMessage`` NDEF message
    /// along with ``NdefRecord``
    ///
    /// - Returns: Returns the ``NdefMessage`` NDEF message
    /// along with ``NdefRecord`` as data
    ///
    /// - Throws: Throws an ``NdefError``
    /// if unable to encode the NDEF message bytes.
    ///
    public static func encode(message: NdefMessage) throws -> Data {
        return try message.toByteArray(includeLength: false)
    }

    /// Encodes an NDEF message with the collection of NDEF records and includes
    /// the NLEN field as prefix.
    ///
    /// - Parameters:
    ///   - message: ``NdefMessage`` NDEF message along with ``NdefRecord``
    ///   - includeLength: Indicates whether the NLEN field should be prefixed
    ///   in the NDEF message.
    ///
    /// - Returns: Returns the ``NdefMessage`` NDEF message
    /// along with ``NdefRecord`` as data
    ///
    /// - Throws: Throws an ``NdefError``
    /// if unable to encode the NDEF message bytes.
    ///
    public static func encode(message: NdefMessage, includeLength: Bool) throws -> Data {
        return try message.toByteArray(includeLength: includeLength)
    }

    /// Decodes the encoded record. Known record types are decoded into
    /// instances of their implementation class and can be directly encoded as part
    /// of a message.
    ///
    /// - Parameter ndefRecord: Encoded form of NDEF record ``NdefRecord``.
    ///
    /// - Returns: Returns the ``AbstractRecord`` decoded form of NDEF record.
    ///
    /// - Throws: Throws ``NdefError``  if unable to decode the record.
    ///
    public static func decodeRecord(ndefRecord:
        Data) throws -> AbstractRecord {
        var index = 0
        let header = try Utils.getUInt8WithIndex(index: index, data: ndefRecord)
        return try recordDecoder.decodeRecord(header: header,
                                              record: ndefRecord,
                                              index: &index)
    }

    /// Encodes the record. Known record types are encoded.
    ///
    /// - Parameter abstractRecord: Decoded form of NDEF record ``AbstractRecord``
    ///
    /// - Returns: Returns the  encoded form of ``NdefRecord``.
    ///
    /// - Throws: Throws an ``NdefError`` if unable to encode the record.
    ///
    public static func encodeRecord(abstractRecord:
        AbstractRecord) throws -> Data {
        return try recordEncoder.encodeRecord(header: 0,
                                              abstractRecord: abstractRecord)
    }

    /// Gets the payload encoder from the class. Gets the
    /// encoder from the ``RecordUtils`` and returns it.
    ///
    /// - Parameter recordType: Type of record as ``RecordType``
    ///
    /// - Returns: Returns the record payload encoder.
    ///
    public static func getPayloadEncoder(recordType:
        RecordType) -> IRecordPayloadEncoder? {
        return RecordUtils.getPayloadEncoder(recordType: recordType)
    }

    /// Gets the payload decoder. Gets the decoder from
    /// the ``RecordUtils`` and returns it.
    ///
    /// - Parameter recordType: Type of record ``RecordType``
    ///
    /// - Returns: Returns the record payload decoder.
    ///
    public static func getPayloadDecoder(recordType:
        RecordType) -> IRecordPayloadDecoder? {
        return RecordUtils.getPayloadDecoder(recordType: recordType)
    }
    
    /// Sets the instance of logger
    ///
    /// - Parameter logger: Logger to log different levels of messages
    /// 
    public static func setLogger(logger:ILogger){
        self.logger = logger
    }

    /// Gets the instance of logger
    ///
    /// - Returns: Logger to log different levels of messages
    ///
    public static func getLogger() -> ILogger? {
        return logger
    }
}
