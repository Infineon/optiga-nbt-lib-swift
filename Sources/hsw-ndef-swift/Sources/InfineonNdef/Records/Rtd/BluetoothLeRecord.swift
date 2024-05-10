// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// The NFC local type name for the action is 'application/vnd.bluetooth.le.oob'.
/// Bluetooth LE carrier configuration record is a record that stores the
/// Bluetooth LE security manager OOB required data types that can be
/// exchanged in information.
public class BluetoothLeRecord: AbstractMimeTypeRecord {
    /// Constant defines the length of the BLE address.
    private let deviceAddressLength = 7

    /// Constant defines the offset of the BLE address type.
    private let deviceAddressTypeOffset = 6

    /// Illegal argument error message if LE Bluetooth device address is null.
    private let errMessageDeviceAddress =
        "LE bluetooth device address should not be null"

    /// Illegal argument error message if LE Bluetooth device address is null.
    private let errMessageDeviceAddressLength =
        "LE bluetooth device address should be 7 bytes including 1 " +
        "byte address type (Refer section 1.16. of BLUETOOTH_CSS spec)"

    /// Illegal argument error message if LE Bluetooth device roll is null.
    private let errMessageRole = "LE bluetooth device role should not be null"

    /// Constant defines the Media-type as defined in RFC 2046 [RFC 2046] 0x02
    /// type (defined in [NDEF], [RTD]) for the configuration record.
    public static let bleType = "application/vnd.bluetooth.le.oob"

    /// The 7-octets LE Bluetooth device address encoded in Little Endian order.
    private var address: AdData?

    /// The LE role data type.
    private var role: AdData?

    /// The security manager TK value.
    private var securityManagerTKValue: AdData?

    /// The appearance data type. The appearance characteristic defines
    /// the representation of the external appearance of the device.
    /// For example, a mouse, generic remote control, or keyboard.
    private var appearance: AdData?

    /// Flags data type contain information on which discoverable
    /// mode to use and BR/EDR support and capability.
    private var flags: AdData?

    /// The local name is the user-friendly name presented over
    /// Bluetooth technology.
    private var name: AdData?

    /// List of other optional advertising and scan response (AD) format.
    private var optionalAdList = [AdData]()

    /// Constructor to create a new Bluetooth LE carrier configuration record.
    public init() {
        super.init(recordType: BluetoothLeRecord.bleType)
    }

    /// Constructor to create a new Bluetooth LE Carrier Configuration
    /// record with Bluetooth device address bytes.
    ///
    /// - Parameters:
    ///   - deviceAddress: 7-octets LE Bluetooth device address including
    ///   address type encoded in Little Endian order
    ///   - leRole: LE role data type
    ///
    /// - Throws: ``NdefError`` if device address is invalid
    ///
    public init(deviceAddress: Data, leRole: LeRole) throws {
        super.init(recordType: BluetoothLeRecord.bleType)
        if deviceAddress.count != deviceAddressLength {
            throw NdefError(description:
                errMessageDeviceAddressLength)
        }
        self.address = AdData(adType: DataTypes.leBluetoothDeviceAddress,
                              dataBytes: deviceAddress)
        self.role = AdData(adType: DataTypes.leBluetoothRole,
                           dataBytes: Data([leRole.rawValue]))
    }

    /// Constructor to create a new Bluetooth LE carrier configuration record
    /// with bluetooth device address bytes.
    ///
    /// - Parameters:
    ///   - deviceAddress: 6-octets LE Bluetooth device address excluding
    ///   address type encoded in Little Endian order.
    ///   - addressType: Enumeration represent LE Address type as then
    ///   random or public device address.
    ///   - leRole: LE role data type
    ///
    /// - Throws: ``NdefError`` if device address is invalid
    ///
    public init(deviceAddress: Data,
                addressType: BluetoothLeDeviceAddressType,
                leRole: LeRole) throws {
        super.init(recordType: BluetoothLeRecord.bleType)
        var addressWithType = deviceAddress
        addressWithType.append(addressType.rawValue)
        if addressWithType.count != deviceAddressLength {
            throw NdefError(description:
                errMessageDeviceAddressLength)
        }
        self.address = AdData(adType: DataTypes.leBluetoothDeviceAddress,
                              dataBytes: addressWithType)
        self.role = AdData(adType: DataTypes.leBluetoothRole,
                           dataBytes: Data([leRole.rawValue]))
    }

