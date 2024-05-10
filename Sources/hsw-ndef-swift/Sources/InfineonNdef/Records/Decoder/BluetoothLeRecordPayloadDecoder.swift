// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

///  Decodes the payload byte array of Bluetooth low energy (BLE) record type.
public class BluetoothLeRecordPayloadDecoder: IRecordPayloadDecoder {
    /// Defines the minimum length of BLE record payload data.
    private let minLength = 10

    /// Private tag for the logger message header
    private let headerTag = "BluetoothLeRecordPayloadDecoder"

    /// Decodes the BLE record payload byte array into the BLE record data structure.
    ///
    /// - Parameter payload: Data stream of the BLE record payload
    ///
    /// - Returns: Abstract record data structure of the BLE record
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    public func decodePayload(payload: Data) throws -> AbstractRecord {
        do {
            try RecordDecoderUtils.validatePayload(
                payload: payload, minExpectedLength: minLength)
            return try parseOOBData(payload: payload)
        } catch {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: RecordDecoderUtils.errMessageInvalidPayload)
            throw NdefError(description:
                RecordDecoderUtils.errMessageInvalidPayload)
        }
    }

    /// Decodes security manager out-of-band (OOB) pairing data.
    ///
    /// - Parameter payload: Data stream of the BLE record payload
    ///
    /// - Returns: Abstract record data structure of the BLE record
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    private func parseOOBData(payload: Data) throws -> BluetoothLeRecord {
        NdefManager.getLogger()?.debug(header: headerTag, data: payload)
        let bleRecord = BluetoothLeRecord()
        var index = 0
        while index < payload.count {
            let length = try Utils.getUInt8WithIndex(index: index, data: payload)
            index += 1
            let advertisingResponse = try AdData(
                adBytes: Utils.getDataFromStream(
                    length: Int(length), data: payload, index: &index))
            let type = advertisingResponse.getType()
            if type == DataTypes.completeLocalName.rawValue {
                if let localName = String(
                    data: advertisingResponse.getData(), encoding: .utf8) {
                    bleRecord.setName(
                        dataTypes: DataTypes.completeLocalName,
                        localName: localName)
                }
            } else if type == DataTypes.shortenedLocalName.rawValue {
                if let localName = String(
                    data: advertisingResponse.getData(), encoding: .utf8) {
                    bleRecord.setName(
                        dataTypes: DataTypes.shortenedLocalName,
                        localName: localName)
                }
            } else if type == DataTypes.flags.rawValue {
                bleRecord.setFlags(leFlags: advertisingResponse.getData())
            } else if type == DataTypes.appearance.rawValue {
                try bleRecord.setAppearance(
                    leAppearance: advertisingResponse.getDataShort())
            } else if type == DataTypes.leBluetoothRole.rawValue {
                try bleRecord.setLeRole(leRole: advertisingResponse.getDataByte())
            } else if type == DataTypes.leBluetoothDeviceAddress.rawValue {
                bleRecord.setAddress(
                    deviceAddress: advertisingResponse.getData())
            } else if type == DataTypes.securityManagerTkValue.rawValue {
                bleRecord.setSecurityManagerTKValue(
                    leSecurityManagerTKValue: advertisingResponse.getData())
            } else {
                bleRecord.addOptionalAD(optionalAD: advertisingResponse)
            }
        }
        NdefManager.getLogger()?.info(header: headerTag, message: "Payload decoded successfully.")
        return bleRecord
    }

    /// Provides public access to create initializer
    public init() {
       // Provides public access
    }
}
