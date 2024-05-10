// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Interface for the NDEF record payload decoder.
public enum RecordDecoderUtils {
    /// Error message if the payload is invalid.
    private static let errMessageInvalidLength =
        "Invalid length of payload data"

    /// Error message if unable to decode the payload.
    public static let errMessageInvalidPayload =
        "Unable to decode payload data"

    /// Default function to validate the input payload.
    ///
    /// - Parameters:
    ///   - payload: NDEF record payload data
    ///   - minExpectedLength: Minimum expected payload length
    ///
    /// - Throws: ``NdefError`` Invalid payload length
    ///
    public static func validatePayload(payload: Data,
                                       minExpectedLength: Int) throws {
        if payload.count < minExpectedLength {
            throw NdefError(description:
                RecordDecoderUtils.errMessageInvalidLength)
        }
    }
}
