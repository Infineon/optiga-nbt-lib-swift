// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Error class for certificate encode and decode related errors.
public class CertificateError: Error {
    /// The error description.
    public var localizedDescription: String

    /// Creates a new Certificate Error with the specified description.
    ///
    /// - Parameter description: The description of the error.
    ///
    public init(description: String) {
        self.localizedDescription = description
    }
}
