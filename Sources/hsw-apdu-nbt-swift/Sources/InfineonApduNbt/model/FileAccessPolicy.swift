// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Model class for storing the file access policy with respect to the File ID.
public class FileAccessPolicy {
    /// Constant defines the File ID length.
    private let fileIdLength: UInt16 = 2

    /// File ID for the file access policy.
    private var fileId: UInt16

    /// Access condition for the I2C write command.
    private var accessConditionI2CW: AccessCondition

    /// Access condition for the I2C read command.
    private var accessConditionI2CR: AccessCondition

    /// Access condition for the NFC write command.
    private var accessConditionNfcW: AccessCondition

    /// Access condition for the NFC read command.
    private var accessConditionNfcR: AccessCondition

    /// Constructor for creating an instance with the File ID and access condition.
    ///
    /// - Parameters:
    ///   - fileId:  2-byte File ID
    ///   - accessConditionI2CR: Access condition for the I2C read command.
    ///   - accessConditionI2CW: Access condition for the I2C write command.
    ///   - accessConditionNfcR: Access condition for the NFC read command.
    ///   - accessConditionNfcW: Access condition for the NFC write command.
    ///
    public init(fileId: UInt16,
                accessConditionI2CR: AccessCondition,
                accessConditionI2CW: AccessCondition,
                accessConditionNfcR: AccessCondition,
                accessConditionNfcW: AccessCondition) {
        self.fileId = fileId
        self.accessConditionI2CR = accessConditionI2CR
        self.accessConditionI2CW = accessConditionI2CW
        self.accessConditionNfcR = accessConditionNfcR
        self.accessConditionNfcW = accessConditionNfcW
    }

    /// Returns the data bytes of FAP policy with File ID.
    ///
    /// - Returns: Returns the data byte of FAP policy.
    ///
    /// - Throws: ``FileAccessPolicyError`` Throws an FAP error, if access
    /// condition is not password-protected.
    ///
    public func getBytes() throws -> Data {
        var data = Utils.toData(value: Int(fileId), length: Int(fileIdLength))
        try data.append(getAccessBytes())
        return data
    }

    /// Getter for File ID and returns the File ID.
    ///
    /// - Returns: Returns the File ID associated with the FAP policy.
    ///
    public func getFileId() -> UInt16 { return fileId }

    /// Returns the data bytes of the FAP access condition.
    ///
    /// - Returns: Returns the data bytes array of the FAP access condition.
    ///
    /// - Throws: ``FileAccessPolicyError`` Throws an FAP error, if access
    /// condition is not password-protected.
    ///
    public func getAccessBytes() throws -> Data {
        return try Data([accessConditionI2CR.getAccessByte(),
                         accessConditionI2CW.getAccessByte(),
                         accessConditionNfcR.getAccessByte(),
                         accessConditionNfcW.getAccessByte()])
    }
}
