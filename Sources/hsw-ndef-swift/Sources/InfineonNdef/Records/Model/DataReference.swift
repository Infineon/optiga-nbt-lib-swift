// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Data reference to point to another NDEF record.
public class DataReference {
    /// Data reference characters
    private var data: Data = Data()

    /// Constructor to create a new data reference model.
    ///
    /// - Parameter data: Data reference characters
    ///
    public init(data: Data) {
        self.data = data
    }

    /// Gets the data reference characters.
    ///
    /// - Returns: Returns the data reference characters.
    ///
    public func getData() -> Data? {
        return data
    }

    /// Gets the data reference characters length.
    ///
    /// - Returns: Returns the data reference characters length.
    ///
    public func getLength() -> Int? {
        return data.count
    }

    /// Sets the data reference characters.
    ///
    /// - Parameter data: Returns the data reference characters.
    ///
    public func setData(data: Data) {
        self.data = data
    }
}
