// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Container class for TLV structures. This class allows to
/// build simple and constructed TLV structures. A name can
/// be assigned to the TLV structure.
public class Tlv {
    /// Arbitrary name of TLV structure
    public var name: String?

    /// Tag of TLV object
    public var tag: Int

    /// Flag to indicate the length of the value can be up to '80' (128)
    public var allowLength80: Bool = false

    /// Flag to represent TLV objects whose length is not known in advance (indefinite or 128)
    private var indefLength: Bool = false

    /// Structured value of TLV object
    public var value: [Any] = []

    /// Constructor of TLV object.
    ///
    /// - Parameters:
    ///   - tag: Tag of TLV object or zero if the object is an LV structure.
    ///   - name: Arbitrary name of TLV structure. This parameter may be nil.
    ///   - value: Initial value of TLV object. This parameter may be nil for an empty object.
    ///
    /// - Throws: ``UtilsError`` if there is a utility related error
    ///
    public init(tag: Int, name: String?, value: Any?) throws {
        self.tag = tag
        self.name = name
        if let val = value {
            _ = try addValue(value: val)
        }
    }

    /// Add a value to the value part of the TLV structure. The value is appended to
    /// the current value of the TLV object.
    ///
    /// - Parameter value: Value to be added to the TLV object.
    ///
    /// - Returns: Reference to 'this' to allow simple concatenation of operations.
    ///
    /// - Throws: ``UtilsError`` if value parameter cannot be converted to a byte array.
    ///
    public func addValue(value: Any) throws -> Tlv {
        // check value format
        if let tlv = value as? Tlv {
            try self.value.append(tlv.toData())
        } else if let byteArray = value as? Data {
            // Handle byte array
            self.value.append(byteArray)
        }
        return self
    }

    /// Get a list of all values that will be concatenated to the value part of
    /// the TLV object.
    ///
    /// - Returns: Array of objects forming the value part of the TLV structure.
    ///
    public func getValues() -> Data {
        var values = Data()
        for tagTlv in self.value {
            if let tlv = tagTlv as? Tlv {
                values.append(contentsOf: tlv.getValues())
            } else if let byteArray = tagTlv as? Data {
                values.append(byteArray)
            }
        }
        return values
    }

    /// Gets the tag of TLV object
    ///
    /// - Returns: Tag of TLV object
    ///
    public func getTag() -> Int {
        return tag
    }

    /// Return byte array representation of TLV or LV structure including (tag and) length.
    ///
    /// - Returns: Byte array representation of TLV or LV structure.
    ///
    /// - Throws: ``UtilsError`` if value cannot be converted into a byte array.
    ///
    public func toData() throws -> Data {
        return try Tlv.buildTlv(tag: tag,
                                value: value,
                                allowLength80: allowLength80)
    }

    /// Build a TLV or LV structure from a given value.
    ///
    /// - Parameters:
    ///   - tag: Tag for structure or zero if LV structure shall be built.
    ///   - value: Value to be wrapped in TLV or LV structure.
    ///   - allowLength80: allowLength80 code length of 128 (0x80)
    ///   bytes as simple length '80' instead of '8180'.
    ///
    /// - Returns: Byte array containing TLV structure.
    ///
    /// - Throws: ``UtilsError`` if value cannot be converted into a byte array.
    ///
    public static func buildTlv(tag: Int,
                                value: [Any],
                                allowLength80: Bool) throws -> Data {
        let abValue = try Utils.toData(stream: value)
        var abTlv = Data()
        // build byte array of tag
        let abTag = encodeTag(tag: tag)
        // build byte array of length
        let abLength = encodeLength(length: abValue.count,
                                    allowLength80: allowLength80)

        // build TLV structure
        abTlv.append(abTag)
        abTlv.append(abLength)
        abTlv.append(abValue)
        return abTlv
    }

