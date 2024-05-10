// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Stores the error codes used in the NBT library.
public final class NbtErrorCodes {
    /// Incorrect LC value
    public static let incorrectLcLe: UInt16 = 0x6700

    /// Application or file is not found.
    public static let applicationOrFileNotFound: UInt16 = 0x6a82

    /// Wrong TLV data format for select file with password data.
    public static let selectFileWrongTlv: UInt16 = 0x6a80

    /// Incorrect parameters in the command data field.
    public static let incorrectDataParameters: UInt16 = 0x6a80

    /// Unknown or unsupported data group, data object.
    public static let unsupportedData: UInt16 = 0x6a88

    /// Use of condition is not satisfied. If during personalization of
    /// password, password ID already exists. If trying to personalize more
    /// than 28 passwords.
    public static let conditionsNotSatisfiedCreatePassword: UInt16 =
        0x6985

    /// Incorrect P1-P2
    public static let wrongP1P2: UInt16 = 0x6a86

    /// Security condition is not satisfied.
    public static let securityNotSatisfied: UInt16 = 0x6982

    /// CC file is updated for ‘02’ to ‘0E’ offset is not allowed.
    public static let updateAccessDenied: UInt16 = 0x6985

    /// Command is not allowed.
    public static let commandNotAllowed: UInt16 = 0x6986

    /// Conditions of use is not satisfied the password ID already present,
    /// when trying to personalize more than 28 passwords.
    public static let conditionsNotSatisfied: UInt16 = 0x6985

    /// Wrong data, invalid File ID, or format mismatch in the FAP policy.
    public static let incorrectData: UInt16 = 0x6a80

    /// Incorrect parameters in the command data field.
    public static let configSelectIncorrectData: UInt16 = 0x6a80

    /// Incorrect Lc value for the select configurator.
    public static let configSelectIncorrectLc: UInt16 = 0x6700

    /// File or application is not found.
    public static let fileApplicationNotFound: UInt16 = 0x6a82

    /// Instruction byte is not supported.
    public static let insNotSupported: UInt16 = 0x6a00

    /// Class byte is not supported.
    public static let claNotSupported: UInt16 = 0x6a00

    /// Wrong length if Lc is present or if Le is not equal to ‘00’
    public static let getDataWrongLe: UInt16 = 0x6700

    /// Reference data is not found.
    public static let dataNotFound: UInt16 = 0x6a88

    /// Conditions of use is not satisfied.
    public static let conditionsUseUnsatisfied: UInt16 = 0x6985

    /// Lc is 0x00 in case of personalize data command.
    public static let invalidLcPersonalizeData: UInt16 = 0x6700

    /// Error message if read password length is not equal to 4-byte.
    public static let errRPwdLen: String = "Password should be 4 bytes"

    /// Error message if read policy byte length is not equal to 4-byte.
    public static let errPolicyBytesLen: String =
        "Policy bytes should be 4 bytes"

    /// Error message if data bytes are null.
    public static let errDataNull: String = "Input data bytes cannot be null"

    /// Error message if unable to read the bytes.
    public static let errSecurityAccessDeniedReadByte: String =
        "Security status not satisfied, if master password is applied for "
            + "read file and password is not verified."

    /// APDU error message if the status word is not known to the NBT applet.
    public static let errUnknownSw: String = "Unknown error code:"

    /// APDU error message if the status word is incorrect Lc value.
    public static let errIncorrectLcLeSelectFile: String =
        "Incorrect Lc/Le value"

    /// APDU error message if the status word is incorrect Lc value.
    public static let errIncorrectLcConfiguration: String =
        "Wrong length/Incorrect Lc value"

    /// APDU error message if file or application is not found.
    public static let errFileApplicationNotFound: String =
        "File or application is not found"

    /// APDU error message if wrong TLV data format for the select file with
    /// password data.
    public static let errIncorrectTlvSelectFile: String =
        "Wrong TLV data format for select file with password data."