    /// Gets the 7-octets LE Bluetooth device address in bytes including
    /// address type byte.
    ///
    /// - Returns: Returns the 7-octets LE Bluetooth device address
    /// in bytes including address type.
    ///
    public func getAddressBytesWithType() -> Data {
        return address?.getData() ?? Data()
    }

    /// Gets the 6-octets LE Bluetooth device address in bytes.
    ///
    /// - Returns: Returns the 6-octets LE Bluetooth device address in data bytes.
    ///
    public func getAddressBytes() -> Data {
        if let data = address?.getData() {
            return data.prefix(deviceAddressLength - 1)
        } else {
            return Data()
        }
    }

    /// Gets the LE Bluetooth device address.
    ///
    /// - Returns: Returns the LE Bluetooth device address.
    ///
    public func getAddress() -> AdData? {
        return address
    }

    /// Gets the LE Bluetooth device address type.
    ///
    /// - Returns: Returns the LE Bluetooth device address type.
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public func getAddressType() throws -> BluetoothLeDeviceAddressType? {
        if let addressData = address?.getData(),
           addressData.count == deviceAddressLength {
            return try BluetoothLeDeviceAddressType.getEnumByValue(
                value: Utils.getUInt8WithIndex(index: deviceAddressTypeOffset,
                                      data: addressData))
        }
        return nil
    }

    /// Sets the 7-octets LE Bluetooth device address including
    /// address type.
    ///
    /// - Parameter deviceAddress: 7-octets LE Bluetooth device
    /// address including address type encoded in Little Endian order.
    ///
    public func setAddress(deviceAddress: Data) {
        if deviceAddress.count != deviceAddressLength {
            fatalError(errMessageDeviceAddressLength)
        }
        address = AdData(adType: DataTypes.leBluetoothDeviceAddress,
                         dataBytes: deviceAddress)
    }

    /// Sets the 6-octets LE Bluetooth device address
    ///
    /// - Parameters:
    ///   - deviceAddress: 6-octets LE bluetooth device address
    ///   excluding address type byte.
    ///   - addressType: Enumeration represent LE Address type
    ///   as then random or public device address.
    ///
    public func setAddress(deviceAddress: Data,
                           addressType: BluetoothLeDeviceAddressType) {
        var addressWithType = deviceAddress
        addressWithType.append(addressType.rawValue)
        setAddress(deviceAddress: addressWithType)
    }

    /// Gets the LE Bluetooth device role enumeration.
    ///
    /// - Returns: Returns the LE Bluetooth device role enumeration.
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public func getRoleEnum() throws -> LeRole? {
        if let data = try role?.getDataByte() {
            return LeRole.getEnumByValue(value: data)
        }
        return nil
    }

    /// Gets the LE Bluetooth device role.
    ///
    /// - Returns: Returns the LE Bluetooth device role.
    ///
    public func getRole() -> AdData? {
        return role
    }

    /// Gets the LE Bluetooth device role byte.
    ///
    /// - Returns: Returns the LE Bluetooth device role byte.
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public func getRoleByte() throws -> UInt8? {
        return try role?.getDataByte()
    }

    /// Sets the LE Bluetooth device role.
    ///
    /// - Parameter leRole: LE Bluetooth device role
    ///
    public func setLeRole(leRole: LeRole) {
        role = AdData(adType: DataTypes.leBluetoothRole,
                      dataBytes: Data([leRole.rawValue]))
    }

    /// Sets the LE Bluetooth device role.
    ///
    /// - Parameter leRole: LE Bluetooth device role
    ///
    public func setLeRole(leRole: UInt8) {
        role = AdData(adType: DataTypes.leBluetoothRole,
                      dataBytes: Data([leRole]))
    }

    /// Gets the security manager TK value in bytes.
    ///
    /// - Returns: Returns the security manager TK value in bytes.
    ///
    public func getSecurityManagerTKValueBytes() -> Data {
        return securityManagerTKValue?.getData() ?? Data()
    }

    /// Gets the security manager TK value.
    ///
    /// - Returns: Returns the security manager TK value.
    ///
    public func getSecurityManagerTKValue() -> AdData? {
        return securityManagerTKValue
    }

