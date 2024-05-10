// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Utility class for string related manipulations.
public enum Utils {
    /// Default delimiter
    private static let space: String = " "
    
    /// Error message illegal character in hex
    private static let errIllegalCharacter = "Illegal character in hex string"

    /// Transforms a fraction of a byte array into an ASCII string.
    ///
    /// - Parameters:
    ///   - data: Array containing ASCII string
    ///   - offset: Offset of string in byte array
    ///   - length: Length of ASCII string
    ///
    /// - Returns: ASCII string representation of byte array fraction
    ///
    /// - Throws: ``UtilsError`` if offset or length is invalid
    ///
    public static func toString(data: Data, offset: Int, length: Int) throws -> String {
        var description = ""

        if offset + length > data.count
        {
            throw UtilsError(description: "Offset + Length is greater than total count")
        }

        for index in 0..<length {
            let byte = data[offset + index]
            if byte >= 32 && byte < 128 {
                description += String(format: "%c", byte)
            } else {
                description += "."
            }
        }
        return description
    }

    /// Extracts data bytes from a source array at specified offset and length
    ///
    /// - Parameters:
    ///   - data: Source array
    ///   - offset: Offset at which the data to be extracted
    ///   - length: Length of data to be extracted
    ///
    /// - Returns: Extracted data bytes
    ///
    public static func extractData(data: Data,
                                   offset: Int,
                                   length: Int) -> Data {
        let subData: Data = data.subdata(in: offset..<offset + length)
        return subData
    }

    /// Convert the content of a byte array into a hex string with space between each byte.
    ///
    /// - Parameter stream: Byte array to be converted.
    ///
    /// - Returns: Hex string representation of byte array.
    ///
    public static func toHexString(stream: Data) -> String {
        return toHexString(value: stream, offset: 0, length: stream.count,
                           delimiter: space)
    }

    /// Convert a byte array into a hex string. The formatting of the
    /// string may be influenced by a delimiter string which is inserted
    /// before each byte. For the first byte, all delimiter characters
    /// before ',', '.', ':', ';' or ' ' are skipped.
    ///
    /// - Parameters:
    ///   - value: Byte array to be converted.
    ///   - offset: Offset of data within byte array
    ///   - length: Length of data to be converted
    ///   - delimiter: Delimiter string like ", " or " ", ", 0x", ":", ", (byte)0x"
    ///
    /// - Returns: Resulting hex string
    ///
    public static func toHexString(value: Data,
                                   offset: Int,
                                   length: Int,
                                   delimiter: String) -> String {

        var strValue = ""

        for index in stride(from: delimiter.count, to: 0, by: -1) where
            isDedicatedDelimiter(character: delimiter[delimiter.index(
                delimiter.startIndex, offsetBy: index - 1)]) {
            break
        }

        for index in 0..<length {
            strValue += String(format: "%02X", value[offset + index])

            if index < (length - 1) {
                strValue += delimiter
            }
        }

        return strValue
    }

