// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu
import InfineonUtils

/// Command builder to build the APDUs used for personalization of NBT application.
public class NbtCommandBuilderPerso {

    /// Maximum size of data to be personalized
    private let maximumPersonalizeDataSize: Int = 255

    /// Error message for invalid personalize data
    private let errInvalidPersonalizeData = "Personalize data exceeds maximum length"

    /// Enumeration stores the data group index for personalize data command.
    public enum Personalize_Data_Dgi: UInt16 {
        case a001 = 0xa001
        case a002 = 0xa002
        case a003 = 0xa003
        case e104 = 0xe104
        case e1a1 = 0xe1a1
        case e1a2 = 0xe1a2
        case e1a3 = 0xe1a3
        case e1a4 = 0xe1a4
        case e1af = 0xe1af
        case bf63 = 0xbf63
    }

    /// Builds the personalize data command, which is used to personalize the data
    /// elements of the applet.
    ///
    /// - Parameters:
    ///   - dgi: Data group identifier of the data to be personalized.
    ///   - personalizeData: Data to be personalized.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ``NbtError`` Throws an Nbt error, in case of personalize
    /// data bytes are more than maximum allowed size
    ///
    public func personalizeData(dgi: UInt16,
                                personalizeData: Data) throws -> ApduCommand {
        if personalizeData.count > maximumPersonalizeDataSize {
            throw NbtError(description: errInvalidPersonalizeData)
        }
        let dgiByte: Data = try Utils.toData(stream: dgi)
        var commandData = dgiByte
        commandData.append(UInt8(personalizeData.count))
        commandData.append(personalizeData)

        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insPersonalizeData,
                               param1: NbtConstants.p1Default,
                               param2: NbtConstants.p2Default,
                               data: commandData,
                               lengthExpected: Int(NbtConstants.leAbsent))
    }

    /// Builds the finalize personalization command, which is used to finalize the
    /// personalization state and card transitions to operational state.
    ///
    /// - Returns: Returns the APDU command.
    ///
    /// - Throws: ApduError will be thrown if any issues in building the command.
    ///
    public func finalizePersonalization() throws -> ApduCommand {
        let finalizePersoCmdData = Data([0xbf, 0x63, 0x00])
        return try ApduCommand(cla: NbtConstants.cla,
                               ins: NbtConstants.insPersonalizeData,
                               param1: NbtConstants.p1Default,
                               param2: NbtConstants.p2Default,
                               data: finalizePersoCmdData,
                               lengthExpected: Int(NbtConstants.leAbsent))
    }
}
