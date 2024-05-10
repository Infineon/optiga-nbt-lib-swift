// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// The NFC Forum well known local type (defined in [NDEF], [RTD]) for the Error
/// Record shall be "err" (in NFC binary encoding: 0x65, 0x72, 0x72). The Error
/// Record is included in a Handover Select Record to indicate that the handover
/// selector failed to successfully process the most recently received handover
/// request message. This record shall be used only in Handover Select record.
public class ErrorRecord: AbstractWellKnownTypeRecord {
    /// Defines the NFC Forum well known type (defined in [NDEF], [RTD])
    /// for the error record (in NFC binary encoding: 0x65, 0x72, 0x72).
    public static let errorRecordType = "err"

    /// A 1-byte field that indicates the specific type of error that caused the
    /// handover selector to return the error record.
    private var errorReason: UInt8?

    /// A sequence of octets that provide additional information about the
    /// conditions that caused the handover selector to enter an erroneous state.
    private var errorData: Data?

    /// Constructor to create a new error record.
    ///
    /// - Parameters:
    ///   - errorReason: A 1-byte field indicates the specific type of error
    ///   that caused the handover selector to return the Error record.
    ///   - errorData: A sequence of octets provides additional information
    ///   about the conditions that caused the handover selector
    ///   to enter an erroneous state.
    ///
    public init(errorReason: UInt8, errorData: Data) {
        super.init(recordType: ErrorRecord.errorRecordType)
        setErrorReason(errorReason: errorReason)
        setErrorData(errorData: errorData)
    }

    /// Sets the error reason.
    ///
    /// - Parameter errorReason: The error reason
    ///
    public func setErrorReason(errorReason: UInt8) {
        self.errorReason = errorReason
    }

    /// Sets a sequence of octets that provide additional information
    /// about the conditions that caused the handover selector to enter an
    /// erroneous state.
    ///
    /// - Parameter errorData: The error data
    ///
    public func setErrorData(errorData: Data) {
        self.errorData = errorData
    }

    /// Gets the error reason.
    ///
    /// - Returns: Returns the error reason.
    ///
    public func getErrorReason() -> UInt8? {
        return errorReason
    }

    /// Gets a sequence of octets that provide additional information about
    /// the conditions that caused the handover selector to enter an erroneous state.
    ///
    /// - Returns: Returns the error data.
    ///
    public func getErrorData() -> Data? {
        return errorData
    }
}
