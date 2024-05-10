// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Abstract MIME type record is an abstract class, which represents a parent
/// container class for all media-type records as defined in the RFC 2046 [RFC
/// 2046].
open class AbstractMimeTypeRecord: AbstractRecord {
    /// Constructor to create the media-type record as defined in the RFC 2046 [RFC
    /// 2046].
    ///
    /// - Parameter recordType: Record type of string (For example, "T").
    ///
    public init(recordType: String) {
        super.init(recordType: recordType, tnf: NdefConstants.tnfMediaType)
    }
}