    /// APDU error message if command is not allowed (EF is not selected).
    public static let errInvalidCommand: String =
        "Command not Allowed (EF is not selected)"

    /// APDU error message if offset is greater than the file size\n, if Le is
    /// absent\n, or if Le is coded on extended length.
    public static let errInvalidLength: String =
        "Offset is greater than the file size or If Le is absent or If Le is "
            + "coded on extended length"

    /// APDU error message if incorrect parameters P1-P2 or if P1-P2 is other than
    /// 00.
    public static let errInvalidP1P2: String = "Incorrect parameters P1-P2"

    /// APDU error message if the security status is not satisfied.
    public static let errSecurityStatusNotSatisfied: String =
        "Security status not satisfied"

    /// APDU error message if the password ID is not present.
    public static let errPasswordIdNotPresent: String =
        "Password ID not present"

    /// APDU error message if wrong length, if Lc is other than 09 and 0D bytes, or
    /// if Le is present.
    public static let errWrongLengthCreatePassword: String =
        "Wrong command length, if Lc is other than 09 and 0D bytes or if Le "
            + "is present"

    /// APDU error message if the conditions of use is not satisfied.
    public static let errConditionsNotSatisfiedCreatePassword: String =
        "Conditions of use is not satisfied Password ID already present or If "
            + "trying to personalize more than 28 passwords"

    /// APDU error message if incorrect data : Password response is 0000 and FFFF.
    public static let errIncorrectDataCreatePassword: String =
        "Incorrect Data : Password response is 0000 and FFFF. or password ID "
            + "is 00 or Password limit value is 0000 or 0080 to FFFE."

    /// APDU error message if security status is not satisfied, authentication with
    /// respective password is not successful, and file is locked (the access
    /// policy is never for write).
    public static let errSecurityAuthPasswordNotSuccessful: String =
        "Security condition not satisfied, authentication with respective "
            + "password is not successful and file is locked"

    /// APDU error message if CC file is updated for '02' to '0E'
    public static let errSecurityUpdateAccessDenied: String =
        "CC file is updated for '02' to '0E' offset is not allowed."

    /// APDU error message if CC file is updated with wrong data, invalid File ID or
    /// format mismatch in FAP policy.
    public static let errIncorrectData: String =
        "Wrong data, Invalid File ID or format mismatch in FAP policy"

    /// APDU error message if P1-P2 is greater than file size. Not applicable for
    /// FAP update.
    public static let errIncorrectP1P2: String =
        "Incorrect P1-P2: If P1-P2 is greater than file size. Not applicable "
            + "for FAP update."

    /// Error message for invalid length of FAP bytes.
    public static let errInvalidByteLength: String =
        "FAP Policy bytes must be 52 bytes"

    /// Error message for invalid access condition of FAP bytes.
    public static let errInvalidAccessConditionType: String =
        "Access condition should not of password-protected type"

    /// Error message if unable to read the bytes.
    public static let errReadByte: String =
        "Incorrect data, Failed to read the input stream of bytes"

    /// Error message if write password length is not equal to 4-byte.
    public static let errWPwdLen: String = "Unexpected write password length"

    /// APDU error message if security status is not satisfied, if master
    /// password is applied for FAP update and password is not verified.
    public static let errSecurityStatusNotCheckCreatePassword: String =
        "Security status not satisfied, if master password is applied for FAP "
            + "update and password is not verified."

    /// APDU error message if conditions are not satisfied.
    public static let errConditionsNotSatisfied: String =
        "Conditions of use is not satisfied: ECC private Key not personalized"

    /// APDU error message if conditions of use is not satisfied.
    public static let errConditionsUseUnsatisfied: String =
        "Conditions of use is not satisfied."

    /// APDU error message if LC or LE are wrong.
    public static let errWrongLcOrLeAuthTag: String =
        "Wrong length: If challenge length is 00, if Le is 00, or if Lc is coded "
            + "on extended length"

