// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu
import InfineonUtils

/// Collection of commands supported by the NBT application.
public class NbtCommandSet: ApduCommandSet {
    /// Logs a create password message.
    private static let logMessageCreatePassword: String =
        "Create a new password"

    /// Logs a select file message.
    private static let logMessageSelectFile: String =
        "Select by file with File ID and R/W password"

    /// Logs an update binary message.
    private static let logMessageUpdateBinary: String =
        "Update binary"

    /// Logs a read binary message.
    private static let logMessageReadBinary: String =
        "Read binary"

    /// Logs a delete password message.
    private static let logMessageDeletePassword: String =
        "Delete password"

    /// Logs a get data message.
    private static let logMessageGetData: String =
        "Get data"

    /// Logs a change password message.
    private static let logMessageChangePassword: String =
        "Change password"

    /// Logs a select AID message.
    private static let logMessageSelectAid: String =
        "Select AID"

    /// Logs an authenticate tag message.
    private static let logMessageAuthenticateTag: String =
        "Authenticate Tag"

    /// Logs a select File ID message.
    private static let logMessageSelectFid: String =
        "Select fileID"

    /// Logs a read FAP file message.
    private static let logMessageReadFapFile: String =
        "Read FAP file"

    /// Logs an update FAP file message.
    private static let logMessageUpdateFapFile: String =
        "Update FAP file"

    /// Logs an unblock password message.
    private static let logMessageUnblockPassword: String =
        "Unblock Password"

    private let errInvalidApduResponse = "Invalid Apdu Response"
    
    /// Private tag for the logger message header
    private let headerTag = "NbtCommandSet"

    /// Instance of NBT command builder.
    private var nbtCommandBuilder: NbtCommandBuilder = .init()

