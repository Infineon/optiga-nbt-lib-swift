// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

///  Encodes the BLE record type to payload byte array.
public class BluetoothLeRecordPayloadEncoder: IRecordPayloadEncoder {
    /// Defines length of the BLE address.
    private let deviceAddressLength = 7

    /// Error message if stream of Bluetooth LE device address is not 7 bytes.
    private let errMessageDeviceAddress =
        "Bluetooth device address must be 7 bytes"

    /// Private tag for the logger message header
    private let headerTag = "BluetoothLeRecordPayloadEncoder"

    /// Error message if stream of Bluetooth LE device role is null or
    /// undefined.
    private let errMessageDeviceRole =
        "Bluetooth device role must not be null or undefined"

    /// Error message if stream of Bluetooth LE record  is invalid
    private let invalidBluetoothLeRecord = "Unable to cast to BluetoothLeRecord"

    /// Encodes the BLE record data structure into the record payload byte array.
    ///
    /// - Parameter abstractRecord: MimeRecord ``BluetoothLeRecord``
    ///
    /// - Returns: BLE record payload data
    ///
    /// - Throws: ``NdefError``If unable to decode the record payload
    ///
    public func encodePayload(abstractRecord: AbstractRecord) throws -> Data {
        guard let bleRecord =
            abstractRecord as? BluetoothLeRecord
        else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: invalidBluetoothLeRecord)
            throw
                NdefError(description: invalidBluetoothLeRecord)
        }

        try validateBLEPayload(bleRecord: bleRecord)

        var payload = Data()
        if let address = bleRecord.getAddress() {
            payload = Utils.concat(firstData: payload,
                                   secondData: address.toBytes())
        }
        if let role = bleRecord.getRole() {
            payload = Utils.concat(firstData: payload,
                                   secondData: role.toBytes())
        }
        if let securityManagerTKValue = bleRecord.getSecurityManagerTKValue() {
            payload = Utils.concat(firstData: payload,
                                   secondData: securityManagerTKValue.toBytes())
        }
        if let appearance = bleRecord.getAppearance() {
            payload = Utils.concat(firstData: payload,
                                   secondData: appearance.toBytes())
        }
        if let flags = bleRecord.getFlags() {
            payload = Utils.concat(firstData: payload,
                                   secondData: flags.toBytes())
        }
        if let name = bleRecord.getName() {
            payload = Utils.concat(firstData: payload,
                                   secondData: name.toBytes())
        }
        for otherEIR in bleRecord.getOptionalAdList() {
            payload = Utils.concat(firstData: payload,
                                   secondData: otherEIR.toBytes())
        }
        NdefManager.getLogger()?.debug(header: headerTag, data: payload)
        NdefManager.getLogger()?.info(header: headerTag, message: "Payload encoded successfully.")
        return payload
    }

    /// Validates the input Bluetooth LE record.
    ///
    /// - Parameter bleRecord: Mime BluetoothLeRecord
    ///
    /// - Throws: ``NdefError``If unable to decode the record payload
    ///
    private func validateBLEPayload(bleRecord: BluetoothLeRecord) throws {
        guard let address = bleRecord.getAddress()
        else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errMessageDeviceAddress)
            throw
                NdefError(description: errMessageDeviceAddress)
        }
        if address.getData().count != deviceAddressLength {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errMessageDeviceAddress)
            throw
                NdefError(description: errMessageDeviceAddress)
        }
        guard let role = bleRecord.getRole() else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errMessageDeviceRole)
            throw
                NdefError(description: errMessageDeviceRole)
        }
        if role.getData().isEmpty {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errMessageDeviceRole)
            throw
                NdefError(description: errMessageDeviceRole)
        }
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
