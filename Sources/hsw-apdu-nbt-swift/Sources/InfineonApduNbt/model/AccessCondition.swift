// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Model class for storing the access condition and password ID.
public class AccessCondition {
    /// Password field mask
    public static let passwordIdMask: UInt8 = 0x1f

    /// Password ID (Optional when password is not required.)
    private var passwordId: UInt8 = 0

    /// Enumeration for access condition of file access policy.
    private var accessConditionType: AccessConditionType

    /// Constructor to create instance with access condition type.
    /// This constructor should be used, if access condition is not password-protected type.
    ///
    /// - Parameter accessConditionType: Enumeration for access condition
    ///
    /// - Throws: Throws an FAP error, if access condition is password-protected type.
    ///
    public init(accessConditionType: AccessConditionType) throws {
        if accessConditionType == .passwordProtected {
            throw FileAccessPolicyError(
                description: NbtErrorCodes.errInvalidAccessConditionType)
        }
        self.accessConditionType = accessConditionType
    }

    /// Constructor to create instance with password ID. This constructor should be
    /// used, if access condition is password-protected.
    ///
    /// - Parameter passwordId: Password ID
    ///
    public init(passwordId: UInt8) {
        self.passwordId = AccessCondition.passwordIdMask & passwordId
        self.accessConditionType = .passwordProtected
    }

    /// Returns the password access condition byte.
    ///
    /// - Returns: Returns the password access condition byte.
    ///
    /// - Throws: Throws an FAP error, if access condition is password-protected type &
    /// password id is zero
    ///
    public func getAccessByte() throws -> UInt8 {
        if accessConditionType == .passwordProtected &&
            passwordId == 0 {
            throw FileAccessPolicyError(
                description: NbtErrorCodes.errInvalidAccessConditionType)
        }
        if accessConditionType == .passwordProtected {
            return passwordId | AccessConditionType.passwordProtected.rawValue
        }
        return accessConditionType.rawValue
    }

    /// Getter for the password ID
    ///
    /// - Returns: Returns the byte value of password ID.
    ///
    public func getPasswordId() -> UInt8 { return passwordId }

    /// Getter for the access condition type
    ///
    /// - Returns: Returns the access condition type.
    ///
    public func getAccessConditionType() -> AccessConditionType {
        return accessConditionType
    }
}
