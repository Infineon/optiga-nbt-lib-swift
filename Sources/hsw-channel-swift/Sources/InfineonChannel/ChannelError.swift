// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// An error class for Channel related errors
public class ChannelError: Error {
    /// The error description.
    public var localizedDescription: String

    /// Creates a new Channel Error with the specified description.
    ///
    /// - Parameter description: The description of the error.
    ///
    public init(description: String) {
        self.localizedDescription = description
    }
}
