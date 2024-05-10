// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Class with static helper methods to make APDU functionality more convenient to implement.
public enum ApduUtils {
    /// Convert an object to a byte array. The object may either be a byte array, a hex string,
    /// an ApduCommand object or an ApduResponse object.
    ///
    /// - Parameter stream: Object containing byte stream data.
    ///
    /// - Returns: Byte array containing data stream.
    ///
    /// - Throws: ``ApduError`` if conversion could not be performed.
    ///
    public static func toData(stream: Any?) throws -> Data {
        // check if APDU command
        if let apduCommand = stream as? ApduCommand {
            return apduCommand.toData()
        }

        // check if APDU response
        if let apduResponse = stream as? ApduResponse {
            return apduResponse.toData()
        }

        if let aid = stream as? Aid {
            return try Aid.toData(aid: aid)
        }

        // try to convert string into byte array
        return try Utils.toData(stream: stream)
    }
}
