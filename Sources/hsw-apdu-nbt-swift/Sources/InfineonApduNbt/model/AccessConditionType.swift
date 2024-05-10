// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Enumeration defines the access condition of file access policy.
public enum AccessConditionType: UInt8 {
    /// No password verification is required, if the file is configured with
    /// ALWAYS access condition.
    case always = 0x40

    /// Access is not allowed to the file, if file is configured with NEVER
    /// access condition.
    case never = 0x00

    /// Access is allowed only after password verification, if the file is
    /// configured with passwordProtected access condition. This
    /// configuration byte has to be appended with password ID (5 bits).
    case passwordProtected = 0x80
}
