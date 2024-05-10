// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Container class for an application (or package) Aid.
public class Aid {
    /// Reference of Aid bytes
    private var aidData: Data

    /// Constructor for Aid object.
    ///
    /// - Parameter aid: Aid bytes associated with application (or package).
    ///
    /// - Throws: UtilsError if Aid object cannot be converted to a byte array
    ///
    public init(aid: Any) throws {
        self.aidData = try Aid.toData(aid: aid)
    }

    /// Checks if the Aid bytes of an application equal the Aid bytes of this application.
    ///
    /// - Parameter aid: Aid to be checked for identity.
    ///
    /// - Returns: true if Aid bytes are identical, false otherwise.
    ///
    /// - Throws: UtilsError if Aid object cannot be converted to a byte array
    ///
    public func equals(aid: Any) throws -> Bool {
        do {
            return try self.aidData.elementsEqual(Aid.toData(aid: aid))
        } catch _ as UtilsError {
            return false
        }
    }

    /// Converts an object into Aid bytes.
    ///
    /// - Parameter aid: object representing Aid bytes.
    ///
    /// - Returns: byte array with Aid bytes or null if conversion fails.
    ///
    /// - Throws: UtilsError if Aid object cannot be converted to a byte array
    ///
    public static func toData(aid: Any) throws -> Data {
        if let aidObj = aid as? Aid {
            return aidObj.aidData
        }
        return try Utils.toData(stream: aid)
    }
}
