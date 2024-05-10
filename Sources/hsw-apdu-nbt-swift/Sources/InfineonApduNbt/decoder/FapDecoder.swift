// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// To decode the file access policy (FAP) file content.
public final class FapDecoder {
    /// Private FAP policy decoder object
    private static var fapPolicyDecoder: FapDecoder?

    /// Length of the FAP policy bytes
    private let fapByteLength: Int = 6

    /// Offset for FAP bytes
    private static let fapByteStartOffset: Int = 0

    /// File ID bytes length
    public static let fileIdLength: Int = 2

    /// Private constructor for FAP policy decoder
    private init() {
        // Private constructor
    }

    /// Static method to instantiate the FAP policy decoder object.
    ///
    /// - Returns: Returns the instance of FAP decoder.
    ///
    public static func instance() -> FapDecoder {
        if fapPolicyDecoder == nil {
            fapPolicyDecoder = FapDecoder()
        }
        return fapPolicyDecoder!
    }

    /// Returns the decoded file access policies from the FAP data bytes.
    ///
    /// - Parameter policyBytes: File access policy data bytes
    ///
    /// - Returns: Returns the list of decoded file access policies.
    ///
    /// - Throws: ``FileAccessPolicyError`` Throws an FAP error, in case error
    /// in decoding policy data bytes
    ///
    public func decode(policyBytes: Data) throws -> [FileAccessPolicy] {
        if policyBytes.count % fapByteLength != 0 {
            throw FileAccessPolicyError(description:
                NbtErrorCodes.errInvalidByteLength)
        }

        var arrayListFapPolicies = [FileAccessPolicy]()
        do {
            let data = Data(policyBytes[FapDecoder.fapByteStartOffset...])
            var index = 0
            while index < data.count {
                let fileIdData = try Utils.getDataFromStream(
                    length: FapDecoder.fileIdLength,
                    data: data, index: &index)

                let fileId = try Utils.getUINT16(
                    data: fileIdData,
                    offset: FapDecoder.fapByteStartOffset)

                let accessConditionI2CR = try FapDecoder.getFileAccessCondition(
                    accessByte: Utils.getUInt8WithIndex(index: index, data: data))
                index += 1

                let accessConditionI2CW = try FapDecoder.getFileAccessCondition(
                    accessByte: Utils.getUInt8WithIndex(index: index, data: data))
                index += 1

                let accessConditionNfcR = try FapDecoder.getFileAccessCondition(
                    accessByte: Utils.getUInt8WithIndex(index: index, data: data))
                index += 1

                let accessConditionNfcW = try FapDecoder.getFileAccessCondition(
                    accessByte: Utils.getUInt8WithIndex(index: index, data: data))
                index += 1

                let fapPolicy = FileAccessPolicy(
                    fileId: fileId,
                    accessConditionI2CR: accessConditionI2CR,
                    accessConditionI2CW: accessConditionI2CW,
                    accessConditionNfcR: accessConditionNfcR,
                    accessConditionNfcW: accessConditionNfcW)
                arrayListFapPolicies.append(fapPolicy)
            }
        } catch {
            throw FileAccessPolicyError(description: NbtErrorCodes.errReadByte)
        }
        return arrayListFapPolicies
    }

    /// Returns the access condition from the FAP access byte.
    ///
    /// - Parameter accessByte: Access policy data byte
    ///
    /// - Returns: Returns the access condition from  byte
    ///
    /// - Throws: Throws an FAP error, if unable to insatiate the access condition object.
    ///
    private static func getFileAccessCondition(
        accessByte: UInt8) throws -> AccessCondition {
        if accessByte == AccessConditionType.always.rawValue {
            return try AccessCondition(
                accessConditionType: AccessConditionType.always)
        } else if accessByte == AccessConditionType.never.rawValue {
            return try AccessCondition(
                accessConditionType: AccessConditionType.never)
        } else {
            return AccessCondition(passwordId: accessByte)
        }
    }
}
