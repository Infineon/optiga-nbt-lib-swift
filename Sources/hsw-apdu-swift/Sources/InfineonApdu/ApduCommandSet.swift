// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonLogger

/// Collection of commands supported by any operating system on a smart card.
open class ApduCommandSet {
    /// Maximum expected response data length
    private let maxLe = 255

    /// Aid of application
    private var aid: Aid

    /// Reference of APDU channel
    private var apduChannel: ApduChannel

    /// Marker if application is currently selected
    private var selected = false

    /// Expected response data length
    private let leAny = 256

    /// Constructor of basic Apdu command handler.
    ///
    /// - Parameters:
    ///   - aid: Aid of application associated with command handler.
    ///   - channel: Reference of communication channel associated with
    ///   command handler.
    ///
    ///  - Throws: ``ApduError`` if Aid object cannot be converted into a byte array.
    ///
    public init(aid: Any,
                channel: ApduChannel) throws {
        // set communication channel
        apduChannel = channel

        if let aID = aid as? Aid {
            // store object as is
            self.aid = aID
        } else {
            // build application identifier
            self.aid = try Aid(aid: ApduUtils.toData(stream: aid))
        }
    }

    /// Set the application identifier associated with this command handler.
    ///
    /// - Parameter aid: Reference of Aid to be set.
    ///
    /// - Throws: ``ApduError`` if Aid object cannot be converted into a byte array.
    ///
    public func setAid(aid: Any) throws {
        if let aID = aid as? Aid {
            // store object as is
            self.aid = aID
        } else {
            // build application identifier
            self.aid = try Aid(aid: ApduUtils.toData(stream: aid))
        }
    }

    /// Gets the instance of logger
    ///
    /// - Returns: Logger to log different levels of messages
    ///
    public func getLogger() -> ILogger? {
        return apduChannel.getLogger()
    }

    /// Return Aid associated with command  handler.
    ///
    /// - Returns: Aid object associated with command  handler.
    ///
    public func getAid() -> Aid {
        return aid
    }

    /// Return connection status of channel.
    ///
    /// - Returns: True if connection to server is established.
    ///
    public func isConnected() -> Bool {
        return apduChannel.isConnected()
    }

    /// Connect to the card.
    ///
    /// - Parameter data: Data to determine connection type
    ///
    /// - Returns: ATR of card.
    ///
    /// - Throws: ``ApduError`` if connecting to card fails.
    ///
    public func connect(data: Data?) async throws -> Data {
        return try await apduChannel.connect(data: data)
    }

    /// Disconnect from terminal.
    ///
    /// - Throws: ``ApduError`` if disconnecting from card fails.
    ///
    public func disconnect() throws {
        try apduChannel.disconnect()
    }

    /// Send command and wait for card response. This method modifies the CLA byte to
    /// set the logical channel bits if the object is assigned to a supplementary
    /// logical channel. For the base channel no modification is performed.
    ///
    /// - Parameter apduCommand: Object containing command.
    ///
    /// - Returns: Card response.
    ///
    /// - Throws: ``ApduError`` in case of communication problems or if
    /// command object cannot be converted into a byte stream.
    ///
    open func send(apduCommand: Any) async throws -> ApduResponse
    {
        if let command = apduCommand as? ApduCommand {
            return try await apduChannel.send(apduCommand: command)
        } else {
            return try await apduChannel.send(apduCommand: ApduCommand(
                command: ApduUtils.toData(stream: apduCommand)))
        }
    }
}
