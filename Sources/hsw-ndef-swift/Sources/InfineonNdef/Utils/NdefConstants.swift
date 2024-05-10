// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Consists of all the constants required for NFC NDEF
public class NdefConstants {
    /// The MB flag is a 1-bit field that when set indicates the start of an NDEF
    /// message
    public static let mbFlag: UInt8 = 0x80

    /// The ME flag is a 1-bit field that when set indicates the end of an NDEF
    /// message . Note, that in case of a chunked payload, the ME flag is set
    /// only in the terminating record chunk of that chunked payload.
    public static let meFlag: UInt8 = 0x40

    /// The CF flag is a 1-bit field indicating that this is either the first
    /// record chunk or a middle record chunk of a chunked payload .
    public static let cfFlag: UInt8 = 0x20

    /// The SR flag is a 1-bit field indicating, if set, that the PAYLOAD_LENGTH
    /// field is a single octet. This short record layout is intended for compact
    /// encapsulation of small payloads which will fit within PAYLOAD fields of
    /// size ranging between 0 to 255 octets.
    public static let srFlag: UInt8 = 0x10

    /// The IL flag is a 1-bit field indicating, if set, that the ID_LENGTH field
    /// is present in the header as a single octet. If the IL flag is zero, the
    /// ID_LENGTH field is omitted from the record header and the ID field is
    /// also omitted from the record.
    public static let ilFlag: UInt8 = 0x08

    /// Type Name Format Mask. The TNF field value indicates the structure of the
    /// value of the TYPE field.
    public static let tnfMask: UInt8 = 0x07

    /// Specifies the empty byte array
    public static let emptyByteArray: Data = .init()

    /// Specifies the empty NDEF Message byte[] array
    public static let emptyNdefMessage = Data([0xd0, 0x00, 0x00])

    /// An empty Type Name Format byte data
    public static let tnfEmpty: UInt8 = 0x00

    /// An unchanged Type Name Format byte data
    public static let tnfUnchanged: UInt8 = 0x06

    /// NFC Forum well-known type [NFC RTD] 0x01
    public static let tnfWellKnownType: UInt8 = 0x01

    /// NFC Forum External type [NFC RTD] 0x04
    public static let tnfExternalType: UInt8 = 0x04

    /// Media-type RFC 2046 - 0x02
    public static let tnfMediaType: UInt8 = 0x02

    /// Well known UTF type of "UTF-8" charset for record creation
    public static let utf8Charset = CharacterSet(charactersIn: "UTF-8")

    /// Well known default "US-ASCII" charset for record creation
    public static let defaultCharset = String.Encoding.ascii

    /// Limit of NDEF message length
    public static let ndefMessageLengthLimit = 0x02
}
