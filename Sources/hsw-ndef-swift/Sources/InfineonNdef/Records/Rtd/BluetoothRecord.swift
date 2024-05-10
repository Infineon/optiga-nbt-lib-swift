// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// The NFC Local Type Name for the action is 'application/vnd.bluetooth.ep.oob'.
/// Bluetooth carrier configuration record is a record that stores the bluetooth
/// secure simple pairing OOB data that can be exchanged in connection handover
/// request and/or select messages as alternative carrier information.
public class BluetoothRecord: AbstractMimeTypeRecord {
    /// Defines the MIME type (defined in [NDEF], [RTD]) for
    /// the Bluetooth carrier configuration record.
    public static let bluetoothType = "application/vnd.bluetooth.ep.oob"

    /// The 6 octets Bluetooth device address is encoded in Little Endian order.
    private var address: Data = Data()

    /// The local name is the user-friendly name presented over Bluetooth technology.
    private var name: EirData?

    /// The simple pairing hash C.
    private var simplePairingHash: EirData?

    /// The simple pairing randomizer R.
    private var simplePairingRandomizer: EirData?

    /// Service class UUID. Service class information is used to
    /// identify the supported Bluetooth services of the device.
    private var serviceClassUuidList: EirData?

    /// The class of device information is to be used to provide a graphical
    /// representation to the user as part of UI involving operations with
    /// Bluetooth devices. For example, it may provide a particular icon to
    /// present the device.
    private var deviceClass: EirData?

    /// There are a number of EIR data types defined by the Bluetooth SIG.
    /// List of OOB optional data other than appropriate for the Connection
    /// Handover scenario extended inquiry response (EIR) data.
    private var otherEirList: [EirData] = .init()

    /// Constructor to create a new Bluetooth Carrier Configuration record
    /// with bluetooth device address bytes.
    ///
    /// - Parameter deviceAddress: Bluetooth device address bytes
    ///
    public init(deviceAddress: Data) {
        super.init(recordType: BluetoothRecord.bluetoothType)
        self.address = deviceAddress
    }

    /// Gets the Bluetooth device address bytes.
    ///
    /// - Returns: Returns the Bluetooth device address bytes.
    ///
    public func getAddress() -> Data {
        return address
    }

    /// Sets the Bluetooth device address.
    ///
    /// - Parameter deviceAddress: Bluetooth device address
    ///
    public func setAddress(deviceAddress: Data) {
        self.address = deviceAddress
    }

    /// Gets the Bluetooth device UTF_8 decoded local name.
    ///
    /// - Returns: Returns the Bluetooth device local name.
    ///
    public func getNameString() -> String? {
        guard let name = self.name else {
            return nil
        }
        return String(bytes: name.getData(), encoding: .utf8)
    }

    /// Gets the Bluetooth device local name.
    ///
    /// - Returns: Returns the Bluetooth device local name.
    ///
    public func getName() -> EirData? {
        return self.name
    }

    /// Sets the Bluetooth device local name.
    ///
    /// - Parameters:
    ///   - dataTypes: The EIR data field defines Shortened or
    ///   complete Bluetooth local Name.
    ///   - localName: Bluetooth device local name
    ///
    public func setName(dataTypes: DataTypes, localName: String) {
        self.name = EirData(eirType: dataTypes,
                            dataBytes: localName.data(using: .utf8)!)
    }

    /// Gets the simple pairing hash bytes.
    ///
    /// - Returns: Returns the simple pairing hash bytes.
    ///
    public func getSimplePairingHashBytes() -> Data {
        if let simplePairingHash = self.simplePairingHash {
            return simplePairingHash.getData()
        } else {
            return Data()
        }
    }

    /// Gets the simple pairing hash.
    ///
    /// - Returns: Returns the simple pairing hash.
    ///
    public func getSimplePairingHash() -> EirData? {
        return self.simplePairingHash
    }

    /// Sets the simple pairing hash.
    ///
    /// - Parameters:
    ///   - dataTypes: The EIR data field defines the simple pairing hash
    ///   - simplePairingHashBytes: Simple pairing hash
    ///
    public func setSimplePairingHash(dataTypes: DataTypes,
                                     simplePairingHashBytes: Data) {
        self.simplePairingHash = EirData(eirType: dataTypes,
                                         dataBytes: simplePairingHashBytes)
    }

    /// Gets the simple pairing randomizer bytes.
    ///
    /// - Returns: Returns the simple pairing randomizer bytes.
    ///
    public func getSimplePairingRandomizerBytes() -> Data {
        if let simplePairingRandomizer = self.simplePairingRandomizer {
            return simplePairingRandomizer.getData()
        } else {
            return Data()
        }
    }

    /// Gets the simple pairing randomizer.
    ///
    /// - Returns: Returns the simple pairing randomizer.
    ///
    public func getSimplePairingRandomizer() -> EirData? {
        return self.simplePairingRandomizer
    }

    /// Sets the simple pairing randomizer.
    ///
    /// - Parameters:
    ///   - dataTypes: The EIR data field defines simple pairing hash type.
    ///   - simplePairingRandomizerBytes: Simple pairing randomizer
    ///
    public func setSimplePairingRandomizer(dataTypes: DataTypes,
                                           simplePairingRandomizerBytes: Data) {
        self.simplePairingRandomizer = EirData(eirType: dataTypes,
                                               dataBytes: simplePairingRandomizerBytes)
    }

    /// Gets the service class UUIDs.
    ///
    /// - Returns: Returns the service class UUID bytes.
    ///
    public func getServiceClassUuidList() -> EirData? {
        return self.serviceClassUuidList
    }

    /// Sets the service class UUIDs.
    ///
    /// - Parameters:
    ///   - dataTypes: The EIR data field service class UUID encoding type
    ///   - serviceClassUUIDBytes: Service class UUIDs
    ///
    public func setServiceClassUuidList(dataTypes: DataTypes,
                                        serviceClassUUIDBytes: Data) {
        self.serviceClassUuidList = EirData(eirType: dataTypes,
                                            dataBytes: serviceClassUUIDBytes)
    }

    /// Gets the device class bytes.
    ///
    /// - Returns: Returns the device class bytes.
    ///
    public func getDeviceClassBytes() -> Data {
        if let deviceClass = self.deviceClass {
            return deviceClass.getData()
        } else {
            return Data()
        }
    }

    /// Gets the device class.
    ///
    /// - Returns: Returns the service class device class.
    ///
    public func getDeviceClass() -> EirData? {
        return self.deviceClass
    }

    /// Sets the device class bytes.
    ///
    /// - Parameter deviceClassBytes: Device class bytes
    ///
    public func setDeviceClass(deviceClassBytes: Data) {
        self.deviceClass = EirData(eirType: DataTypes.deviceClass,
                                   dataBytes: deviceClassBytes)
    }

    /// Gets the List of other optional EIR data.
    ///
    /// - Returns: Returns the optional EIR data list.
    ///
    public func getOtherEIRList() -> [EirData] {
        return self.otherEirList
    }

    /// Adds the other optional EIR data.
    ///
    /// - Parameter optionalEIR: Optional EIR data.
    ///
    public func addOtherEIResponseList(optionalEIR: EirData) {
        self.otherEirList.append(optionalEIR)
    }
}
