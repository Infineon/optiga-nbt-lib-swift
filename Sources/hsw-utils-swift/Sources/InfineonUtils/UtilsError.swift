// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// An error class for Utils related error
public class UtilsError: Error {
    /// The error description.
    public var localizedDescription: String

    /// Creates a new Utils Error with the specified description.
    ///
    /// - Parameter description: The description of the error.
    /// 
    public init(description: String) {
        self.localizedDescription = description
    }
}
