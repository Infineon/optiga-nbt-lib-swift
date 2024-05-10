// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu
import InfineonUtils

/// Command builder to build the APDU commands supported by the NBT applet.
public class NbtCommandBuilder {

    /// Index of parameter 1
    private let p1Index: Int = 0

    /// Index of parameter 2
    private let p2Index: Int = 1

    /// Error message for invalid input tag
    private let errProcessInputTag = "Failed to process the input tag"

    /// Error message for invalid password length
    private let errIncorrectPasswordLength = "Incorrect password length"

    /// Error message for invalid master password length
    private let errLengthOfMasterPassword = "Length of master password should be 4."

    /// Builds the select application command for the NBT applet.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func selectApplication() throws -> ApduCommand {
        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insSelect,
                               param1: NbtConstants.p1SelectApplication,
                               param2: NbtConstants.p2Default,
                               data: Data(NbtConstants.aid),
                               lengthExpected: Int(NbtConstants.leAny))
    }

    /// Builds the select elementary file command. This command is used to select
    /// the personalized elementary file (EF).
    /// In case of select by File ID without password verification data (lc=0x02),
    /// applet will ignore any Le value that is no response will be sent by the
    /// applet even if any Le value is present in select command.
    ///
    /// - Parameter fileId: 2-byte File ID of the file to be selected.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func selectFile(fileId: UInt16) throws -> ApduCommand {
        let commandData: Data = try ApduUtils.toData(stream: fileId)
        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insSelect,
                               param1: NbtConstants.p1Default,
                               param2: NbtConstants.p2SelectFirst,
                               data: commandData,
                               lengthExpected: Int(NbtConstants.leAbsent))
    }

    /// Builds the select file command to select an elementary file. This command
    /// is used to select the personalized EF, optionally this might contain the
    /// 4-byte password value to authenticate to perform password protected
    /// Read/Write operations on the selected EF.
    ///
    /// - Parameters:
    ///   - fileId: 2-byte File ID of the file to be selected.
    ///   - readPasswordBytes: 4-byte password for read operation (Optional)
    ///   - writePasswordBytes: 4-byte password for write operation (Optional)
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func selectFile(fileId: UInt16,
                           readPasswordBytes: Data?,
                           writePasswordBytes: Data?) throws -> ApduCommand {
        try NbtCommandBuilder.validatePasswordLength(passwordBytes: readPasswordBytes)
        try NbtCommandBuilder.validatePasswordLength(passwordBytes: writePasswordBytes)

        var commandData: Data = try ApduUtils.toData(stream: fileId)

        if let mReadPasswordBytes = readPasswordBytes {
            commandData.append(NbtConstants.tagPwdRead)
            commandData.append(NbtConstants.pwdLength)
            commandData.append(mReadPasswordBytes)
        }

        if let mWritePasswordBytes = writePasswordBytes {
            commandData.append(NbtConstants.tagPwdWrite)
            commandData.append(NbtConstants.pwdLength)
            commandData.append(mWritePasswordBytes)
        }

        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insSelect,
                               param1: NbtConstants.p1Default,
                               param2:NbtConstants.p2SelectFirst,
                               data: commandData,
                               lengthExpected: Int(NbtConstants.leAny))
    }

    /// Builds the update binary command. This command is used to update the binary
    /// data from the currently selected elementary file.
    ///
    /// - Parameters:
    ///   - offset: 2-byte start offset from which the data should be updated.
    ///   - data: Binary data to be updated
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func updateBinary(offset: UInt16,
                             data: Data) throws -> ApduCommand {
        let offsetBytes: Data = try Utils.toData(stream: offset)

        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insUpdateBinary,
                               param1: offsetBytes[p1Index],
                               param2: offsetBytes[p2Index],
                               data: data,
                               lengthExpected: Int(NbtConstants.leAbsent))
    }

    /// Builds the read binary command. This command is used to read the binary
    /// data from the currently selected elementary file.
    ///
    /// - Parameters:
    ///   - offset:  2-byte start offset from which the data should be read.
    ///   - expectedLen: Expected length of data
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func readBinary(offset: UInt16,
                           expectedLen: UInt16) throws -> ApduCommand {
        let offsetBytes: Data = try Utils.toData(stream: offset)

        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insReadBinary,
                               param1: offsetBytes[p1Index],
                               param2: offsetBytes[p2Index],
                               data: NbtConstants.lcNotPresent,
                               lengthExpected: Int(expectedLen))
    }

    /// Builds the authenticate tag command. This command is used to generate the
    /// signature on the challenge sent by host, which can be used for brand
    /// protection use case in offline mode.
    ///
    /// - Parameter challenge: Data to be sent to authenticate.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func authenticateTag(challenge: Data) throws -> ApduCommand {
        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insAuthenticateTag,
                               param1: NbtConstants.p1Default,
                               param2:  NbtConstants.p2Default,
                               data: challenge,
                               lengthExpected: Int(NbtConstants.leAny))
    }

    /// Builds the create password command, This command is used to create a new
    /// password. If the FAP file is password protected then the master password
    /// to authenticate will be needed in the command data as master password.
    ///
    /// - Parameters:
    ///   - masterPassword: 4-byte master password to authenticate FAP file,
    ///   if the FAP file is password protected.
    ///   - newPasswordId: 1-byte new password ID is of range from '01' to
    ///   '1F'.
    ///   - newPassword:  4-byte new password
    ///   - passwordResponse: 2-byte success response, which will be sent on
    ///   successful password verification.
    ///   - passwordLimit: 2-byte password try limit, it should be in range of
    ///   ‘0001’ to ‘7FFF’.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func createPassword(masterPassword: Data?,
                               newPasswordId: UInt8,
                               newPassword: Data,
                               passwordResponse: UInt16,
                               passwordLimit: UInt16) throws -> ApduCommand {
        try NbtCommandBuilder.validatePasswordLength(passwordBytes: masterPassword)
        try NbtCommandBuilder.validatePasswordLength(passwordBytes: newPassword)

        var commandData: Data = try NbtCommandBuilder.prepareCreatePasswordCommandData(
            passwordId: newPasswordId, newPassword: newPassword,
            passwordResponse: passwordResponse,
            passwordLimit: passwordLimit)

        if let mMasterPassword = masterPassword {
            commandData = Utils.concat(firstData: mMasterPassword,
                                       secondData: commandData)
        }

        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insCreatePwd,
                               param1: NbtConstants.p1Default,
                               param2:  NbtConstants.p2Default,
                               data: commandData,
                               lengthExpected: Int(NbtConstants.leAbsent))
    }

    /// Builds the delete password command. This command is used to delete the
    /// created password. If the FAP file is password protected then the password
    /// to authenticate will be needed in the command data as master password.
    ///
    /// - Parameters:
    ///   - passwordId: 1-byte new password ID is of range '01' to '1F'.
    ///   - masterPassword: 4-byte master password to authenticate FAP file
    ///   (Optional).
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func deletePassword(passwordId: UInt8,
                               masterPassword: Data?) throws -> ApduCommand {
        try NbtCommandBuilder.validatePasswordLength(passwordBytes: masterPassword)

        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insDeletePwd,
                               param1: NbtConstants.p1Default,
                               param2: passwordId,
                               data: masterPassword,
                               lengthExpected: Int(NbtConstants.leAbsent))
    }

    /// Builds the get data command. This command is used to retrieve NBT
    /// application specific information like applet version and available memory.
    ///
    /// - Parameter tag: 2-byte tag used as reference control parameter
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    /// - Throws: ``NbtError`` Throws the NBT error, if failed to process the
    /// input tag.
    ///
    public func getData(tag: UInt16) throws -> ApduCommand {
        var offsetBytes: Data
        do {
            offsetBytes = try Utils.toData(stream: tag)
        } catch let error as UtilsError {
            throw NbtError(description: errProcessInputTag, error: error)
        }
        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insGetData,
                               param1: offsetBytes[p1Index],
                               param2: offsetBytes[p2Index],
                               data: NbtConstants.lcNotPresent,
                               lengthExpected: Int(NbtConstants.leAny))
    }

    /// Builds the change password command.
    ///
    /// - Parameters:
    ///   - masterPassword: Password to authenticate FAP file if it is password
    ///   protected
    ///   - passwordId:  5-bit password ID of the password to be changed
    ///   - newPassword: New password to be changed.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func changePassword(masterPassword: Data?,
                               passwordId: UInt8,
                               newPassword: Data) throws -> ApduCommand {
        var data = Data()
        if newPassword.count != NbtConstants.passwordLength {
            throw ApduError(description: errIncorrectPasswordLength)
        }

        if let mMasterPassword = masterPassword {
            if mMasterPassword.count != NbtConstants.passwordLength {
                throw ApduError(description: errIncorrectPasswordLength)
            }
            data.append(mMasterPassword)
            data.append(newPassword)
        } else {
            data = newPassword
        }

        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insChangePassword,
                               param1: NbtConstants.p1Default,
                               param2: NbtConstants.p2ChangePwd |
                                   (passwordId & NbtConstants.passwordIdMask),
                               data: data,
                               lengthExpected: Int(NbtConstants.leAbsent))
    }

    /// Method to validate parameters and prepare the create password
    /// command data byte array.
    ///
    /// - Parameters:
    ///   - passwordId: 1-byte new password ID is of range from '01' to
    ///   '1F'.
    ///   - newPassword: 4-byte new password.
    ///   - passwordResponse: 2-byte password response.
    ///   - passwordLimit: 2-byte password try limit, it should be in range of
    ///   ‘0001’ to ‘7FFF’.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    private static func prepareCreatePasswordCommandData(
        passwordId: UInt8,
        newPassword: Data,
        passwordResponse: UInt16,
        passwordLimit: UInt16) throws -> Data {
        var commandData = Data([passwordId])
        commandData.append(newPassword)
        try commandData.append(ApduUtils.toData(stream: passwordResponse))
        try commandData.append(ApduUtils.toData(stream: passwordLimit))
        return commandData
    }

    /// Method to validate the password bytes.
    ///
    /// - Parameter passwordBytes: Password bytes to be validated.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    private static func validatePasswordLength(passwordBytes: Data?) throws {
        if let mPasswordBytes = passwordBytes, mPasswordBytes.count != NbtConstants.pwdLength {
            throw ApduError(description: NbtErrorCodes.errRPwdLen)
        }
    }

    /// Builds the unblock password command.
    ///
    /// - Parameters:
    ///   - passwordId: Password ID for password to be unblocked.
    ///   - masterPassword: Password to authenticate FAP file if it is password
    ///   protected.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func unblockPassword(passwordId: UInt8,
                                masterPassword: Data?) throws -> ApduCommand {
        if let mMasterPassword = masterPassword, mMasterPassword.count != NbtConstants.passwordLength {
            throw ApduError(description: errLengthOfMasterPassword)
        }

        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insUnblockPassword,
                               param1: NbtConstants.p1Default,
                               param2: passwordId & NbtConstants.idMaskBits,
                               data: masterPassword,
                               lengthExpected: Int(NbtConstants.leAbsent))
    }

    /// Method to validate the policy bytes.
    ///
    /// - Parameter policyBytes: Policy bytes
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func validatePolicyBytes(policyBytes: Data) throws {
        if policyBytes.count != NbtConstants.policyFieldLength {
            throw ApduError(description: NbtErrorCodes.errPolicyBytesLen)
        }
    }
}
