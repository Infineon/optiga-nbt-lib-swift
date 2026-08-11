// SPDX-FileCopyrightText: Copyright (c) 2024-2026 Infineon Technologies AG
// SPDX-License-Identifier: MIT

import Foundation

/// Error class for FAP policy encode and decode related errors.
public class FileAccessPolicyError: Error {
    /// The error description.
    public var localizedDescription: String

    /// Creates a new FAP Error with the specified description.
    ///
    /// - Parameter description: The description of the error.
    ///
    public init(description: String) {
        self.localizedDescription = description
    }
}