    /// Constructor of NBT command set to configure the reference of communication
    /// channel and log channel number.
    ///
    /// - Parameter channel: Reference of communication channel associated with
    ///   command handler.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public init(channel: ApduChannel) throws {
        try super.init(aid: NbtConstants.aid,
                       channel: channel)
    }

    /// Selects the NBT application.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func selectApplication() async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageSelectAid)
        return try await send(command: nbtCommandBuilder.selectApplication())
    }

    /// Selects the elementary file (EF) with the File ID.
    ///
    /// - Parameter fileId: 2-byte File ID of the file to be selected.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func selectFile(fileId: UInt16) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageSelectFid)
        return try await send(command: nbtCommandBuilder.selectFile(fileId: fileId))
    }

    /// Selects the elementary file (EF) with the File ID, optionally this might
    /// contain the 4-byte password value to authenticate to perform password
    /// protected Read/Write operations on the selected EF.
    ///
    /// - Parameters:
    ///   - fileId:  2-byte File ID of the file to be selected.
    ///   - readPassword: 4-byte password for read operation (Optional- Null if not required)
    ///   - writePassword: 4-byte password for write operation (Optional- Null if
    ///   not required)
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func selectFile(fileId: UInt16,
                           readPassword: Data?,
                           writePassword: Data?) async throws -> NbtApduResponse
    {
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageSelectFile)
        return try await send(command: nbtCommandBuilder.selectFile(fileId: fileId,
                                                                    readPasswordBytes: readPassword,
                                                                    writePasswordBytes: writePassword))
    }

    /// Reads the binary data from the currently selected elementary file.
    ///
    /// - Parameters:
    ///   - offset:  2-byte start offset from which the data should be read.
    ///   - expectedLen: Expected length of data
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func readBinary(offset: UInt16,
                           expectedLen: UInt16) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageReadBinary)
        return try await send(command: nbtCommandBuilder.readBinary(offset: offset,
                                                                    expectedLen: expectedLen))
    }

    /// Creates a new password. If create password command is password-protected
    /// then the password to authenticate will be passed in the command data as
    /// master password.
    ///
    /// - Parameters:
    ///   - masterPassword: 4-byte master password for verification.
    ///   Required if this password is already used with
    ///   password-protected access condition (Optional).
    ///   - newPasswordId: 5-bit new password ID is of range '01' to '1F'.
    ///   - newPassword: 4-byte new password.
    ///   - passwordResponse: 2-byte password response.
    ///   - passwordLimit: 2-byte password try limit, it should be in range of
    ///   ‘0001’ to ‘7FFF’.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func createPassword(masterPassword: Data?,
                               newPasswordId: UInt8,
                               newPassword: Data,
                               passwordResponse: UInt16,
                               passwordLimit: UInt16) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageCreatePassword)
        return try await send(command: nbtCommandBuilder.createPassword(
            masterPassword: masterPassword,
            newPasswordId: newPasswordId,
            newPassword: newPassword,
            passwordResponse: passwordResponse,
            passwordLimit: passwordLimit))
    }

    /// Creates a new password. If create password command is password-protected
    /// then the password to authenticate will be passed in the command data as
    /// master password.
    ///
    /// - Parameters:
    ///   - masterPassword: 4-byte master password for verification.
    ///   Required if this password is already used with
    ///   password-protected access condition (Optional).
    ///   - newPasswordId: 5-bit new password ID is of range '01' to '1F'.
    ///   - newPassword: 4-byte new password.
    ///   - passwordResponse: 2-byte password response.
    ///   - passwordLimit: 2-byte password try limit, it should be in range of
    ///   ‘0001’ to ‘7FFF’.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func createPassword(masterPassword: String?,
                               newPasswordId: UInt8,
                               newPassword: String,
                               passwordResponse: UInt16,
                               passwordLimit: UInt16) async throws -> NbtApduResponse {
        return try await createPassword(
            masterPassword: ApduUtils.toData(stream: masterPassword),
            newPasswordId: newPasswordId,
            newPassword: ApduUtils.toData(stream: newPassword),
            passwordResponse: passwordResponse,
            passwordLimit: passwordLimit)
    }

    /// Deletes an existing password. When the FAP file update operation
    /// is allowed with ALWAYS access condition, then no
    /// need to authenticate with the master password.
    ///
    /// - Parameter passwordId: 1-byte password ID is of range '01' to '1F'.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func deletePassword(passwordId: UInt8) async throws -> NbtApduResponse {
        return try await deletePassword(passwordId: passwordId,
                                        masterPassword: nil)
    }

    /// Updates the binary data into the currently selected elementary file.
    ///
    /// - Parameters:
    ///   - offset: 2-byte start offset from which the data should be updated.
    ///   - data: Binary data to be updated.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func updateBinary(offset: UInt16,
                             data: Data) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageUpdateBinary)
        return try await send(command: nbtCommandBuilder.updateBinary(
            offset: offset,
            data: data))
    }

    /// Deletes an existing password, where FAP file is password-protected.
    ///
    /// //////Note:////// Note that the status word of the command is not checked by this method.
    ///
    /// - Parameters:
    ///   - passwordId: 1-byte password ID is of range '01' to '1F'.
    ///   - masterPassword: 4-byte master password to authenticate FAP file.
    ///   Required if this password is already used with
    ///   password-protected access condition (Optional).
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func deletePassword(passwordId: UInt8,
                               masterPassword: Data?) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageDeletePassword)
        return try await send(command: nbtCommandBuilder.deletePassword(
            passwordId: passwordId,
            masterPassword: masterPassword))
    }

    /// Issues a get data command to retrieve the NBT application specific
    /// information like applet version and available memory. GET_DATA constants
    /// that can be passed with an example: get data (TAG_AVAILABLE_MEMORY,
    /// TAG_APPLET_VERSION)
    ///
    /// - Parameter tag: 2-byte tag used as reference control parameter (P1P2).
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: ``NbtError``  Throws the NBT error, in case of data can not
    /// parse into parser.
    ///
    public func getData(tag: UInt16) async throws -> NbtApduResponse {
        let getDataCommand: ApduCommand = try nbtCommandBuilder.getData(tag: tag)
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageGetData)
        return try await send(command: getDataCommand)
    }

    /// Issues a get data command to retrieve the available memory information.
    ///
    /// - Returns: Returns the available memory.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: Throws the ``NbtError``, if failed to parse the
    /// available memory.
    ///
    public func getDataAvailableMemory() async throws -> AvailableMemory {
        let apduResponse: NbtApduResponse = try await getData(
            tag: NbtConstants.tagAvailableMemory)

        if let apduResponseData: Data = apduResponse.getData() {
            return try AvailableMemory(data: apduResponseData)
        } else {
            throw NbtError(description: errInvalidApduResponse)
        }
    }

    /// Issues a get data command to retrieve the applet version information.
    ///
    /// - Returns: Returns the applet version.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: Throws the ``NbtError``, if failed to parse the
    /// applet version.
    ///
    public func getDataAppletVersion() async throws -> AppletVersion {
        let apduResponse: NbtApduResponse = try await getData(
            tag: NbtConstants.tagAppletVersion)

        if let apduResponseData: Data = apduResponse.getData() {
            return try AppletVersion(data: apduResponseData)
        } else {
            throw NbtError(description: errInvalidApduResponse)
        }
    }

    /// Changes an existing password with a new password. If the FAP file update
    /// operation is password protected, the master password is required to
    /// change the password.
    ///
    /// - Parameters:
    ///   - passwordId: 5-bit password ID of the password to be changed.
    ///   - newPassword: New password to be updated.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func changePassword(passwordId: UInt8,
                               newPassword: Data) async throws -> NbtApduResponse {
        return try await changePassword(masterPassword: nil,
                                        passwordId: passwordId,
                                        newPassword: newPassword)
    }

    /// Changes an existing password with a new password. If the FAP file update
    /// operation is password protected, the master password is required to
    /// change the password.
    ///
    /// - Parameters:
    ///   - masterPassword: Master password is required,
    ///   if the FAP file update operation is password protected.
    ///   - passwordId: 5-bit password ID of the password to be changed
    ///   - newPassword: New password to be updated.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func changePassword(masterPassword: Data?,
                               passwordId: UInt8,
                               newPassword: Data) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageChangePassword)
        return try await send(command: nbtCommandBuilder.changePassword(
            masterPassword: masterPassword,
            passwordId: passwordId,
            newPassword: newPassword))
    }

    /// Issues an authenticate tag command, which generates the signature on the
    /// challenge and can be used for brand protection use case in offline mode.
    ///
    /// - Parameter challenge: Data to be sent to authenticate.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func authenticateTag(challenge: Data) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageAuthenticateTag)
        return try await send(command: nbtCommandBuilder.authenticateTag(
            challenge: challenge))
    }

    /// Reads the binary data from the FAP file. When the FAP file read operation
    /// is allowed with ALWAYS access condition, then no need to authenticate
    /// with the master password we can pass null.
    ///
    /// - Parameter masterPassword: 4-byte master password for verification. Required if
    /// this password is already used with password-protected access condition (Optional).
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func readFapBytes(masterPassword: Data?) async throws -> NbtApduResponse {
        var apduResponse: NbtApduResponse

        apduResponse = try await selectFile(fileId: NbtConstants.fapFileId,
                                            readPassword: masterPassword,
                                            writePassword: nil)

        _ = try apduResponse.checkOK()
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageReadFapFile)
        return try await readBinary(offset: NbtConstants.offsetFileStart,
                                    expectedLen: NbtConstants.leAny)
    }

    /// Reads the binary data from the FAP file, when the FAP file read operation
    /// is allowed with ALWAYS access condition.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func readFapBytes() async throws -> NbtApduResponse {
        return try await readFapBytes(masterPassword: nil)
    }

    /// Reads the FAP file and returns the list of file access policies. When the
    /// FAP file update operation is allowed with ALWAYS access condition then no
    /// need to authenticate with the master password we can pass null.
    ///
    /// - Parameter masterPassword: 4-byte master password for verification. Required if
    /// this password is already used with password-protected access condition (Optional).
    ///
    /// - Returns: Returns the list of file access policies decoded from the FAP file
    /// bytes. Null if unable to read.
    ///
    /// - Throws: Throws an utility error, in case of issues in parsing the select
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: ``FileAccessPolicyError`` Throws an FAP error, if error in
    /// case of decoding of FAP file content decode.
    ///
    public func readFapList(masterPassword: Data?) async throws -> [FileAccessPolicy] {
        var apduResponse: NbtApduResponse
        apduResponse = try await readFapBytes(masterPassword: masterPassword)
        _ = try apduResponse.checkOK()

        if let apduResponseData: Data = apduResponse.getData() {
            return try FapDecoder.instance().decode(policyBytes:
                apduResponseData)
        } else {
            throw NbtError(description: errInvalidApduResponse)
        }
    }

    /// Reads the FAP file and returns the list of file access policies, when the
    /// FAP file update operation is allowed with ALWAYS access condition.
    ///
    /// - Returns: Returns the list of file access policies decoded from the FAP file
    /// bytes. Null if unable to read.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: ``FileAccessPolicyError`` Throws an FAP error, if error in case
    /// of decoding of FAP file content decode.
    ///
    public func readFapList() async throws -> [FileAccessPolicy] {
        return try await readFapList(masterPassword: nil)
    }

    /// Updates the binary data to the FAP file. When the FAP file update operation
    /// is allowed with ALWAYS access condition, then no need to authenticate with
    /// the master password we can pass null.
    ///
    /// - Parameters:
    ///   - fileId: 2-byte File ID for which access policy to be set.
    ///   - policyBytes: 4-byte access policy binary data to be updated.
    ///   - masterPassword: 4-byte master password for verification. Required if
    ///   this password is already used with password-protected access condition (Optional).
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func updateFapBytes(fileId: UInt16,
                               policyBytes: Data,
                               masterPassword: Data?) async throws -> NbtApduResponse
    {
        var apduResponse: NbtApduResponse

        try nbtCommandBuilder.validatePolicyBytes(policyBytes: policyBytes)

        apduResponse = try await selectFile(fileId: NbtConstants.fapFileId,
                                            readPassword: nil,
                                            writePassword: masterPassword)

        _ = try apduResponse.checkOK()

        apduResponse = try await updateBinary(
            offset: NbtConstants.offsetFileStart,
            data: Utils.concat(
                firstData: Utils.toData(
                    value: Int(fileId),
                    length: Int(NbtConstants.fileIdLength)),
                secondData: policyBytes))
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageUpdateFapFile)
        return apduResponse
    }

    /// Updates the binary data to the FAP file, when the FAP file update operation
    /// is allowed with ALWAYS access condition.
    ///
    /// - Parameters:
    ///   - fileId: 2-byte File ID for which access policy to be set.
    ///   - policyBytes: 4-byte access policy binary data to be updated.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func updateFapBytes(fileId: UInt16,
                               policyBytes: Data) async throws -> NbtApduResponse {
        return try await updateFapBytes(fileId: fileId,
                                        policyBytes: policyBytes,
                                        masterPassword: nil)
    }

    /// Updates the file access policy to the FAP file, when the FAP file update
    /// operation is allowed with ALWAYS access condition.
    ///
    /// - Parameter fapPolicy: Access policy to be updated.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    /// - Throws: ``FileAccessPolicyError`` Throws an FAP error,
    /// if unable to get access condition bytes.
    ///
    public func updateFap(fapPolicy: FileAccessPolicy) async throws -> NbtApduResponse {
        return try await updateFapBytes(fileId: fapPolicy.getFileId(),
                                        policyBytes: fapPolicy.getAccessBytes(),
                                        masterPassword: nil)
    }

    /// Updates the file access policy to the FAP file. When the FAP file update
    /// operation is allowed with ALWAYS access condition, then no need to
    /// authenticate with the master password we can pass null.
    ///
    /// - Parameters:
    ///   - fapPolicy: Access policy to be updated.
    ///   - masterPassword: 4-byte master password for verification. Required if
    ///   this password is already used with password-protected
    ///   access condition (Optional).
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    /// - Throws: ``FileAccessPolicyError`` Throws an FAP error,
    /// if unable to get access condition bytes.
    ///
    public func updateFap(fapPolicy: FileAccessPolicy,
                          masterPassword: Data?) async throws -> NbtApduResponse
    {
        return try await updateFapBytes(fileId: fapPolicy.getFileId(),
                                        policyBytes: fapPolicy.getAccessBytes(),
                                        masterPassword: masterPassword)
    }

    /// Unblocks a blocked password.
    ///
    /// - Parameter passwordId: Password ID for password to be unblocked.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func unblockPassword(passwordId: UInt8) async throws -> NbtApduResponse {
        return try await unblockPassword(passwordId: passwordId,
                                         masterPassword: nil)
    }

    /// Unblocks a blocked password.
    ///
    /// - Parameters:
    ///   - passwordId:  Password ID for password to be unblocked.
    ///   - masterPassword: Password to authenticate the FAP file, if it is password-protected.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    public func unblockPassword(passwordId: UInt8,
                                masterPassword: Data?) async throws -> NbtApduResponse {
        getLogger()?.debug(header: headerTag, message: NbtCommandSet.logMessageUnblockPassword)
        return try await send(command: nbtCommandBuilder.unblockPassword(
            passwordId: passwordId,
            masterPassword: masterPassword))
    }

    /// Reads the NDEF file with password and returns the NDEF message byte data.
    ///
    /// - Parameters:
    ///   - ndefFileId: 2-byte File ID of the NDEF file to be selected.
    ///   - readPassword: 4-byte password for read operation (Optional- Null if not required)
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func readNdefMessage(ndefFileId: UInt16,
                                readPassword: Data?) async throws -> NbtApduResponse {
        let apduResponse: NbtApduResponse = try await selectFile(
            fileId: ndefFileId,
            readPassword: readPassword,
            writePassword: nil)
        if !apduResponse.isSuccessSW() {
            return apduResponse
        }

        return try await recursiveReadNdefMessage(offset: NbtConstants.fileStartOffset,
                                                  totalBytesToRead: NbtConstants.maxLe)
    }

    /// Reads the NDEF file and returns the NDEF message byte data.
    ///
    /// - Parameter ndefFileId: 2-byte File ID of the NDEF file to be selected.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func readNdefMessageWithFileId(ndefFileId: UInt16) async throws -> NbtApduResponse {
        return try await readNdefMessage(ndefFileId: ndefFileId, readPassword: nil)
    }

    /// Reads the NDEF file with default NDEF File ID and
    /// password and returns the NDEF message byte data.
    ///
    /// - Parameter readPassword: 4-byte password for read
    /// operation (Optional- Null if not required)
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func readNdefMessageWithPassword(readPassword: Data?) async throws -> NbtApduResponse {
        return try await readNdefMessage(ndefFileId: NbtConstants.ndefFileId,
                                         readPassword: readPassword)
    }

    /// Reads the NDEF file with default NDEF File ID and password and returns the
    /// NDEF message byte data.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func readNdefMessage() async throws -> NbtApduResponse {
        return try await readNdefMessage(ndefFileId: NbtConstants.ndefFileId,
                                         readPassword: nil)
    }

    /// Updates the NDEF file with password and returns the NDEF message byte data.
    ///
    /// - Parameters:
    ///   - ndefFileId: 2-byte File ID of the NDEF file to be selected.
    ///   - writePassword: 4-byte password for write operation (Optional- Null if not required)
    ///   - dataBytes: Bytes to be written in the binary file.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func updateNdefMessage(ndefFileId: UInt16,
                                  writePassword: Data?,
                                  dataBytes: Data) async throws -> NbtApduResponse {
        let apduResponse: NbtApduResponse = try await selectFile(
            fileId: ndefFileId,
            readPassword: nil,
            writePassword: writePassword)

        if !apduResponse.isSuccessSW() {
            return apduResponse
        }
        return try await recursiveUpdateBinary(offset: NbtConstants.fileStartOffset,
                                               dataBytes: dataBytes)
    }

    /// Updates the NDEF file with password and returns the NDEF message byte data.
    ///
    /// - Parameters:
    ///   - writePassword: 4-byte password for write operation (Optional- Null if not required)
    ///   - dataBytes: Bytes to be written in the binary file.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func updateNdefMessage(writePassword: Data?,
                                  dataBytes: Data) async throws -> NbtApduResponse {
        return try await updateNdefMessage(ndefFileId: NbtConstants.ndefFileId,
                                           writePassword: writePassword,
                                           dataBytes: dataBytes)
    }

    /// Updates the NDEF file with password and return the NDEF message byte data.
    ///
    /// - Parameters:
    ///   - ndefFileId: 2-byte File ID of the NDEF file to be selected.
    ///   - dataBytes: Bytes to be written in the binary file.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func updateNdefMessage(ndefFileId: UInt16,
                                  dataBytes: Data) async throws -> NbtApduResponse {
        return try await updateNdefMessage(ndefFileId: ndefFileId,
                                           writePassword: nil,
                                           dataBytes: dataBytes)
    }

    /// Updates the NDEF file with password and returns the NDEF message byte data.
    ///
    /// - Parameter dataBytes: Bytes to be written in the binary file
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    public func updateNdefMessage(dataBytes: Data) async throws -> NbtApduResponse {
        return try await updateNdefMessage(ndefFileId: NbtConstants.ndefFileId,
                                           writePassword: nil,
                                           dataBytes: dataBytes)
    }

    /// Reads the NDEF binary file in recursive pattern.
    ///
    /// - Parameters:
    ///   - offset: Offset position for the read binary file.
    ///   - totalBytesToRead: Size of data to be read in bytes.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    private func recursiveReadNdefMessage(offset: UInt16,
                                          totalBytesToRead: UInt16) async throws -> NbtApduResponse {
        var newTotalBytesToRead: UInt16 = totalBytesToRead
        var newOffset: UInt16 = offset
        let totalBytesRemainsToRead: UInt16 = newTotalBytesToRead - newOffset
        var apduResponse: NbtApduResponse =
            try await readBinary(offset: newOffset,
                                 expectedLen: (totalBytesRemainsToRead > NbtConstants.maxLe) ?
                                     NbtConstants.maxLe : totalBytesRemainsToRead)

        if !apduResponse.isSuccessSW() {
            return apduResponse
        }

        // Calculates the total bytes to be read from fist two bytes of NDEF file.
        if newOffset == 0 {
            // Updates the total_bytes_to_read with first 2 bytes from file.
            if let apduResponseData: Data = apduResponse.getData() {
                newTotalBytesToRead = try Utils.getUINT16(data: apduResponseData,
                                                          offset: Int(NbtConstants.fileStartOffset))

                var dataLength: Int = apduResponse.getDataLength() - 2

                // If NDEF message size is less than the response length.
                if newTotalBytesToRead < (apduResponse.getDataLength()) {
                    dataLength = Int(newTotalBytesToRead)
                }

                var data: Data = Utils.extractData(data: apduResponseData,
                                                   offset: Int(NbtConstants.t4tNdefMsgStartOffset),
                                                   length: dataLength)

                data.append(Data([0x90, 0x00]))
                let apduResponse2: ApduResponse =
                    try ApduResponse(response: data,
                                     execTime: apduResponse.getExecutionTime())

                apduResponse = try NbtApduResponse(response: apduResponse2, ins: UInt8(0))

                // Calculates the next iteration expected length and offset.
                newOffset = newOffset + UInt16(dataLength) + 2

                // +2 for adding 2 bytes of length.
                newTotalBytesToRead += 2
            } else {
                throw NbtError(description: errInvalidApduResponse)
            }
        } else {
            // Calculates next iteration expected length and offset.
            newOffset += UInt16(apduResponse.getDataLength())
        }

        if newTotalBytesToRead > newOffset {
            let newApduResponse: NbtApduResponse =
                try await recursiveReadNdefMessage(offset: newOffset,
                                                   totalBytesToRead: newTotalBytesToRead)
            _ = try apduResponse.appendResponse(response: newApduResponse,
                                                execTime: 0)
        }

        return apduResponse
    }

    /// Updates the binary file in a loop.
    ///
    /// - Parameters:
    ///   - offset: Offset for write the binary file.
    ///   - dataBytes: Bytes to be written in the binary file.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    /// - Throws: UtilsError will be thrown if any issues in type conversions.
    ///
    private func recursiveUpdateBinary(offset: UInt16,
                                       dataBytes: Data) async throws -> NbtApduResponse {
        var newData: Data = dataBytes

        // Adding file size at the beginning of file data.
        if offset == 0 {
            let ndefFileSize: Data = try Utils.toData(stream: UInt16(newData.count))
            newData = Utils.concat(firstData: ndefFileSize,
                                   secondData: newData)
        }

        // Extracting block of data to be written.
        let totalRemainingDataSize: Int = newData.count - Int(offset)
        let dataBlock: Data =
            Utils.extractData(data: newData, offset: Int(offset),
                              length: (totalRemainingDataSize > NbtConstants.maxLc) ?
                                  Int(NbtConstants.maxLc) : totalRemainingDataSize)

        // Updates the sub set of data.
        let apduResponse: NbtApduResponse = try await updateBinary(offset: offset,
                                                                   data: dataBlock)
        if !apduResponse.isSuccessSW() {
            return apduResponse
        }

        // Calculates the next iteration expected offset and total remaining data
        // size.
        let newOffset = offset + UInt16(dataBlock.count)
        let newTotalRemainingDataSize = newData.count - Int(newOffset)

        // Next iteration is required or not.
        if newTotalRemainingDataSize > 0 {
            let newApduResponse: NbtApduResponse =
                try await recursiveUpdateBinary(offset: newOffset,
                                                dataBytes: newData)
            _ = try apduResponse.appendResponse(response: newApduResponse,
                                                execTime: 0)
        }
        return apduResponse
    }

    /// Sends a command and waits for response. This method modifies the
    /// APDU response by adding an error message if response status word
    /// is not 9000.
    ///
    /// - Parameter command: APDU command containing command.
    ///
    /// - Returns: Returns the response with status word.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command or
    /// communicating with the product.
    ///
    private func send(command: ApduCommand) async throws -> NbtApduResponse {
        let apduResponse: ApduResponse = try await super.send(apduCommand: command)
        return try NbtApduResponse(response: apduResponse, ins: command.getIns())
    }
}