    /// Converts a variety of objects into a
    /// byte array.
    ///
    /// The supported reference types are:
    /// - Null is converted into an empty byte array
    /// - Data is returned unaltered
    /// - Integer is returned as byte array of 4 bytes with MSB first
    /// - Short is returned as byte array of 2 bytes with MSB first
    /// - Byte is returned as byte array of 1 byte
    /// - Hex string is converted into its byte array representation
    /// - For any other object the an empty byte array will be return
    ///
    /// Hex strings are accepted in various input formats e.g. "ABCDEF",
    /// "AB cd EF", "0xab:0xc:0xde", "ab, C, DE". ASCII strings may
    /// be included if surrounded by hyphens, e.g 'My String'.
    ///
    /// - Parameter stream: Object to be converted into a byte array.
    ///
    /// - Returns: Byte array representation of stream object.
    ///
    /// - Throws: ``UtilsError`` if conversion into a byte array fails.
    ///
    public static func toData(stream: Any?) throws -> Data {
        // check if null reference
        if stream == nil {
            return Data()
        }

        // check if already byte array
        if let data = stream as? Data {
            return data
        }
        
        if let data = stream as? [Data] {
            var streamData: Data  = Data()
            for i in data {
                streamData.append(i)
            }
            return streamData
        }
        
        // check if TLV object
        if let tlv = stream as? Tlv {
            return try tlv.toData()
        }

        // check if integer value
        if let value = stream as? Int {
            return toData(value: value, length: 4)
        }
        // check if 64- bit integer value
        if let value = stream as? Int64 {
            return toData(value: Int(value), length: 8)
        }
        // check if 32- bit integer value
        if let value = stream as? Int32 {
            return toData(value: Int(value), length: 4)
        }
        // check if 16- bit integer value
        if let value = stream as? Int16 {
            return toData(value: Int(value), length: 2)
        }
        // check if 8- bit integer value
        if let value = stream as? Int8 {
            return toData(value: Int(value), length: 1)
        }

        // check if integer value
        if let value = stream as? UInt {
            return toData(value: Int(value), length: 4)
        }
        // check if 64- bit integer value
        if let value = stream as? UInt64 {
            return toData(value: Int(value), length: 8)
        }
        // check if 32- bit integer value
        if let value = stream as? UInt32 {
            return toData(value: Int(value), length: 4)
        }
        // check if 16- bit integer value
        if let value = stream as? UInt16 {
            return toData(value: Int(value), length: 2)
        }
        // check if 8- bit integer value
        if let value = stream as? UInt8 {
            return toData(value: Int(value), length: 1)
        }

        // check if Double value
        if let value = stream as? Double {
            return toData(value: Int(value), length: 8)
        }

        // check if float value
        if let value = stream as? Float {
            return toData(value: Int(value), length: 4)
        }

        // check if String value
        if let string = stream as? String {
            return try toByteArray(data: string)
        }
        if let bytes = stream as? [UInt8] {
            return Data(bytes)
        }

        return Data()
    }

    /// Helper function to convert a primitive value into a byte array.
    ///
    /// - Parameters:
    ///   - value: Integer value to be converted.
    ///   - length: Length of resulting array.
    ///
    /// - Returns: Byte array representation of integer value (MSB first).
    ///
    public static func toData(value: Int, length: Int) -> Data {
        var abValue = Data(count: length)
        var val = value
        var len = length
        while len > 0 {
            len -= 1
            abValue[len] = UInt8(val & 0xFF)
            val >>= 8
        }
        return abValue
    }

    /// Converts a hex string into a byte array. The hex string may have various formats e.g.
    /// "ABCDEF", "AB cd EF", "0xab:0xc:0xde", "ab, C, DE". ASCII strings may be included if
    /// surrounded by hyphens, e.g 'My String'.
    ///
    /// - Parameter data: Hex string to be converted
    ///
    /// - Returns: Byte array with converted hex string
    ///
    /// - Throws: ``UtilsError`` if conversion fails for syntactical reasons.
    ///
    public static func toByteArray(data: String) throws -> Data {
        var iLength = data.count
        var abValue = Data(count: iLength)
        var index = 0
        var iOffset = 0
        var bOddNibbleCountAllowed = false

        while index < iLength {
            var characterUnicode = getUnicode(character: data[data.index(data.startIndex,
                                                                         offsetBy: index)])
            var iValue = -1

            if (characterUnicode >= getUnicode(character: "0")) &&
                (characterUnicode <= getUnicode(character: "9")) {
                iValue = Int(characterUnicode - getUnicode(character: "0"))
            } else if (characterUnicode >= getUnicode(character: "A")) &&
                (characterUnicode <= getUnicode(character: "F")) {
                iValue = Int(characterUnicode - getUnicode(character: "A") + 10)
            } else if (characterUnicode >= getUnicode(character: "a")) &&
                (characterUnicode <= getUnicode(character: "f")) {
                iValue = Int(characterUnicode - getUnicode(character: "a") + 10)
            } else if ((characterUnicode == getUnicode(character: "x")) ||
                (characterUnicode == getUnicode(character: "X")))
                && ((iOffset & 1) == 1) {
                if abValue[iOffset >> 1] == 0 {
                    bOddNibbleCountAllowed = true

                    // ignore 0x..
                    iOffset -= 1
                } else {
                    // x but not 0x found
                    throw UtilsError(description: Utils.errIllegalCharacter)
                }
            } else if characterUnicode >= getUnicode(character: "A") {
                // character cannot be delimiter
                throw UtilsError(description: Utils.errIllegalCharacter)
            } else if characterUnicode == getUnicode(character: "\"") {
                // read ASCII values
                index += 1
                while index < iLength {
                    characterUnicode = getUnicode(character: data[data.index(data.startIndex,
                                                                             offsetBy: index)])
                    if characterUnicode == getUnicode(character: "\"") {
                        break
                    }

                    abValue[iOffset >> 1] = characterUnicode
                    iOffset += 2
                    index += 1
                }

                if ((iOffset & 1) != 0) || (characterUnicode != getUnicode(character: "\"")) {
                    // character cannot be start of ASCII string
                    throw UtilsError(description: Utils.errIllegalCharacter)
                }
            } else if (iOffset & 1) == 1 {
                if !bOddNibbleCountAllowed && isDedicatedDelimiter(
                    character: Character(UnicodeScalar(characterUnicode))) {
                    bOddNibbleCountAllowed = true
                }

                if bOddNibbleCountAllowed {
                    // delimiter found, so just one nibble specified (e.g. 0xA:0xB...)
                    iOffset += 1
                }
            }

            if iValue >= 0 {
                abValue[iOffset >> 1] = ((abValue[iOffset >> 1] << 4) | UInt8(iValue))
                iOffset += 1
            }
            index += 1
        }

        if !bOddNibbleCountAllowed && ((iOffset & 1) != 0) {
            throw UtilsError(description: Utils.errIllegalCharacter)
        }

        // calculate length of stream
        iLength = (iOffset + 1) >> 1
        return abValue[0..<iLength]
    }

