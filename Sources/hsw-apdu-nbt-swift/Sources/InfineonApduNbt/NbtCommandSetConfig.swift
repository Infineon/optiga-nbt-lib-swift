// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu
import InfineonUtils

/// Collection of commands supported by the NBT configurator application.
public class NbtCommandSetConfig: ApduCommandSet {
    /// Logs a select AID message.
    private static let logMessageSelectAidConfigurator: String =
        "Select Configurator AID"

    /// Logs a set configurator message.
    private static let logMessageSetConfigurator: String =
        "Set data"

    /// Logs a get configurator message.
    private static let logMessageGetConfigurator: String =
        "Get data"
    
    /// Error message for invalid response
    private let errInvalidResponse = "Invalid Response"
    
    /// Error message if unable to read tag data
    private let errUnableToReadTagData = "Could not read tag data, command returned error SW"

    /// Private tag for the logger message header
    private let headerTag = "NbtCommandSetConfig"
    
    /// Instance of configuration command builder for NBT application.
    private var commandBuilderConfig: NbtCommandBuilderConfig = .init()

    /// Constructor of NBT configuration command set to configure the reference
    /// of communication channel and log channel number.
    ///
    /// - Parameter channel: Reference of communication channel associated with
    ///   command handler.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public init(channel: ApduChannel)
        throws {
        try super.init(aid: NbtConstants.configuratorAid,
                       channel: channel)
    }

    /// Selects the NBT configurator application.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func selectConfiguratorApplication() async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSetConfig.logMessageSelectAidConfigurator)
        return try await send(command:
            commandBuilderConfig.selectConfiguratorApplication())
    }

    /// Issues a set configuration data command. This command can be used to set a
    /// specific product configuration in the NBT configurator application.
    ///
    /// - Parameters:
    ///   - tag: Tag to set configuration: Configuration tags enumeration can
    ///   be used.
    ///   - data: Configuration data
    ///
    /// - Returns:  Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func setConfigData(tag: UInt16,
                              data: UInt8) async throws -> NbtApduResponse {
        let dataArr = Data([data])
        getLogger()?.debug(header: self.headerTag, message: NbtCommandSetConfig.logMessageSetConfigurator)
        return try await send(command: commandBuilderConfig.setConfigData(
            tag: tag, data: dataArr))
    }

    /// Issues a set configuration data command. This command can be used to set a
    /// specific product configuration in the NBT configurator application.
    ///
    /// - Parameters:
    ///   - tag: Tag to set configuration: Configuration tags enumeration can
    ///   be used.
    ///   - data: Configuration data
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func setConfigData(tag: UInt16,
                              data: Data) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSetConfig.logMessageSetConfigurator)
        return try await send(command: commandBuilderConfig.setConfigData(
            tag: tag, data: data))
    }

    /// Issues a get configuration data command. This command can be used to get a
    /// specific product configuration from the NBT configurator application.
    ///
    /// - Parameter tag: Tag to retrieve configuration: Configuration tags enumeration
    /// can be used.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func getConfigData(tag: UInt16) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSetConfig.logMessageGetConfigurator)
        return try await send(command: commandBuilderConfig.getConfigData(
            tag: tag))
    }

    /// Issues a get configuration data command. This command can be used to get a
    /// specific product configuration from the NBT configurator application.
    ///
    /// - Parameter tag: Tag to retrieve configuration: Configuration tags enumeration
    /// can be used.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func getConfigDataBytes(tag: UInt16) async throws -> Data {
        let response: NbtApduResponse = try await getConfigData(tag: tag)

        if response.getSW() == ApduResponse.swNoError {
            var parser: TlvParser
            if let apduResponseData = response.getData() {
                parser = TlvParser(structure: apduResponseData)
            } else {
                throw NbtError(description: errInvalidResponse)
            }

            let tlvs: [Any] = try parser.parseDgiTlvStructure()
            if tlvs.isEmpty {
                return Data()
            }

            guard let tlv6f: Tlv = tlvs[0] as? Tlv
            else {
                throw ApduError(description:
                    errUnableToReadTagData)
            }
            return tlv6f.getValues()
        } else {
            throw ApduError(description:
                errUnableToReadTagData)
        }
    }

    /// Sends a command and waits for response. This method adds an
    /// error message to the APDU response object if response status word
    /// is not 9000.
    ///
    /// - Parameter command: APDU command containing command.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    private func send(command: ApduCommand) async throws -> NbtApduResponse {
        let apduResponse: ApduResponse =
            try await super.send(apduCommand: command)
        return try NbtApduResponse(response: apduResponse,
                                   ins: command.getIns())
    }
}
