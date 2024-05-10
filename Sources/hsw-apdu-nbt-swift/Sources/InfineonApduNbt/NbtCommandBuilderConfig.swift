// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu
import InfineonUtils

/// Command builder to build the APDUs for NBT configurator application.
/// These APDUs are used to get and set the product configuration.
public class NbtCommandBuilderConfig {
    /// Builds the select command to select the product configuration applet.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func selectConfiguratorApplication() throws -> ApduCommand {
        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insSelect,
                               param1: NbtConstants.p1SelectApplication,
                               param2:  NbtConstants.p2Default,
                               data: NbtConstants.configuratorAid,
                               lengthExpected: Int(NbtConstants.leAny))
    }

    /// Builds the set configuration command. This command can be used to set a
    /// specific product configuration data in the NBT configurator
    /// application.
    ///
    /// - Parameters:
    ///   - tag: Tag to set configuration: Configuration tags enumeration
    ///   can be used.
    ///   - data: Configuration data
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func setConfigData(tag: UInt16, data: Data) throws -> ApduCommand {
        let tlvData: Data = try Tlv.buildDgiTlv(tag: tag, data: data)
        return try ApduCommand(cla: NbtConstants.claConfiguration,
                               ins: NbtConstants.insSetConfiguration,
                               param1: NbtConstants.p1Default,
                               param2:  NbtConstants.p2Default,
                               data: tlvData,
                               lengthExpected: Int(NbtConstants.leAbsent))
    }

    /// Builds the get configuration command. Reads the configuration data from the
    /// NBT configurator application.
    ///
    /// - Parameter tag: Tag to retrieve configuration: Configuration tags enumeration
    /// can be used.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func getConfigData(tag: UInt16) throws -> ApduCommand {
        let tagBytes: Data = try Utils.toData(stream: tag)
        return try ApduCommand(cla: NbtConstants.claConfiguration,
                               ins: NbtConstants.insGetConfiguration,
                               param1: NbtConstants.p1Default,
                               param2:  NbtConstants.p2Default,
                               data: tagBytes,
                               lengthExpected: Int(NbtConstants.leAbsent))
    }
}