    /// Check if character is a dedicated delimiter character
    ///
    /// - Parameter ch: Character to be checked.
    ///
    /// - Returns: True if dedicated delimiter character
    ///
    private static func isDedicatedDelimiter(character: Character) -> Bool {
        switch character {
        case ",", ".", ":", ";":
            return true
        default:
            return character <= " "
        }
    }

    /// Returns data format for given int. Only minimum number of required bytes returned
    ///
    /// - Parameter intValue: Integer value to be converted
    ///
    /// - Returns: Byte array (data) of the integer value
    ///
    public static func getData(intValue: Int) -> Data {
        var result: Data
        if (intValue & 0xFF) == intValue {
            result = Utils.toData(value: intValue, length: 1)
        } else if (intValue & 0xFFFF) == intValue {
            result = Utils.toData(value: intValue, length: 2)
        } else if (intValue & 0xFFFFFF) == intValue {
            result = Utils.toData(value: intValue, length: 3)
        } else {
            result = Utils.toData(value: intValue, length: 4)
        }
        return result
    }

    /// Concatenate the content of two data arrays and return resulting array.
    ///
    /// - Parameters:
    ///   - firstData: First data array
    ///   - secondData: Second data array
    ///
    /// - Returns: Resulting data array which is the concatenation of firstData and secondData.
    ///
    public static func concat(firstData: Data, secondData: Data) -> Data {
        var result = firstData
        result.append(contentsOf: secondData)
        return result
    }

    /// Gets the Unicode of character ASCII
    ///
    /// - Parameter ch: Character to be get unicode.
    ///
    /// - Returns: Unicode value of input character
    ///
    private static func getUnicode(character: Character) -> UInt8 {
        let unicodeString = String(character).unicodeScalars
        return UInt8(unicodeString[unicodeString.startIndex].value)
    }

    /// Gives 2 byte integer
    ///
    /// - Parameters:
    ///   - data: Byte array
    ///   - offset: Offset value
    ///
    /// - Returns: 2 byte integer
    ///
    /// - Throws: ``UtilsError`` in case of error.
    ///
    public static func getUINT16(data: Data,
                                 offset: Int) throws -> UInt16 {
        return try (UInt16(Utils.getUInt8WithIndex(index: offset,
                                          data: data)) & 0xFF) << 8 |
            (UInt16(Utils.getUInt8WithIndex(index: offset + 1,
                                   data: data)) & 0xFF)
    }

