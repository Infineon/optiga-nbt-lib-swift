// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Protocol for a generic synchronous communication channel.
/// An example for this type of channel is a channel to a smart card via a terminal.
public protocol IChannel {
    /// Request access to communication port either exclusively or shared with other processes.
    ///
    /// - Parameter exclusive: If true exclusive access to this channel is requested.
    ///
    /// - Throws: ``ChannelError`` if opening the channel failed.
    ///
    func open(exclusive: Bool) throws

    /// Release communication port.
    ///
    /// - Throws: ``ChannelError`` if releasing the communication port failed.
    ///
    func close() throws

    /// Establish connection to server.
    ///
    /// - Parameter request: Optional request data to be used for connecting
    /// to server or null if no data required.
    ///
    /// - Returns: Returns the connection result.
    ///
    /// - Throws: ``ChannelError`` if the communication port connection failed.
    ///
    func connect(request: Data?) async throws -> Data

    /// Close connection to server.
    ///
    /// - Parameter request: Optional request data to be used for
    /// closing the connection or null if no data required.
    ///
    /// - Throws: ``ChannelError`` if disconnecting failed.
    ///
    func disconnect(request: Data?) throws

    /// Reset communication channel.
    ///
    /// - Parameter request: Optional request data to be used for
    /// resetting the connection or null if no data required.
    ///
    /// - Throws: ``ChannelError`` if reset request failed.
    ///
    func reset(request: Data?) async throws

    /// Send a byte stream via the channel and return response stream.
    ///
    /// - Parameter stream: Byte array with stream to be sent.
    ///
    /// - Returns: Byte array with received response steam.
    ///
    /// - Throws: ``ChannelError`` if any communication problem occurred.
    ///
    func transmit(stream: Data) async throws -> Data

    /// Return port status of channel.
    ///
    /// - Returns: True if communication port is opened.
    ///
    func isOpen() -> Bool

    /// Return connection status of channel.
    ///
    /// - Returns: True if connection to server is established.
    ///
    func isConnected() -> Bool

    /// Return friendly name of channel.
    ///
    /// - Returns: Friendly name of channel.
    ///
    func getName() -> String
}
