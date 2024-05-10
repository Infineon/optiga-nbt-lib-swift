// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Error class for NDEF message and NDEF record related error.
public class NdefError: Error {
    /// The error description.
    public var localizedDescription: String
    public let underlyingError: Swift.Error?

    /// Creates a new Certificate Error with the specified description.
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
    ///   - message: Message for the error.
    ///   - error: Error stack.
    ///
    public init(description: String,
                error: Error) {
        self.localizedDescription = description
        self.underlyingError = error
    }
}
