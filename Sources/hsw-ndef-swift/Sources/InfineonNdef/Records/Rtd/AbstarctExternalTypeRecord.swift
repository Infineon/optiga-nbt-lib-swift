// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Abstract external type record is an abstract class which represents a parent
/// container class for all NDEF external type records as defined in the NFC
/// Forum record type definition (RTD) specification [NFC RTD]. A NDEF external
/// type record is a user-defined value, based on rules in the NFC Forum record
/// type definition specification. The payload does not need to follow any
/// specific structure like it does in other well known records types.
open class AbstarctExternalTypeRecord: AbstractRecord {
    /// Constructor to create the NFC Forum external type [NFC RTD] record.
    ///
    /// - Parameter recordType: Record type of string (For example, "T").
    ///
    public init(recordType: String) {
        super.init(recordType: recordType,
                   tnf: NdefConstants.tnfExternalType)
    }
}
