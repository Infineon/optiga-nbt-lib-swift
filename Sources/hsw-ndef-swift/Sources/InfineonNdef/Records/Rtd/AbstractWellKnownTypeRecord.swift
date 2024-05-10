// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Abstract well known type record is an abstract class, which represents a
/// parent container class for all NFC Forum well known type records defined in
/// the NFC Forum RTD specification [NFC RTD].
open class AbstractWellKnownTypeRecord: AbstractRecord {
    /// Constructor to create the NFC Forum well known type record.
    ///
    /// - Parameter recordType: Record type of string (For example, "T").
    ///
    public init(recordType: String) {
        super.init(recordType: recordType, tnf: NdefConstants.tnfWellKnownType)
    }
}
