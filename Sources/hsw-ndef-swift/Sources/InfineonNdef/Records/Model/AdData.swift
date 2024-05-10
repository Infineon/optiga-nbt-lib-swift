// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Class represents a container for advertising and scan response data (AD)
/// format. Each AD structure consists of an AD length field of 1 octet, an AD
/// type field, and an AD data field.
public class AdData {
    /// Defines the size of the short value.
    private static let sizeShort = 2

    /// Defines the offset of the tag.
    private static let offsetTag = 0

    /// Defines the offset of the value field.
    private static let offsetValue = 1

    /// The AD type field
    private var type: UInt8 = 0

    /// The AD data field
    private var data: Data = Data()

    /// Constructor to create a new advertising and scan response data (AD) response model.
    ///
    /// - Parameters:
    ///   - adType: The AD type field
    ///   - dataBytes: The AD data field
    ///
    public init(adType: UInt8, dataBytes: Data) {
        self.type = adType
        self.data = dataBytes
    }

    /// Constructor to create a new advertising and scan response data (AD) response model.
    ///
    /// - Parameter adBytes: Bytes representing the advertising and scan response data (AD) with
    /// tag and value.
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public init(adBytes: Data) throws {
        self.type = try Utils.getUInt8WithIndex(index: AdData.offsetTag, data: adBytes)
        self.data = try Utils.getSubData(offset: AdData.offsetValue, data: adBytes, length: adBytes.count)
    }

    /// Constructor to create a new extended inquiry response model.
    ///
    /// - Parameters:
    ///   - adType: The AD type field
    ///   - dataBytes: The AD data field
    ///
    public init(adType: DataTypes, dataBytes: Data) {
        self.type = adType.rawValue
        self.data = dataBytes
    }

    /// Sets the AD type field.
    ///
    /// - Returns: AD type field UInt8
    ///
    public func getType() -> UInt8? {
        return self.type
    }

    /// Sets the AD type field.
    ///
    /// - Parameter dataType: AD type field byte
    ///
    public func setType(dataType: UInt8) {
        self.type = dataType
    }

    /// Sets the AD type field.
    ///
    /// - Parameter dataType: AD type field byte
    ///
    public func setType(dataType: DataTypes) {
        self.type = dataType.rawValue
    }

    /// Gets the AD data field.
    ///
    /// - Returns: the AD data field Data
    ///
    public func getData() -> Data {
        return data
    }

    /// Sets the AD data field.
    ///
    /// - Parameter dataBytes: AD data field Data
    ///
    public func setData(dataBytes: Data) {
        self.data = dataBytes
    }

    /// Sets the AD data field.
    ///
    /// - Parameter data: AD data field as UInt16
    ///
    public func setData(data: UInt16) {
        let value: UInt16 = data
        var adData = Data(count: MemoryLayout<UInt16>.size)
        adData.withUnsafeMutableBytes { ptr in
            ptr.storeBytes(of: value.bigEndian, as: UInt16.self)
        }
        self.data = adData
    }

    /// Sets the AD data field.
    ///
    /// - Parameter data: AD data field as UInt8
    ///
    public func setData(data: UInt8) {
        self.data = Data([data])
    }

    /// Gets the AD data length.
    ///
    /// - Returns: Returns the length of AD data.
    ///
    public func getLength() -> Int {
        return data.count
    }

    /// Gets the AD data field as UInt16.
    ///
    /// - Returns: Returns the AD data field UInt16.
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public func getDataShort() throws -> UInt16 {
        return try Utils.getUINT16(data: data, offset: 0)
    }

    /// Gets the AD data field as UInt8.
    ///
    /// - Returns: Returns the AD data field UInt8 .
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public func getDataByte() throws -> UInt8 {
        return try Utils.getUINT8(dataBytes: data, offset: 0)
    }

    /// Encodes the advertising and scan response data (AD) format to byte.
    ///
    /// - Returns: Returns the encoded advertising and scan response data (AD) format data bytes.
    ///
    public func toBytes() -> Data {
        let header: [UInt8] = [UInt8(data.count + 1), type]
        let dataBytes = Data(header)
        return Utils.concat(firstData: dataBytes, secondData: data)
    }
}
