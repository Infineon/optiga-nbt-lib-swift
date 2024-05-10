// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu
import InfineonUtils

/// Collection of personalization commands supported by the NBT application.
public class NbtCommandSetPerso: ApduCommandSet {

    /// Logs a personalize data message
    private static let logMessagePersonalizeData: String =
        "Personalize data"

    /// Private tag for the logger message header
    private let headerTag = "NbtCommandSetConfig"

    /// Instance of personalization command builder for NBT application.
    private var persoCommandBuilder: NbtCommandBuilderPerso = .init()

    /// Constructor of NBT personalization command set to configure the reference
    /// of communication channel and log channel number.
    ///
    /// - Parameter channel: Reference of communication channel associated with
    ///   command handler.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public init(channel: ApduChannel)
        throws {
        try super.init(aid: NbtConstants.aid,
                       channel: channel)
    }

    /// Personalizes the data elements of the applet.
    ///
    /// - Parameters:
    ///   - dgi:  Data group identifier of the data to be
    ///   - personalizeData: Data to be personalized.
    ///
    /// **Note:** (Content of personalize data is not validated by this library or null error is validated.)
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func personalizeData(dgi: UInt16,
                                personalizeData: Data) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSetPerso.logMessagePersonalizeData)
        return try await send(command:
            persoCommandBuilder.personalizeData(
                dgi: dgi, personalizeData: personalizeData))
    }

    /// Finalizes the personalization state, thereby transitioning the secure
    /// element to operational state.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func finalizePersonalization() async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSetPerso.logMessagePersonalizeData)
        return try await send(
            command: persoCommandBuilder.finalizePersonalization())
    }

    /// Sends a command and waits for response. This method modifies the
    /// APDU response by adding an error message if response status word
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
        let apduResponse: ApduResponse = try await super.send(apduCommand: command)
        return try NbtApduResponse(response: apduResponse, ins: command.getIns())
    }
}