    /// APDU error message if change password conditions are not satisfied.
    public static let errChangeConditionNotSatisfied: String =
        "Conditions of use is not satisfied. If Master password is applied on "
            + "FAP update and master password is not present. If Master password is "
            + "blocked. If requested password is blocked in case of Change Password "
            + "command."

    /// APDU error message if P1-P2 are incorrect for change Password.
    public static let errChangePasswordWrongP1P2: String =
        "Incorrect P1-P2. If P1 is other than 00. If P2 has b8-b7 is other than "
            + "00 and 40"

    /// APDU error message if P1-P2 are other than 0x00.
    public static let errWrongP1P2AuthTag: String =
        "Incorrect parameters P1-P2, If P1-P2 are other than 00."

    /// APDU error message if password ID is not valid.
    public static let errDataNotFound: String =
        "Reference of data not found. Password ID not valid."

    /// APDU error message if Lc is invalid.
    public static let errInvalidLc: String =
        "Wrong length, if Lc is other than 04 and 08 in case of change password."

    /// APDU error message if unblock password conditions are not satisfied.
    public static let errUnblockConditionNotSatisfied: String =
        "Conditions of use is not satisfied. If Master password is applied on FAP "
            + "update and master password is not present. If Master password is "
            + "blocked. If requested password is blocked in case of Change Password "
            + "command."

    /// APDU error message if tag are incorrect for the unblock password.
    public static let errUnblockPasswordWrongP1P2: String =
        "Incorrect P1-P2. If P1 is other than 00. If P2 has b8-b7 is other than "
            + "00 and 40"

    /// APDU error message if P1-P2 are other than ‘DF3A’ and ‘DF3B’.
    public static let errWrongP1P2GetData: String = "Incorrect P1-P2"

    /// Wrong length, if Lc is present or if Le is not equal to ‘00’.
    public static let errWrongLeGetData: String =
        "Wrong length/Incorrect Lc value"

    /// Wrong data length for the personalize data command.
    public static let errWrongPersonalizeDataLength: String =
        "If FAP update content is other than 42 bytes, if Personalized password "
            + "length is other than 9 bytes, AES key length is other than 16 bytes, "
            + "ECC key length is other than 32 bytes, NDEF/Proprietary EF "
            + "personalization is out of file size, if Le is present, if additional "
            + "data is present in command, if password response is 0000 and FFFF"

    /// Wrong (data group identifier) DGI for the personalize data command.
    public static let errUnsupportedDataGroup: String =
        "Unknown or unsupported data group, data object"

    /// Conditions not satisfied for the personalize data command.
    public static let errConditionNotSatisfiedPersonalizeData: String =
        "If during personalization of password, password ID already exists, if "
            + "trying to personalize more than 28 passwords, if personalize data "
            + "command is sent during operational phase"

    /// Wrong Lc value as 0x00 for the personalize data command.
    public static let errWrongLcPersonalizeData: String =
        "Wrong length, if Lc is 00"

    /// Wrong value of P1 or P2 other than 0x0000 for the personalize data command.
    public static let errInvalidP1P2PersonalizeData: String =
        "Incorrect P1-P2, if P1-P2 is other than 00"

    /// Wrong value of P1 or P2 other than 0x0000 for the set and get
    /// configurations.
    public static let errInvalidP1P2Configuration: String =
        "Incorrect P1-P2"

    /// Incorrect parameters in the command data field.
    public static let errWrongDataConfigurator: String =
        "Incorrect parameters in the command data field"

    /// APDU error message if Lc value is incorrect.
    public static let errIncorrectLcConfigurator: String =
        "Wrong length, incorrect Lc value"

    /// Incorrect instruction byte is not supported.
    public static let errInvalidInsConfiguration: String =
        "Incorrect INS, instruction byte is not supported"

    /// Incorrect class byte is not supported.
    public static let errInvalidClaConfiguration: String =
        "Incorrect CLA, CLA value not supported"
    
    /// Private constructor to restrict access
    private init() {
        // Private constructor
    }
}
