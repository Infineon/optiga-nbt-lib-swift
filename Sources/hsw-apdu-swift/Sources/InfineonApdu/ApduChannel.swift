// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonChannel
import InfineonLogger

/// Communication channel for APDU structured data packages.
/// The APDUs can be pre- and post processed by multiple services
/// which apply logical channel information or secure messaging.
public class ApduChannel {
    /// Reference to synchronous communication channel
    private var channel: IChannel

    /// Reference to logger
    private var logger: ILogger?

    /// Marker if communication channel has been opened by this instance
    private var openDone = false

    /// Create an APDU based logical channel.
    ///
    /// - Parameters:
    ///   - channel: Synchronous communication channel.
    ///   - logger: Logger to log different levels of messages
    ///
    public init(channel: IChannel, logger: ILogger?) {
        // set channel
        self.channel = channel
        self.logger = logger
    }

    /// Get communication channel associated with logger.
    ///
    /// - Returns: reference of communication channel.
    ///
    public func getChannel() -> IChannel {
        return channel
    }

    /// Gets the instance of logger
    ///
    /// - Returns: Logger to log different levels of messages
    ///
    public func getLogger() -> ILogger? {
        return logger
    }

    /// Return connection status of channel.
    ///
    /// - Returns: true if connection to server is established.
    ///
    public func isConnected() -> Bool {
        return channel.isConnected()
    }

    /// Connect to the card
    ///
    /// - Parameter data: Data to be used for connect
    /// (e.g. SHARED / EXCLUSIVE or DIRECT mode)
    ///
    /// - Returns: ATR of card.
    ///
    /// - Throws: ``ApduError`` if connecting fails for some reason.
    ///
    public func connect(data: Data?) async throws -> Data {
        // check if channel is open
        if !channel.isOpen() {
            // open channel
            try channel.open(exclusive: false)
            openDone = true
        }
        // connect to card
        return try await channel.connect(request: data)
    }

    /// Disconnect from terminal.
    ///
    /// - Throws: ``ApduError`` if disconnect fails for some reason.
    ///
    public func disconnect() throws {
        // do nothing if not open
        if channel.isOpen() {
            // disconnect if connected
            if channel.isConnected() {
                try channel.disconnect(request: nil)
            }

            // check if channel was opened by this instance
            if openDone {
                // release channel
                openDone = false
                try channel.close()
            }
        }
    }

    /// Send APDU command and receive response. If enabled, this takes care of
    /// handling T=0 protocol related APDUs like sending GET RESPONSE commands or
    /// enveloping extended length APDUs.
    ///
    /// - Parameter apduCommand: APDU command to be sent
    ///
    /// - Returns: APDU response received from card.
    ///
    /// - Throws: ``ApduError`` in case of communication problems.
    ///
    public func send(apduCommand: ApduCommand) async throws -> ApduResponse {
        logger?.debug(header: "APDU command", data: apduCommand.toData())
        let response = try await channel.transmit(stream: apduCommand.toData())
        // send the command
        let apduResponse = try ApduResponse(response: response, execTime: 0)
        logger?.debug(header: "APDU response", data: apduResponse.toData())
        return apduResponse
    }
}
