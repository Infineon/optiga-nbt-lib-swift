// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Error class for NBT encode and decode related errors.
public class NbtError: Error {
    /// The error description.
    public var localizedDescription: String
    // Error stack.
    public let underlyingError: Swift.Error?

    /// Creates a new Nbt Error with the specified description.
    ///
    /// - Parameter description: The description of the error.
    ///
    public init(description: String) {
        self.localizedDescription = description
        self.underlyingError = nil
    }

    /// Constructs an error with the error message and error stack.
    ///
    /// - Parameters:
    ///   - description: Message for the error.
    ///   - error: Error stack.
    ///
    public init(description: String,
                error: Error) {
        self.localizedDescription = description
        self.underlyingError = error
    }
}
