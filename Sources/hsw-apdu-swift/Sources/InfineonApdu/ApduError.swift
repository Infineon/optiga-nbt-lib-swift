// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// An error class for Apdu related errors
public class ApduError: Error {
    /// The error description.
    public var localizedDescription: String

    /// Creates a new Apdu Error with the specified description.
    ///
    /// - Parameter description: The description of the error.
    ///
    public init(description: String) {
        self.localizedDescription = description
    }
}