    /// Gives 1 byte integer
    ///
    /// - Parameters:
    ///   - dataBytes: Byte array
    ///   - offset: Offset value
    ///
    /// - Returns: 1 byte integer
    ///
    /// - Throws: ``UtilsError`` in case of error.
    ///
    public static func getUINT8(dataBytes: Data,
                                offset: Int) throws -> UInt8 {
        return try UInt8(Utils.getUInt8WithIndex(index: offset,
                                        data: dataBytes))
    }

    /// Gets the sub data from the stream of source data based on length and index.
    ///
    /// - Parameters:
    ///   - length: Required length of byte array.
    ///   - data: Source of data byte stream.
    ///   - index: Index of data byte
    ///
    /// - Returns: Byte array.
    ///
    /// - Throws: ``UtilsError`` in case of index out of bound.
    ///
    public static func getDataFromStream(length: Int,
                                         data: Data,
                                         index: inout Int) throws -> Data {
        if length > 0 {
            let bytesData: Data = try Utils.getSubData(offset: index,
                                                       data: data,
                                                       length: index + Int(length))
            index += Int(length)
            return bytesData
        } else {
            return Data()
        }
    }

    /// Gets the sub data from the stream of source data based on length and offset.
    ///
    /// - Parameters:
    ///   - offset: Index of data byte
    ///   - data: Source of data byte stream.
    ///   - length: Required length of byte array.
    ///
    /// - Returns: Byte array.
    ///
    /// - Throws: ``UtilsError`` in case of index out of bound.
    ///
    public static func getSubData(offset: Int,
                                  data: Data,
                                  length: Int) throws -> Data {
        if length <= data.count {
            var subData = Data()
            subData.append(contentsOf: data[offset..<length])
            return subData
        } else {
            throw UtilsError(description: "Index out of range")
        }
    }

    /// Gives 1 byte integer
    ///
    /// - Parameters:
    ///   - dataBytes: Byte array
    ///   - offset: Offset value
    ///
    /// - Returns: 1 byte integer
    ///
    /// - Throws: ``UtilsError`` in case of error.
    ///
    public static func getUInt8WithIndex(index: Int,
                                data: Data) throws -> UInt8 {
        if index < data.count {
            return data[index]
        } else {
            throw UtilsError(description: "Index out of range")
        }
    }

    /// Copies source array to destination array from specified offsets and length.
    ///
    /// - Parameters:
    ///   - src: Source data bytes
    ///   - srcOffset: Source offset
    ///   - dest:  Destination data bytes
    ///   - destOffset: Destination offset
    ///   - length: Length of bytes to copy
    ///
    /// - Returns: The next offset within destination array after copying
    ///
    public static func dataCopy(src: Data,
                                srcOffset: Int,
                                dest: inout Data,
                                destOffset: Int,
                                length: Int) -> Int {
        for index in 0..<length {
            dest[destOffset + index] = src[srcOffset + index]
        }
        return destOffset + length
    }

    /// Converts given hex string into integer
    ///
    /// - Parameter value: Any value
    ///
    /// - Returns: Integer value
    ///
    /// - Throws: ``UtilsError`` if there is utility related failure
    ///
    public static func toInteger(_ value: Any) throws -> Int {
        if let intValue = value as? Int {
            return intValue
        } else if let doubleValue = value as? Double {
            return Int(doubleValue)
        } else {
            let bytes = try Utils.toData(stream: value)
            var bts = Data(repeating: 0, count: 4)
            if bytes.count < 4 {
                bts.replaceSubrange(bts.count - bytes.count..<bts.count,
                                    with: bytes)
            } else {
                bts = bytes[0..<4]
            }
            return getIntFromArray(bts, 0)
        }
    }

    /// Extracts integer from given byte array
    ///
    /// - Parameters:
    ///   - paramArrayOfByte: Byte array from which the integer has to be extracted
    ///   - paramInt: Offset within the byte array at which the int has to be extracted
    ///
    /// - Returns: Extracted integer
    ///
    public static func getIntFromArray(_ paramArrayOfByte: Data,
                                       _ paramInt: Int) -> Int {
        return Int(paramArrayOfByte[paramInt]) << 24 & 0xFF000000
            | Int(paramArrayOfByte[paramInt + 1]) << 16 & 0xFF0000
            | Int(paramArrayOfByte[paramInt + 2]) << 8 & 0xFF00
            | Int(paramArrayOfByte[paramInt + 3]) & 0xFF
    }
}
