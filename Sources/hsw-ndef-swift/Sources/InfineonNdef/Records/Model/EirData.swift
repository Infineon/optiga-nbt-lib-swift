// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

import InfineonUtils

/// Represents a container for extended inquiry response data object. Each
/// EIR structure consists of an EIR Length field of 1 octet, an EIR Type field,
/// and an EIR Data field.
public class EirData {
    /// Defines the size of short value.
    private static let sizeShort = 2

    /// Defines the offset of tag.
    private static let offsetTag = 0

    /// Defines the offset of value.
    private static let offsetValue = 1

    /// Illegal argument error message if the EIR data field is null.
    private static let errMessageEirData =
        "The EIR data field should not be null"

    /// Illegal argument error message if the EIR data type field is null.
    private static let errMessageEirDataType =
        "The EIR data type field should not be null"

    /// The EIR type field
    private var type: UInt8 = 0

    /// The EIR data field
    private var data: Data = Data()

    /// Constructor to create a new extended inquiry response model.
    ///
    /// - Parameters:
    ///   - dataType: The EIR type field
    ///   - dataBytes: The EIR data field
    ///
    public init(dataType: UInt8, dataBytes: Data) {
        self.type = dataType
        self.data = dataBytes
    }

    /// Constructor to create a new extended inquiry response model.
    ///
    /// - Parameter eirBytes: Bytes representing extended inquiry response
    /// (EIR) data with tag and value.
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public init(eirBytes: Data) throws {
        self.type = try Utils.getUInt8WithIndex(index: EirData.offsetTag, data: eirBytes)
        self.data = try Utils.getSubData(offset: EirData.offsetValue, data: eirBytes, length: eirBytes.count)
    }

    /// Constructor to create a new extended inquiry response model.
    ///
    /// - Parameters:
    ///   - eirType: The EIR type field
    ///   - dataBytes: The EIR data field
    ///
    public init(eirType: DataTypes, dataBytes: Data) {
        self.type = eirType.rawValue
        self.data = dataBytes
    }

    /// Gets the EIR type field.
    ///
    /// - Returns: Returns the EIR type field UInt8
    ///
    public func getType() -> UInt8? {
        return self.type
    }

    /// Sets the EIR type field.
    ///
    /// - Parameter dataType: The EIR type field UInt8
    ///
    public func setType(dataType: UInt8) {
        self.type = dataType
    }

    /// Sets the EIR type field.
    ///
    /// - Parameter dataType: The EIR type field DataTypes
    ///
    public func setType(dataType: DataTypes) {
        self.type = dataType.rawValue
    }

    /// Gets the EIR data field.
    ///
    /// - Returns: Returns EIR data field bytes.
    ///
    public func getData() -> Data {
        return data
    }

    /// Sets the EIR data field.
    ///
    /// - Parameter dataBytes: The EIR data field bytes
    ///
    public func setData(dataBytes: Data) {
        self.data = dataBytes
    }

    /// Sets the AD data field.
    ///
    /// - Parameter data: AD data field as UInt16
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public func setData(data: UInt16) throws {
        let value: UInt16 = data
        var eirData = Data(count: MemoryLayout<UInt16>.size)
        eirData.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: value.bigEndian, as: UInt16.self)
        }

        self.data = eirData
    }

    /// Sets the AD data field.
    ///
    /// - Parameter data: AD data field as UInt8
    ///
    public func setData(data: UInt8) {
        self.data = Data([data])
    }

    /// Gets the EIR data length.
    ///
    /// - Returns: Returns the length of EIR data.
    ///
    public func getLength() -> Int {
        return data.count
    }

    /// Gets the EIR data field as UInt16.
    ///
    /// - Returns: Returns the EIR data field UInt16.
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public func getDataShort() throws -> UInt16 {
        return try Utils.getUINT16(data: data, offset: 0)
    }

    /// Gets the EIR data field as UInt8.
    ///
    /// - Returns: Returns the EIR data field UInt8.
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public func getDataBytes() throws -> UInt8 {
        return try Utils.getUINT8(dataBytes: data, offset: 0)
    }

    /// Encodes the EIR format data to byte.
    ///
    /// - Returns: Returns the encoded EIR format data bytes.
    ///
    public func toBytes() -> Data {
        let header: [UInt8] = [UInt8(data.count + 1), type]
        let dataBytes = Data(header)
        return Utils.concat(firstData: dataBytes, secondData: data)
    }
}
