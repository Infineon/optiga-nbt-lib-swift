// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu
import InfineonUtils

/// Container class for NBT APDU responses. This response consists of response
/// data (optional), status word (mandatory), and response error (optional).
public class NbtApduResponse: ApduResponse {
    /// Delimiter user to separate the key instruction byte + SW.
    static let delimiter: String = "_"

    /// Stores the list of error messages available in NBT applet.
    /// Key = instruction byte + SW, which is separated by a delimiter.
    private static var errorMap: [String: String] =
    {
        var dictionary = [String: String]()

        dictionary[String(NbtConstants.insSelect) +
            delimiter +
            String(NbtErrorCodes.incorrectLcLe)] =
            NbtErrorCodes.errIncorrectLcLeSelectFile

        dictionary[String(NbtConstants.insSelect) +
            delimiter +
            String(NbtErrorCodes.applicationOrFileNotFound)] =
            NbtErrorCodes.errFileApplicationNotFound

        dictionary[String(NbtConstants.insSelect) +
            delimiter +
            String(NbtErrorCodes.selectFileWrongTlv)] =
            NbtErrorCodes.errIncorrectTlvSelectFile

        dictionary[String(NbtConstants.insUpdateBinary) +
            delimiter +
            String(NbtErrorCodes.commandNotAllowed)] =
            NbtErrorCodes.errInvalidCommand

        dictionary[String(NbtConstants.insUpdateBinary) +
            delimiter +
            String(NbtErrorCodes.incorrectLcLe)] =
            NbtErrorCodes.errInvalidLength

        dictionary[String(NbtConstants.insUpdateBinary) +
            delimiter +
            String(NbtErrorCodes.securityNotSatisfied)] =
            NbtErrorCodes.errSecurityAuthPasswordNotSuccessful

        dictionary[String(NbtConstants.insUpdateBinary) +
            delimiter +
            String(NbtErrorCodes.updateAccessDenied)] =
            NbtErrorCodes.errSecurityUpdateAccessDenied

        dictionary[String(NbtConstants.insUpdateBinary) +
            delimiter +
            String(NbtErrorCodes.incorrectData)] =
            NbtErrorCodes.errIncorrectData

        dictionary[String(NbtConstants.insUpdateBinary) +
            delimiter +
            String(NbtErrorCodes.wrongP1P2)] =
            NbtErrorCodes.errIncorrectP1P2

        dictionary[String(NbtConstants.insReadBinary) +
            delimiter +
            String(NbtErrorCodes.commandNotAllowed)] =
            NbtErrorCodes.errInvalidCommand

        dictionary[String(NbtConstants.insReadBinary) +
            delimiter +
            String(NbtErrorCodes.incorrectLcLe)] =
            NbtErrorCodes.errInvalidLength

        dictionary[String(NbtConstants.insReadBinary) +
            delimiter +
            String(NbtErrorCodes.securityNotSatisfied)] =
            NbtErrorCodes.errSecurityAccessDeniedReadByte

        dictionary[String(NbtConstants.insCreatePwd) +
            delimiter +
            String(NbtErrorCodes.wrongP1P2)] =
            NbtErrorCodes.errInvalidLength

        dictionary[String(NbtConstants.insCreatePwd) +
            delimiter +
            String(NbtErrorCodes.securityNotSatisfied)] =
            NbtErrorCodes.errSecurityStatusNotSatisfied

        dictionary[String(NbtConstants.insCreatePwd) +
            delimiter +
            String(NbtErrorCodes.incorrectLcLe)] =
            NbtErrorCodes.errWrongLengthCreatePassword

        dictionary[String(NbtConstants.insCreatePwd) +
            delimiter +
            String(NbtErrorCodes.conditionsNotSatisfiedCreatePassword)] =
            NbtErrorCodes.errConditionsNotSatisfiedCreatePassword

        dictionary[String(NbtConstants.insCreatePwd) +
            delimiter +
            String(NbtErrorCodes.incorrectDataParameters)] =
            NbtErrorCodes.errIncorrectDataCreatePassword

        dictionary[String(NbtConstants.insDeletePwd) +
            delimiter +
            String(NbtErrorCodes.securityNotSatisfied)] =
            NbtErrorCodes.errSecurityStatusNotSatisfied

        dictionary[String(NbtConstants.insDeletePwd) +
            delimiter +
            String(NbtErrorCodes.unsupportedData)] =
            NbtErrorCodes.errPasswordIdNotPresent

        dictionary[String(NbtConstants.insAuthenticateTag) +
            delimiter +
            String(NbtErrorCodes.conditionsNotSatisfied)] =
            NbtErrorCodes.errConditionsNotSatisfied

        dictionary[String(NbtConstants.insAuthenticateTag) +
            delimiter +
            String(NbtErrorCodes.incorrectLcLe)] =
            NbtErrorCodes.errWrongLcOrLeAuthTag

        dictionary[String(NbtConstants.insAuthenticateTag) +
            delimiter +
            String(NbtErrorCodes.wrongP1P2)] =
            NbtErrorCodes.errWrongP1P2AuthTag

        dictionary[String(NbtConstants.insUnblockPassword) +
            delimiter +
            String(NbtErrorCodes.dataNotFound)] =
            NbtErrorCodes.errDataNotFound

        dictionary[String(NbtConstants.insUnblockPassword) +
            delimiter +
            String(NbtErrorCodes.incorrectLcLe)] =
            NbtErrorCodes.errInvalidLc

        dictionary[String(NbtConstants.insUnblockPassword) +
            delimiter +
            String(NbtErrorCodes.conditionsNotSatisfied)] =
            NbtErrorCodes.errUnblockConditionNotSatisfied

        dictionary[String(NbtConstants.insUnblockPassword) +
            delimiter +
            String(NbtErrorCodes.wrongP1P2)] =
            NbtErrorCodes.errUnblockPasswordWrongP1P2

        dictionary[String(NbtConstants.insGetData) +
            delimiter +
            String(NbtErrorCodes.wrongP1P2)] =
            NbtErrorCodes.errWrongP1P2GetData

        dictionary[String(NbtConstants.insGetData) +
            delimiter +
            String(NbtErrorCodes.getDataWrongLe)] =
            NbtErrorCodes.errWrongLeGetData

        dictionary[String(NbtConstants.insPersonalizeData) +
            delimiter +
            String(NbtErrorCodes.incorrectDataParameters)] =
            NbtErrorCodes.errWrongPersonalizeDataLength

        dictionary[String(NbtConstants.insPersonalizeData) +
            delimiter +
            String(NbtErrorCodes.unsupportedData)] =
            NbtErrorCodes.errUnsupportedDataGroup

        dictionary[String(NbtConstants.insPersonalizeData) +
            delimiter +
            String(NbtErrorCodes.conditionsNotSatisfied)] =
            NbtErrorCodes.errConditionNotSatisfiedPersonalizeData

        dictionary[String(NbtConstants.insPersonalizeData) +
            delimiter +
            String(NbtErrorCodes.invalidLcPersonalizeData)] =
            NbtErrorCodes.errWrongLcPersonalizeData

        dictionary[String(NbtConstants.insPersonalizeData) +
            delimiter +
            String(NbtErrorCodes.wrongP1P2)] =
            NbtErrorCodes.errInvalidP1P2PersonalizeData

        dictionary[String(NbtConstants.insSelect) +
            delimiter +
            String(NbtErrorCodes.configSelectIncorrectLc)] =
            NbtErrorCodes.errIncorrectLcConfigurator

        dictionary[String(NbtConstants.insSelect) +
            delimiter +
            String(NbtErrorCodes.configSelectIncorrectData)] =
            NbtErrorCodes.errWrongDataConfigurator

        dictionary[String(NbtConstants.insSetConfiguration) +
            delimiter +
            String(NbtErrorCodes.incorrectLcLe)] =
            NbtErrorCodes.errIncorrectLcConfiguration

        dictionary[String(NbtConstants.insSetConfiguration) +
            delimiter +
            String(NbtErrorCodes.conditionsUseUnsatisfied)] =
            NbtErrorCodes.errConditionsUseUnsatisfied

        dictionary[String(NbtConstants.insSetConfiguration) +
            delimiter +
            String(NbtErrorCodes.incorrectDataParameters)] =
            NbtErrorCodes.errWrongDataConfigurator

        dictionary[String(NbtConstants.insSetConfiguration) +
            delimiter +
            String(NbtErrorCodes.wrongP1P2)] =
            NbtErrorCodes.errInvalidP1P2Configuration

        dictionary[String(NbtConstants.insSetConfiguration) +
            delimiter +
            String(NbtErrorCodes.insNotSupported)] =
            NbtErrorCodes.errInvalidInsConfiguration

        dictionary[String(NbtConstants.insSetConfiguration) +
            delimiter +
            String(NbtErrorCodes.claNotSupported)] =
            NbtErrorCodes.errInvalidClaConfiguration

        dictionary[String(NbtConstants.insGetConfiguration) +
            delimiter +
            String(NbtErrorCodes.incorrectLcLe)] =
            NbtErrorCodes.errIncorrectLcConfiguration

        dictionary[String(NbtConstants.insGetConfiguration) +
            delimiter +
            String(NbtErrorCodes.conditionsUseUnsatisfied)] =
            NbtErrorCodes.errConditionsUseUnsatisfied

        dictionary[String(NbtConstants.insGetConfiguration) +
            delimiter +
            String(NbtErrorCodes.incorrectDataParameters)] =
            NbtErrorCodes.errWrongDataConfigurator

        dictionary[String(NbtConstants.insGetConfiguration) +
            delimiter +
            String(NbtErrorCodes.wrongP1P2)] =
            NbtErrorCodes.errInvalidP1P2Configuration

        dictionary[String(NbtConstants.insGetConfiguration) +
            delimiter +
            String(NbtErrorCodes.insNotSupported)] =
            NbtErrorCodes.errInvalidInsConfiguration

        dictionary[String(NbtConstants.insGetConfiguration) +
            delimiter +
            String(NbtErrorCodes.claNotSupported)] =
            NbtErrorCodes.errInvalidClaConfiguration

        return dictionary
    }()