    /// Build BER encoded length.
    ///
    /// - Parameters:
    ///   - length: Length to be encoded.
    ///   - allowLength80: Code length of 128 bytes as simple
    ///   length '80' instead of '8180'.
    ///
    /// - Returns: Byte array containing length information.
    ///
    public static func encodeLength(length: Int, allowLength80: Bool) -> Data {
        var abLength: Data
        if ((length & 0x7F) == length) || ((length == 0x80) && allowLength80) {
            // simple one byte length
            abLength = Utils.toData(value: length, length: 1)
        } else if (length & 0xFF) == length {
            // extended one byte length
            abLength = Utils.toData(value: length, length: 2)
            abLength[0] = 0x81
        } else if (length & 0xFFFF) == length {
            // two byte length
            abLength = Utils.toData(value: length, length: 3)
            abLength[0] = 0x82
        } else if (length & 0xFFFFFF) == length {
            // three byte length
            abLength = Utils.toData(value: length, length: 4)
            abLength[0] = 0x83
        } else {
            // four byte length
            abLength = Utils.toData(value: length, length: 5)
            abLength[0] = 0x84
        }
        return abLength
    }

    /// Build BER encoded tag.
    ///
    /// - Parameter tag: Tag for structure or zero if LV structure shall be built.
    ///
    /// - Returns: Byte array containing tag information.
    ///
    public static func encodeTag(tag: Int) -> Data {
        var abTag: Data
        if tag == 0 {
            abTag = Data()
        } else if (tag & 0xFF) == tag {
            abTag = Utils.toData(value: tag, length: 1)
        } else if (tag & 0xFFFF) == tag {
            abTag = Utils.toData(value: tag, length: 2)
        } else if (tag & 0xFFFFFF) == tag {
            abTag = Utils.toData(value: tag, length: 3)
        } else {
            abTag = Utils.toData(value: tag, length: 4)
        }
        return abTag
    }

    /// Build a DGI TLV from a given value.
    ///
    /// - Parameters:
    ///   - tag: Tag for structure.
    ///   - data: Value to be wrapped in TLV.
    ///
    /// - Returns: Array containing TLV structure.
    ///
    /// - Throws: ``UtilsError`` if value cannot be converted into a byte array.
    ///
    public static func buildDgiTlv(tag: UInt16, data: Any) throws -> Data {
        let valueBytes: Data = try Utils.toData(stream: data)
        var tagBytes: Data
        var lengthBytes: Data

        // build byte array of tag
        tagBytes = encodeDGITag(tag: tag)

        // build byte array of length
        lengthBytes = encodeDGILength(length: valueBytes.count)

        var abTlv = Data(count: tagBytes.count + lengthBytes.count + valueBytes.count)

        // build TLV structure
        _ = Utils.dataCopy(src: tagBytes, srcOffset: 0,
                           dest: &abTlv, destOffset: 0,
                           length: tagBytes.count)

        _ = Utils.dataCopy(src: lengthBytes, srcOffset: 0,
                           dest: &abTlv, destOffset: tagBytes.count,
                           length: lengthBytes.count)

        _ = Utils.dataCopy(src: valueBytes,
                           srcOffset: 0,
                           dest: &abTlv,
                           destOffset: tagBytes.count + lengthBytes.count,
                           length: valueBytes.count)

        return abTlv
    }

    /// Build Dgi encoded tag.
    ///
    /// - Parameter tag: Tag for structure.
    ///
    /// - Returns: Data byte array containing tag information.
    ///
    public static func encodeDGITag(tag: UInt16) -> Data {
        var tagBytes: Data
        tagBytes = Utils.toData(value: Int(tag), length: 2)
        return tagBytes
    }

    /// Build encoded Dgi length.
    ///
    /// - Parameter length: Length Length to be encoded.
    ///
    /// - Returns: Byte array containing length information.
    ///
    public static func encodeDGILength(length: Int) -> Data {
        if (length & 0xFF) == length {
            return Utils.toData(value: length, length: 1)
        } else {
            var lengthBytes: Data = .init(count: 3)
            lengthBytes[0] = 0xFF
            _ = Utils.dataCopy(src: Utils.toData(value: length,
                                                 length: 2),
                               srcOffset: 0,
                               dest: &lengthBytes,
                               destOffset: 1,
                               length: 2)
            return lengthBytes
        }
    }
}
