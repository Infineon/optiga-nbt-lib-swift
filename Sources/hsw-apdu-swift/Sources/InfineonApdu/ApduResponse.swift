// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Stores the APDU responses. The response consists of response data (optional) and
/// a status word (mandatory).
open class ApduResponse {
    /// Status word indicating successful operation
    public static let swNoError: UInt16 = 0x9000

    /// Byte array containing response data and status word
    private var apduResponseData: Data

    /// Command execution time
    private var execTime: Int64

    /// Build a response from a byte data stream.
    ///
    /// - Parameters:
    ///   - response: Byte data stream containing card response.
    ///   - execTime: Command execution time in nanoseconds
    ///
    /// - Throws: ``ApduError`` if conversion of response object into byte array fails.
    ///
    public init(response: Any, execTime: Int64) throws {
        apduResponseData = try ApduUtils.toData(stream: response)
        self.execTime = execTime

        // check if valid response
        if apduResponseData.count < 2 {
            // build dummy response
            apduResponseData = Data(count: 2)
        }
    }

    /// Append new response to existing response.
    /// This method is useful if the response data has to be
    /// concatenated from the content of multiple APDU responses (GET RESPONSE).
    /// The status word of the existing response will be replaced by the status word
    /// of the new response. The new execution time will be added to
    /// the existing execution time to form an overall response time.
    /// Returns a reference to 'this' to allow simple concatenation of operations.
    ///
    /// - Parameters:
    ///   - response: New response to be appended to existing response.
    ///   - execTime: Execution time in nanoseconds for the new response fragment
    ///
    /// - Returns: Reference to 'this' to allow simple concatenation of operations.
    ///
    /// - Throws: ``ApduError`` in case response fragment cannot
    /// be converted into a byte array.
    ///
    public func appendResponse(response: Any,
                               execTime: Int64) throws -> ApduResponse {
        // build byte array from new response and determine byte length
        let newResponse: Data = try ApduUtils.toData(stream: response)
        let length: Int = newResponse.count

        // add execution time
        self.execTime += execTime

        if length >= 2 {
            // append response data and overwrite status word of existing response
            apduResponseData.count = apduResponseData.count + length - 2
            _ = Utils.dataCopy(src: newResponse,
                               srcOffset: 0,
                               dest: &apduResponseData,
                               destOffset: apduResponseData.count - length,
                               length: length)
        }
        return self
    }

    /// Check if status word is swNoError (9000).
    ///
    /// - Returns: Reference to this. This allows to concatenate checks and other
    /// operations in one source code line.
    ///
    /// - Throws: ``ApduError`` if received status word is not 9000.
    ///
    public func checkOK() throws -> ApduResponse {
        return try checkSW(statusWord: Int(ApduResponse.swNoError))
    }

    /// Check if status word is swNoError (9000).
    ///
    /// - Returns: Reference to this. This allows to concatenate checks and other
    /// operations in one source code line.
    ///
    /// - Throws: ``ApduError`` if received status word is not 9000.
    ///
    public func checkStatus() throws -> ApduResponse {
        return try checkSW(statusWord: Int(ApduResponse.swNoError))
    }

    /// Check if status word is equal to the presented value.
    ///
    /// - Parameter statusWord: Expected status word. Note that only the
    /// lower 16 bits are evaluated.
    ///
    /// - Returns: Reference to 'this'. This allows to concatenate checks and other
    /// operations in one source code line.
    ///
    /// - Throws: ``ApduError`` if received status word is not expected.
    ///
    public func checkSW(statusWord: Int) throws -> ApduResponse {
        if (statusWord & 0xffff) != getSW() {
            throw ApduError(description: String(
                format: "Unexpected status word %02X", getSW()))
        }
        return self
    }

    /// Gets the combined status word - SW1 and SW2
    ///
    /// - Returns: Status word as 2 bytes / UINT16
    ///
    public func getSW() -> UInt16 {
        let lastTwoBytes = Data(apduResponseData.suffix(2).reversed())
        let result: UInt16 = lastTwoBytes.withUnsafeBytes { $0.load(as: UInt16.self) }
        return result
    }

    /// Get response data array.
    ///
    /// - Returns: Data bytes containing the response data.
    ///
    public func getData() -> Data? {
        return apduResponseData.prefix(apduResponseData.count - 2)
    }

    /// Gets the status word in hex format
    ///
    /// - Returns: Status word as hex string
    ///
    public func getSWString() -> String {
        let sw1: UInt8 = apduResponseData[apduResponseData.count - 2]
        let sw2: UInt8 = apduResponseData[apduResponseData.count - 1]
        return String(format: "%02X ", sw1) + String(format: "%02X ", sw2)
    }

    /// Checks whether the status word indicates SUCCESS
    ///
    /// - Returns: Flag indicating success (true) or failure (false)
    ///
    open func isSuccessSW() -> Bool {
        return getSW() == ApduResponse.swNoError
    }

    /// Return byte array representation of response data.
    ///
    /// - Returns: Byte array containing response and status word.
    ///
    public func toData() -> Data {
        return apduResponseData
    }

    /// Return command execution time in nano seconds. Depending on
    /// the underlying reader hardware the execution time may contain overhead
    /// times like transmission etc.
    ///
    /// - Returns: Command execution time.
    ///
    public func getExecutionTime() -> Int64 {
        return execTime
    }

    /// Get length of response data.
    ///
    /// - Returns: Length of response data.
    ///
    public func getDataLength() -> Int {
        return apduResponseData.count - 2
    }
}