    /// String containing response status word: error message
    private var error: String = .init()

    /// Constructor for NBT APDU response.
    ///
    /// - Parameters:
    ///   - response: APDU response
    ///   - ins: Instruction code for which response is generated.
    ///
    /// - Throws: ApduError Throws an APDU error,
    /// in case of error in parsing Apdu response.
    ///
    public init(response: ApduResponse,
                ins: UInt8) throws {
        try super.init(response: response.toData(), execTime: response.getExecutionTime())
        checkSWError(ins: ins)
    }

    /// Returns the response error message string, if status word is other
    /// than 9000. If no error, returns an empty string.
    ///
    /// - Returns: Returns the response error message string, if status word is
    /// other than 9000.
    public func getError() -> String { return error }

    /// If status word is not equals to 0x9000, then build the error message.
    /// If error code is not in map, then message "Unknown error code: XXXX"
    ///
    /// - Parameter ins: Instruction code for which the response is generated.
    ///
    private func checkSWError(ins: UInt8) {
        if getSW() == ApduResponse.swNoError // isSuccessSW() can be used
        {
            error = NbtConstants.emptyString
        } else {
            if let errorData: String = NbtApduResponse.errorMap[String(ins) +
                NbtApduResponse.delimiter + String(getSW())] {
                error = errorData
            } else {
                error = NbtErrorCodes.errUnknownSw +
                    Utils.toHexString(stream: Utils.getData(intValue: Int(getSW())))
            }
        }
    }

    /// Returns true, if command executed successfully or it returns false.
    ///
    /// - Returns: Returns the flag to setup the command execution status.
    ///
    override public func isSuccessSW() -> Bool { return getSW() == NbtApduResponse.swNoError }
}
