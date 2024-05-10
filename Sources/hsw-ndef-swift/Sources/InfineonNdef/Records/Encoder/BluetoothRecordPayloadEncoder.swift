// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Encodes the Bluetooth record type to payload byte array.
public class BluetoothRecordPayloadEncoder: IRecordPayloadEncoder {
    /// Defines length of the Bluetooth address.
    private let bluetoothDeviceAddressLength = 6

    /// Defines size of the OOB data length size.
    private let oobLengthFieldSize = 2

    /// Private tag for the logger message header
    private let headerTag = "BluetoothRecordPayloadEncodere"

    /// Error message if input stream of the Bluetooth device
    /// address is not 6 bytes.
    private let errMessageDeviceAddress =
        "Bluetooth device address must be 6 bytes"

    /// Error message for invalid record type
    private let errMessageRecordType =
        "Invalid record type. Expected BluetoothRecord."

    /// Encodes the Bluetooth record data structure into the record payload byte array.
    ///
    /// - Parameter abstractRecord: MimeRecord ``BluetoothRecord``
    ///
    /// - Returns: Bluetooth record payload data
    ///
    /// - Throws: ``NdefError``If unable to decode the record payload
    ///
    public func encodePayload(abstractRecord: AbstractRecord) throws -> Data {
        guard let bluetoothRecord =
            abstractRecord as? BluetoothRecord
        else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errMessageRecordType)
            throw
                NdefError(description: errMessageRecordType)
        }
        try validateBluetoothPayload(bluetoothRecord: bluetoothRecord)

        var payload = bluetoothRecord.getAddress()
        if let name = bluetoothRecord.getName() {
            payload = Utils.concat(
                firstData: payload, secondData: name.toBytes())
        }
        if let deviceClass = bluetoothRecord.getDeviceClass() {
            payload = Utils.concat(firstData: payload,
                                   secondData: deviceClass.toBytes())
        }
        if let serviceUUIDs = bluetoothRecord.getServiceClassUuidList() {
            payload = Utils.concat(firstData: payload,
                                   secondData: serviceUUIDs.toBytes())
        }
        if let pairingHash = bluetoothRecord.getSimplePairingHash() {
            payload = Utils.concat(firstData: payload,
                                   secondData: pairingHash.toBytes())
        }
        if let pairingRandomizer = bluetoothRecord.getSimplePairingRandomizer() {
            payload = Utils.concat(firstData: payload,
                                   secondData: pairingRandomizer.toBytes())
        }

        for data in bluetoothRecord.getOtherEIRList() {
            payload = Utils.concat(firstData: payload,
                                   secondData: data.toBytes())
        }
        let data = setIntLittleEndian(
            value: payload.count + oobLengthFieldSize, offset: 0, length: oobLengthFieldSize)
        payload = Utils.concat(firstData: data, secondData: payload)
        NdefManager.getLogger()?.debug(header: headerTag, data: payload)
        NdefManager.getLogger()?.info(header: headerTag, message: "Payload encoded successfully.")
        return payload
    }

    /// Validate the input ``BluetoothRecord``.
    ///
    /// - Parameter bluetoothRecord: Bluetooth record to be validated
    ///
    /// - Throws: ``NdefError``If unable to decode the record payload
    ///
    private func validateBluetoothPayload(
        bluetoothRecord: BluetoothRecord) throws {
        if bluetoothRecord.getAddress().count != bluetoothDeviceAddressLength {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errMessageDeviceAddress)
            throw
                NdefError(description: errMessageDeviceAddress)
        }
    }

    /// Convert integer to data
    ///
    /// - Parameters:
    ///   - value: Source value to be set
    ///   - offset: Offset
    ///   - length: Length
    ///
    /// - Returns: Returns data
    ///
    private func setIntLittleEndian(value: Int,
                                    offset: Int, length: Int) -> Data {
        var value = value
        var data = Data()
        for _ in offset ..< offset + length {
            data.append(UInt8(value))
            value >>= 8
        }
        return data
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
