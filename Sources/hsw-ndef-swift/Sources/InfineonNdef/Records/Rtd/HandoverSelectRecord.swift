// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// The NFC local type name for the action is 'Hs' (0x48, 0x73). Handover select
/// record is a record that stores the alternative carriers that the Handover
/// Selector selected from the list provided in the previous Handover Request
/// Message.
public class HandoverSelectRecord: AbstractWellKnownTypeRecord {
    /// Defines the NFC Forum Well Known Type (defined in [NDEF], [RTD])
    /// for the handover select record (in NFC binary encoding: 0x48, 0x73).
    public static let handoverSelectType = "Hs"

    /// Major version number of the connection handover specification that conforms
    /// to specification version 1.5.
    public static let majorVersion: UInt8 = 0x01

    /// Minor version number of the connection handover specification that conforms
    /// to specification version 1.5.
    public static let minorVersion: UInt8 = 0x05

    /// A 4-bit field contains the major version number of the connection
    /// handover specification.
    private var majorVersion: UInt8?

    /// A 4-bit field contains the minor version number of the connection
    /// handover specification.
    private var minorVersion: UInt8?

    /// List of the handover carrier record provides a unique identification of an
    /// alternative carrier technology.
    private var alternativeCarrierRecords: [AlternativeCarrierRecord] =
        .init()

    /// The optional error record to indicate that the handover selector failed to
    /// successfully process the most recently received handover request message.
    private var errorRecord: ErrorRecord?

    /// Constructor to create a new handover select record with default major and
    /// minor version number of the connection handover specification.
    public init() {
        super.init(recordType: HandoverSelectRecord.handoverSelectType)
        setMinorVersion(minorVersion: HandoverSelectRecord.minorVersion)
        setMajorVersion(majorVersion: HandoverSelectRecord.majorVersion)
    }

    /// Constructor to create a new handover select record with default major and
    /// minor version number of the connection handover specification.
    ///
    /// - Parameter errorRecord: The optional error record
    ///
    public init(errorRecord: ErrorRecord) {
        super.init(recordType: HandoverSelectRecord.handoverSelectType)
        setMinorVersion(minorVersion: HandoverSelectRecord.minorVersion)
        setMajorVersion(majorVersion: HandoverSelectRecord.majorVersion)
        setErrorRecord(errorRecord: errorRecord)
    }

    /// Gets the major version of the connection handover specification.
    ///
    /// - Returns: Returns the major version of the connection
    /// handover specification.
    ///
    public func getMajorVersion() -> UInt8? { return majorVersion }

    /// Sets the major version of the connection handover specification.
    ///
    /// - Parameter majorVersion: Major version of the connection
    /// handover specification.
    ///
    public func setMajorVersion(majorVersion: UInt8) {
        self.majorVersion = majorVersion
    }

    /// Gets the minor version of the connection handover specification.
    ///
    /// - Returns: Returns the minor version of the connection
    /// handover specification.
    ///
    public func getMinorVersion() -> UInt8? { return minorVersion }

    /// Sets the minor version of the connection handover specification.
    ///
    /// - Parameter minorVersion: Minor version of the connection
    /// handover specification.
    ///
    public func setMinorVersion(minorVersion: UInt8) {
        self.minorVersion = minorVersion
    }

    /// Gets the list of alternative carrier records.
    ///
    /// - Returns: Returns the list of alternative carrier records.
    ///
    public func getAlternativeCarrierRecords() -> [AlternativeCarrierRecord] {
        return alternativeCarrierRecords
    }

    /// Sets the list of alternative carrier records.
    ///
    /// - Parameter alternativeCarrierRecords: The list of alternative carrier records.
    ///
    public func setAlternativeCarrierRecords(
        alternativeCarrierRecords: [AlternativeCarrierRecord]) {
        self.alternativeCarrierRecords = alternativeCarrierRecords
    }

    /// Adds the alternative carrier record.
    ///
    /// - Parameter alternativeCarrierRecord: The alternative carrier record.
    ///
    public func addAlternativeCarrierRecord(
        alternativeCarrierRecord: AlternativeCarrierRecord) {
        alternativeCarrierRecords.append(alternativeCarrierRecord)
    }

    /// Gets the error record (optional).
    ///
    /// - Returns: Returns the optional error record.
    ///
    public func getErrorRecord() -> ErrorRecord? { return errorRecord }

    /// Sets the error record (optional).
    ///
    /// - Parameter errorRecord: The optional error record
    ///
    public func setErrorRecord(errorRecord: ErrorRecord) {
        self.errorRecord = errorRecord
    }
}