    /// Sets the security manager TK value.
    ///
    /// - Parameter leSecurityManagerTKValue: The security manager TK value
    ///
    public func setSecurityManagerTKValue(leSecurityManagerTKValue: Data) {
        if leSecurityManagerTKValue.isEmpty {
            securityManagerTKValue = nil
        } else {
            securityManagerTKValue = AdData(
                adType: DataTypes.securityManagerTkValue,
                dataBytes: leSecurityManagerTKValue)
        }
    }

    /// Gets the appearance data type in UInt16.
    ///
    /// - Returns: Returns the appearance data type in UInt16.
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public func getAppearanceShort() throws -> UInt16 {
        return try appearance?.getDataShort() ??
            AppearanceCategory.unknown.rawValue
    }

    /// Gets the appearance data type.
    ///
    /// - Returns: Returns the appearance data type.
    ///
    public func getAppearance() -> AdData? {
        return appearance
    }

    /// Gets the appearance category.
    ///
    /// - Returns: Returns the appearance category.
    ///
    /// - Throws: UtilsError in case of error.
    ///
    public func getAppearanceCategory() throws -> String {
        guard let appearanceData = try appearance?.getDataShort(),
              let category = AppearanceCategory.getEnumByValue(
                  value: appearanceData)
        else {
            return AppearanceCategory.unknown.getName()
        }
        return category.getName()
    }

    /// Sets the appearance data type.
    ///
    /// - Parameter leAppearance: The appearance data type
    ///
    public func setAppearance(leAppearance: UInt16) {
        appearance = AdData(adType: DataTypes.appearance,
                            dataBytes: Data([0]))
        appearance?.setData(data: leAppearance)
    }

    /// Sets the appearance data type enumeration.
    ///
    /// - Parameter leAppearance: The appearance data type enumeration
    ///
    public func setAppearance(leAppearance: AppearanceCategory) {
        appearance = AdData(adType: DataTypes.appearance,
                            dataBytes: Data([0]))
        appearance?.setData(data: leAppearance.rawValue)
    }

    /// Gets the flags data type in bytes.
    ///
    /// - Returns: Returns the flags data type in bytes.
    ///
    public func getFlagsBytes() -> Data {
        return flags?.getData() ?? Data()
    }

    /// Gets the flags data type.
    ///
    /// - Returns: Returns the flags data type.
    ///
    public func getFlags() -> AdData? {
        return flags
    }

    /// Sets the flags data type.
    ///
    /// - Parameter leFlags: The flags data type
    ///
    public func setFlags(leFlags: Data) {
        if leFlags.isEmpty {
            flags = nil
        } else {
            flags = AdData(adType: DataTypes.flags, dataBytes: leFlags)
        }
    }

    /// Gets UTF_8 encoded the user-friendly local name
    /// presented over Bluetooth technology.
    ///
    /// - Returns: Returns the user-friendly local name.
    ///
    public func getNameString() -> String? {
        if let data = name?.getData() {
            return String(bytes: data, encoding: .utf8)
        } else {
            return nil
        }
    }

    /// Gets local name presented over Bluetooth technology.
    ///
    /// - Returns: Returns the local name presented over Bluetooth technology.
    ///
    public func getName() -> AdData? {
        return name
    }

    /// Sets the user-friendly local name presented over Bluetooth technology.
    ///
    /// - Parameters:
    ///   - dataTypes: The EIR data field defines Shortened or complete Bluetooth local name.
    ///   - localName: The user-friendly local name
    ///
    public func setName(dataTypes: DataTypes, localName: String) {
        if !localName.isEmpty,
           let name = localName.data(using: NdefConstants.defaultCharset) {
            self.name = AdData(adType: dataTypes,
                               dataBytes: name)
        } else {
            name = nil
        }
    }

    /// Gets the list of other optional advertising and scan response data (AD) format.
    ///
    /// - Returns: Returns the array list of other optional advertising and scan response data (AD).
    ///
    public func getOptionalAdList() -> [AdData] {
        return optionalAdList
    }

    /// Adds the other optional advertising and scan response data (AD) format.
    ///
    /// - Parameter optionalAD: Advertising and scan response data (AD)
    /// format data (Optional)
    ///
    public func addOptionalAD(optionalAD: AdData) {
        optionalAdList.append(optionalAD)
    }
}
