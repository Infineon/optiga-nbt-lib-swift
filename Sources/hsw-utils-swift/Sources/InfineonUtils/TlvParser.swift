// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Helper class for parsing TLV structures.
public class TlvParser {

    /// Extended options and flags TLV structure
    static let eof = "EOF"

    /// Boolean TLV structure
    static let boolean = "BOOLEAN"

    /// Integer TLV structure
    static let integer = "INTEGER"

    /// Sequence TLV structure
    static let sequence = "SEQUENCE"

    /// Set TLV structure
    static let setString = "SET"

    /// Null TLV structure
    static let null = "NULL"

    /// Bit string TLV structure
    static let bitString = "BIT STRING"
    
    /// Octet string TLV structure
    static let octetString = "OCTET STRING"

    /// Reference to input byte array
    private var structure: Data

    /// Current parser offset in input byte array
    private var offset: Int = 0

    /// Constructor of new TLV parser object.
    ///
    /// - Parameter structure: Reference of input byte array
    /// containing a TLV or LV  structure.
    ///
    public init(structure: Data) {
        self.structure = structure
    }

    /// Check the parsed length against the bounds of the complete structure.
    ///
    /// - Parameter length: Parsed length.
    ///
    /// - Throws: ``UtilsError`` if length is larger than remaining data in input structure.
    ///
    private func checkLength(length: Int) throws {
        if offset + length > structure.count {
            throw UtilsError(description: "Invalid Tlv structure")
        }
    }

    /// Check if parsing has finished and no more data is left for parsing.
    ///
    /// - Returns: True if parser has reached the end of data.
    ///
    public func isFinished() -> Bool {
        return offset >= structure.count
    }

    /// Read tag from the structure.
    ///
    /// - Returns: Parsed tag.
    ///
    /// - Throws: ``UtilsError`` if tag format is invalid.
    ///
    public func parseTag() throws -> Int {
        try checkLength(length: 1)
        var tag = Int(structure[offset] & 0xFF)
        offset += 1
        // check if two byte tag
        if (tag & 0x1F) == 0x1F {
            try checkLength(length: 1)
            tag = (tag << 8) | (Int(structure[offset]) & 0xFF)
            offset += 1
            // check if three byte tag
            if (tag & 0x80) != 0 {
                try checkLength(length: 1)
                tag = (tag << 8) | (Int(structure[offset]) & 0xFF)
                offset += 1
            }
        }

        return tag
    }

    /// Read length from the structure.
    ///
    /// - Returns: Parsed length of value.
    ///
    /// - Throws: ``UtilsError`` if the length structure is invalid.
    ///
    public func parseLength() throws -> Int {
        try checkLength(length: 1)
        var length = Int(structure[offset])
        offset += 1

        switch UInt8(length) {
        case 0x81:
            try checkLength(length: 1)
            length = Int(structure[offset] & 0xFF)
            offset += 1

        case 0x82:
            try checkLength(length: 2)
            length = Int(structure[offset] & 0xFF) << 8
            offset += 1
            length |= Int(structure[offset] & 0xFF)
            offset += 1

        case 0x83:
            try checkLength(length: 3)
            length = Int(structure[offset] & 0xFF) << 16
            offset += 1
            length |= Int(structure[offset] & 0xFF) << 8
            offset += 1
            length |= Int(structure[offset] & 0xFF)
            offset += 1

        case 0x84:
            try checkLength(length: 4)
            length = Int(structure[offset] & 0xFF) << 24
            offset += 1
            length |= Int(structure[offset] & 0xFF) << 16
            offset += 1
            length |= Int(structure[offset] & 0xFF) << 8
            offset += 1
            length |= Int(structure[offset] & 0xFF)
            offset += 1

        default:
            length &= 0xFF
        }

        return length
    }

    /// Parse the value in the given length and extract it as byte array.
    ///
    /// - Parameter length: Length of value to parse.
    ///
    /// - Returns: Byte array containing value part.
    ///
    /// - Throws: ``UtilsError`` if more data shall be parsed as
    /// available in the structure.
    ///
    public func parseValue(length: Int) throws -> Data {
        
        try checkLength(length: length)
        offset += length
        let range = (offset - length)..<offset
        return Data(structure[range])
    }

    /// Parse a complete TLV structure.
    ///
    /// - Returns: vector containing all TLV structures contained in the input data.
    ///
    /// - Throws: ``UtilsError`` if parsing fails for any reason.
    ///
    public func parseTlvStructure() throws -> [Any] {
        var values: [Any] = []

        while !isFinished() {
            let tag = try parseTag()
            let len = try parseLength()

            let value = try parseValue(length: len)
            try values.append(Tlv(tag: tag, name: TlvParser.getType(tag: tag), value: value))
        }

        return values
    }

    /// Returns the type of TLV structure
    ///
    /// - Parameter tag: The tag value to match
    ///
    /// - Returns: String  type of structure
    ///
    private static func getType(tag: Int) -> String? {
        switch tag {
        case 0x00:
            return eof
        case 0x01:
            return boolean
        case 0x02:
            return integer
        case 0x03:
            return bitString
        case 0x04:
            return octetString
        case 0x05:
            return null
        case 0x30:
            return sequence
        case 0x31:
            return setString
        default: do {
                return nil
            }
        }
    }

    /// Parse a complete DGI TLV structure, which is similar to a
    /// simple tlv format but with 2 bytes TAG.
    ///
    /// - Returns: Array containing all TLV structures contained in the input data.
    ///
    /// - Throws: ``UtilsError`` if parsing fails for any reason.
    ///
    public func parseDgiTlvStructure() throws -> [Any] {
        var values = [Any]()

        while !isFinished() {
            let tag = try parseDgiTag()
            let len = try parseDgiLength()

            let value = try parseDgiValue(length: len)
            try values.append(Tlv(tag: tag, name: TlvParser.getType(tag: tag), value: value))
        }

        return values
    }

    /// Read tag from the structure. DGI formatted data is similar to a
    /// simple tlv format but with 2 bytes TAG.
    ///
    /// - Returns: Parsed DGI tag.
    ///
    /// - Throws: ``UtilsError`` if tag format is invalid.
    ///
    public func parseDgiTag() throws -> Int {
        try checkLength(length: 2)
        var tag = Int(structure[offset])
        offset += 1
        tag = (tag << 8) | Int(structure[offset])
        offset += 1
        return tag
    }

    /// Read Dgi length from the structure.
    ///
    /// - Returns: Parsed length of value.
    ///
    /// - Throws: ``UtilsError`` if the length structure is invalid.
    ///
    public func parseDgiLength() throws -> Int {
        try checkLength(length: 1)
        var length = Int(structure[offset])
        offset += 1
        if (length & 0xFF) == 0xFF {
            try checkLength(length: 2)
            length = Int(structure[offset])
            offset += 1
            length <<= 8
            length |= Int(structure[offset]) & 0xFF
            offset += 1
        }
        return length
    }

    /// Parse the Dgi value in the given length and extract it as byte array.
    ///
    /// - Parameter length: Length length of value to parse.
    ///
    /// - Returns: Byte array containing value part.
    ///
    /// - Throws: ``UtilsError`` if more data shall be
    ///  parsed as available in the structure.
    ///
    public func parseDgiValue(length: Int) throws -> Data {
        if length == 0 {
            return Data()
        }
        try checkLength(length: length)
        offset += length
        return structure[offset - length..<offset]
    }
}
