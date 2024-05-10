// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// NDEF Messages are the basic "transportation" mechanism for
/// NDEF records, with each message containing one or more NDEF Records.
/// This class represents an NFC NDEF records which is a collection of
/// NDEF records and also provides methods to encode and decode NDEF Message.
/// An NDEF Message is a container for one or more NDEF Records.
public final class NdefMessage {
    /// Collection of the NDEF records.
    private var ndefRecords = [AbstractRecord]()

    /// Private instance of NDEF message decoder to decode the NDEF message.
    private let decoder = NdefMessageDecoder.instance()

    /// Private instance of NDEF message decoder to decode the NDEF message.
    private let encoder = NdefMessageEncoder.instance()

    /// Creates a new NDEF message with the list of NDEF records
    ///
    /// - Parameter ndefRecords: List of NDEF records
    ///
    public init(ndefRecords: [AbstractRecord]) {
        self.ndefRecords = ndefRecords
    }

    /// Creates a new NDEF Message with **NDEFRecords** using the raw byte array data.
    ///
    /// - Parameter ndefMessage: List of NDEF records in byte array
    ///
    /// - Throws: Throws an ``NdefError``  if unable to decode NDEF message.
    ///
    public init(ndefMessage: Data) throws {
        ndefRecords = try decoder.decodeToRecords(stream: ndefMessage)
    }

    /// Sets the  a new  list of NDEF records
    ///
    /// - Parameter ndefRecords: Adds the NDEF records to record list
    ///
    public func addNdefRecords(ndefRecords: [AbstractRecord]) {
        self.ndefRecords.append(contentsOf: ndefRecords)
    }

    /// Adds the NDEF record to the NDEF message.
    ///
    /// - Parameter ndefRecord: Adds the NDEF record to record list
    ///
    public func addNdefRecord(ndefRecord: AbstractRecord) {
        ndefRecords.append(ndefRecord)
    }

    /// Returns the collection of NDEF records available in NDEF Message
    ///
    /// - Returns: the collection of NDEF records list
    ///
    public func getNdefRecords() -> [AbstractRecord] {
        return ndefRecords
    }

    /// Encodes the NDEF Records and returns the raw byte array data
    ///
    /// - Returns: NDEF record byte array data
    ///
    /// - Throws: Throws an ``NdefError`` if unable to encode NDEF message bytes.
    ///
    public func toByteArray() throws -> Data {
        return try encoder.encode(ndefRecords: ndefRecords)
    }

    /// Encodes the NDEF records and returns data with NDEF
    /// message length prepended with the NDEF message.
    ///
    /// - Parameter includeLength: Indicates whether the NLEN
    /// field should be prefixed in the NDEF message.
    ///
    /// - Returns: Returns the NDEF Record byte array data.
    ///
    /// - Throws: Throws an ``NdefError`` if unable to encode NDEF message bytes.
    ///
    public func toByteArray(includeLength: Bool) throws -> Data {
        let ndefMessage = try toByteArray()
        var tempMessage = Data()
        if includeLength {
            let ndefMessageLength =
                Utils.toData(value: ndefMessage.count,
                             length: NdefConstants.ndefMessageLengthLimit)
            tempMessage.append(ndefMessageLength)
        }
        tempMessage.append(ndefMessage)

        return tempMessage
    }
}
