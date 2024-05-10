// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Decodes the payload byte array of the Bluetooth record type.
public class BluetoothRecordPayloadDecoder: IRecordPayloadDecoder {
    /// Error message if input stream of the Bluetooth record payload bytes are not valid.
    private let errMessagePayload =
        "Input stream of Bluetooth record payload bytes are not valid"

    /// Defines the minimum length of the Bluetooth record payload data.
    private let minLength = 8

    /// Private tag for the logger message header
    private let headerTag = "BluetoothRecordPayloadDecoder"

    /// Error message for empty local name
    private let errEmptyLocalName = "Empty local name"

    /// Defines the length of the Bluetooth address.
    private let bluetoothDeviceAddressLength = 6

    /// Defines the length of the OOB data size filed.
    private let oobDataLengthFieldSize = 2

    /// Decodes the Bluetooth record payload byte array into the Bluetooth record data structure.
    ///
    /// - Parameter payload: Data  stream of the Bluetooth record payload
    ///
    /// - Returns: Abstract record data structure of the Bluetooth record
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    public func decodePayload(payload: Data) throws -> AbstractRecord {
        NdefManager.getLogger()?.debug(header: headerTag, data: payload)
        do {
            try RecordDecoderUtils.validatePayload(
                payload: payload, minExpectedLength: minLength)
            // Skipping oobDataLengthFieldSize from stream
            var index: Int = oobDataLengthFieldSize
            let deviceAddress = try readDeviceAddress(data: payload, index: &index)
            return try parseOOBOptionalData(
                payload: payload, deviceAddress: deviceAddress, index: &index)
        } catch {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: RecordDecoderUtils.errMessageInvalidPayload)
            throw NdefError(description:
                RecordDecoderUtils.errMessageInvalidPayload)
        }
    }

    /// Decodes secure simple pairing OOB optional data.
    ///
    /// - Parameters:
    ///   - payload: Data stream of the Bluetooth record payload
    ///   - deviceAddress:  Device address data
    ///   - index: Current index to be decoded.
    ///
    /// - Returns: Abstract record data structure of the Bluetooth record
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    private func parseOOBOptionalData(payload: Data,
                                      deviceAddress: Data,
                                      index: inout Int) throws -> BluetoothRecord {
        let bluetoothRecord = BluetoothRecord(
            deviceAddress: deviceAddress)
        while index < payload.count {
            let length: Int = try Int(Utils.getUInt8WithIndex(index: index, data: payload))
            index += 1
            let optionalOOBData = try EirData(
                eirBytes: Utils.getDataFromStream(length: length,
                                                  data: payload, index: &index))
            let type = optionalOOBData.getType()
            if type == DataTypes.completeLocalName.rawValue {
                guard let localName = String(bytes: optionalOOBData.getData(),
                                             encoding: .utf8)
                else {
                    NdefManager.getLogger()?.error(header: headerTag,
                                                  message: errEmptyLocalName)
                    throw NdefError(description: errEmptyLocalName)
                }
                bluetoothRecord.setName(
                    dataTypes: DataTypes.completeLocalName,
                    localName: localName)
            } else if type == DataTypes.shortenedLocalName.rawValue {
                guard let localName =
                    String(bytes: optionalOOBData.getData(),
                           encoding: .utf8)
                else {
                    NdefManager.getLogger()?.error(header: headerTag,
                                                  message: errEmptyLocalName)
                    throw NdefError(description: errEmptyLocalName)
                }
                bluetoothRecord.setName(
                    dataTypes: DataTypes.shortenedLocalName,
                    localName: localName)
            } else if type == DataTypes.simplePairingHashC192.rawValue {
                bluetoothRecord.setSimplePairingHash(
                    dataTypes: DataTypes.simplePairingHashC192,
                    simplePairingHashBytes: optionalOOBData.getData())
            } else if type == DataTypes.simplePairingHashC256.rawValue {
                bluetoothRecord.setSimplePairingHash(
                    dataTypes: DataTypes.simplePairingHashC256,
                    simplePairingHashBytes: optionalOOBData.getData())
            } else if type ==
                DataTypes.simplePairingRandomizerR192.rawValue {
                bluetoothRecord.setSimplePairingRandomizer(
                    dataTypes: DataTypes.simplePairingRandomizerR192,
                    simplePairingRandomizerBytes: optionalOOBData.getData())
            } else if type ==
                DataTypes.simplePairingRandomizerR256.rawValue {
                bluetoothRecord.setSimplePairingRandomizer(
                    dataTypes: DataTypes.simplePairingRandomizerR256,
                    simplePairingRandomizerBytes: optionalOOBData.getData())
            } else if type == DataTypes.deviceClass.rawValue {
                bluetoothRecord.setDeviceClass(
                    deviceClassBytes: optionalOOBData.getData())
            } else if type ==
                DataTypes.incompleteServiceClassUuid16Bit.rawValue {
                bluetoothRecord.setServiceClassUuidList(
                    dataTypes: DataTypes.incompleteServiceClassUuid16Bit,
                    serviceClassUUIDBytes: optionalOOBData.getData())
            } else if type ==
                DataTypes.completeServiceClassUuid16Bit.rawValue {
                bluetoothRecord.setServiceClassUuidList(
                    dataTypes: DataTypes.completeServiceClassUuid16Bit,
                    serviceClassUUIDBytes: optionalOOBData.getData())
            } else if type ==
                DataTypes.incompleteServiceClassUuid32Bit.rawValue {
                bluetoothRecord.setServiceClassUuidList(
                    dataTypes: DataTypes.incompleteServiceClassUuid32Bit,
                    serviceClassUUIDBytes: optionalOOBData.getData())
            } else if type ==
                DataTypes.completeServiceClassUuid32Bit.rawValue {
                bluetoothRecord.setServiceClassUuidList(
                    dataTypes: DataTypes.completeServiceClassUuid32Bit,
                    serviceClassUUIDBytes: optionalOOBData.getData())
            } else if type ==
                DataTypes.incompleteServiceClassUuid128Bit.rawValue {
                bluetoothRecord.setServiceClassUuidList(
                    dataTypes: DataTypes.incompleteServiceClassUuid128Bit,
                    serviceClassUUIDBytes: optionalOOBData.getData())
            } else if type ==
                DataTypes.completeServiceClassUuid128Bit.rawValue {
                bluetoothRecord.setServiceClassUuidList(
                    dataTypes: DataTypes.completeServiceClassUuid128Bit,
                    serviceClassUUIDBytes: optionalOOBData.getData())
            } else {
                bluetoothRecord.addOtherEIResponseList(
                    optionalEIR: optionalOOBData)
            }
        }
        NdefManager.getLogger()?.info(header: headerTag, message: "Payload decoded successfully.")
        return bluetoothRecord
    }

    /// Decodes the device address.
    ///
    /// - Parameters:
    ///   - data: Data stream of the Bluetooth record payload
    ///   - index: Current index to be decoded.
    ///
    /// - Returns: Device address data
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    private func readDeviceAddress(data: Data, index: inout Int) throws -> Data {
        return try Utils.getDataFromStream(
            length: bluetoothDeviceAddressLength, data: data, index: &index)
    }

    /// Provides public access to create initializer
    public init() {
       // Provides public access
    }
}
