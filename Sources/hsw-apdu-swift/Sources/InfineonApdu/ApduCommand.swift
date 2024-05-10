// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Container class to store APDU structured data packages.
/// The APDU command consists of header (mandatory) and
/// command data (optional).
public class ApduCommand {
    /// Constant for case 1 APDU command
    public static let apduCase1 = 1

    /// Constant for case 2 APDU command
    public static let apduCase2 = 2

    /// Constant for case 3 APDU command
    public static let apduCase3 = 3

    /// Constant for case 4 APDU command
    public static let apduCase4 = 4

    /// Constant for offset value of APDU command CLA
    private let offsetCla = 0

    /// Constant for offset value of APDU command INS
    private let offsetIns = 1

    /// Constant for offset value of APDU command P1
    private let offsetP1 = 2

    /// Constant for offset value of APDU command P2
    private let offsetP2 = 3

    /// Constant for offset value of APDU command LE OR LE
    private let offsetLcOrLe = 4

    /// Constant for APDU command header size
    private let headerDataSize: Int = 4

    /// Data bytes containing command header
    private var header: Data = .init()

    /// Data field: Optional.
    private var commandData: Data?

    /// Expected Response Length (Le)
    private var lengthExpected: Int = 0

    /// Checks if APDU command is short or extended
    private var forceExtended: Bool = false

    /// Error message for invalid Lc or data length
    private let errInvalidDataLength = "APDU has an Incorrect Lc Byte or Data length"

    /// Error message for invalid APDU length
    private let errInvalidApduLength = "APDU length must not be less than 4"

    /// If leAbsent (0x00) constant is used for the LE field, the Le byte will not be present in the ``ApduCommand``
    public static let leAbsent: UInt8 = 0x00

    /// If leAny (256) constant is used for the LE field, the Le byte will be set as 0x00 in the ``ApduCommand``
    public static let leAny: UInt16 = 256

    /// Builds an APDU from CLA, INS, P1, P2, optional command data and Le byte.
    ///
    /// - Parameters:
    ///   - cla: Class byte
    ///   - ins: Instruction byte
    ///   - param1: Parameter byte 1
    ///   - param2: Parameter byte 2
    ///   - data: Command data
    ///   - lengthExpected: Expected response data length. The leAny (256) constant sets
    ///   the Le byte to 0x00 in ``ApduCommand``. If leAbsent (0x00) constant, 
    ///   the Le byte will not be present in the ``ApduCommand``
    ///
    ///   - Throws : ``ApduError`` if command data cannot be converted into a byte stream.
    ///
    public init(cla: UInt8,
                ins: UInt8,
                param1: UInt8,
                param2: UInt8,
                data: Any?,
                lengthExpected: Int) throws {
        header.append(Data([cla, ins, param1, param2]))
        self.lengthExpected = lengthExpected

        if let commandApdu = data {
            commandData = try ApduUtils.toData(stream: commandApdu)
        }
    }

    /// Initializes the class with the APDU input
    ///
    /// - Parameter command: Command APDU
    ///
    /// - Throws: ``ApduError`` if command data cannot be converted into a byte stream.
    ///
    public init(command: Any) throws {
        let commandApdu: Data = try ApduUtils.toData(stream: command)

        if commandApdu.count < headerDataSize {
            throw ApduError(description: errInvalidApduLength)
        }

        // copy header
        header = commandApdu.prefix(headerDataSize)

        var iOffset: Int = offsetLcOrLe
        var lengthCommand = 0

        if commandApdu.count == 4 {
            // Case 1
            lengthExpected = 0
        } else {
            // get Short Lc or Le
            let iValue = Int(commandApdu[iOffset])
            iOffset += 1

            if commandApdu.count == 5 { // case 2
                lengthExpected = iValue
            } else if iValue != 0 || commandApdu.count < 7 {
                // case  3 or 4 short
                if commandApdu.count == 5 + iValue {
                    // case 3 short
                    lengthCommand = iValue
                    lengthExpected = 0
                } else if commandApdu.count == 6 + iValue {
                    // case 4 short
                    lengthCommand = iValue
                    lengthExpected = Int(commandApdu[iOffset + Int(iValue)])
                } else {
                    throw ApduError(description: errInvalidDataLength)
                }
                let partData: Data = try Utils.getSubData(offset: iOffset,
                                                          data: commandApdu,
                                                          length: commandApdu.count)
                commandData = partData.prefix(Int(lengthCommand))
            } else {
                // Handle Extended Lc / Le. Not implemented in this version.
            }
        }
    }

    /// Get class byte (CLA).
    ///
    /// - Returns: Class byte.
    ///
    public func getCLA() -> UInt8 {
        return header[offsetCla]
    }

    /// Get expected response data length (Le)
    ///
    /// - Returns: Expected response data length.
    ///
    public func getLe() -> Int? {
        if lengthExpected == ApduCommand.leAny {
            return 0x00
        } else if lengthExpected == ApduCommand.leAbsent {
            return nil
        }
        return lengthExpected
    }

    /// Get length of command data (Lc).
    ///
    /// - Returns: Length of command data in bytes.
    ///
    public func getLc() -> Int {
        return commandData?.count ?? 0
    }

    /// Get instruction byte (INS).
    ///
    /// - Returns: Instruction byte.
    ///
    public func getIns() -> UInt8 {
        return header[offsetIns]
    }

    /// Get parameter byte P1.
    ///
    /// - Returns: P1 byte.
    ///
    public func getP1() -> UInt8 {
        return header[offsetP1]
    }

    /// Get parameter byte P2.
    ///
    /// - Returns: P2 byte.
    ///
    public func getP2() -> UInt8 {
        return header[offsetP2]
    }

    /// Returns the case of the APDU command.
    ///
    /// - Returns: APDU case constant.
    ///
    public func getCase() -> Int {
        if let commandApdu = commandData, !commandApdu.isEmpty {
            return (lengthExpected == 0) ? ApduCommand.apduCase3 : ApduCommand.apduCase4
        }
        return (lengthExpected == 0) ? ApduCommand.apduCase1 : ApduCommand.apduCase2
    }

    /// Returns the length of the APDU command in bytes.
    ///
    /// - Returns: Length of the APDU command including the header, data and potential Le byte.
    ///
    public func getLength() -> Int {
        let maxLc = 255
        let maxLe = 256
        var length = 0

        if let commandApdu = commandData {
            length = commandApdu.count
        }

        let mILc: Int = length
        if mILc == 0 {
            if lengthExpected == 0 {
                // case 1
                length = 4
            } else if lengthExpected <= maxLe {
                // case 2 short
                length = 5
                if forceExtended {
                    length = 7
                }
            } else {
                // case 2 extended
                length = 7
            }
        } else {
            if (mILc <= maxLc) && (lengthExpected <= maxLe) {
                // short case 3 or 4
                if lengthExpected == 0 {
                    // case 3 short
                    length = 5 + mILc
                    if forceExtended {
                        length = 7 + mILc
                    }
                } else {
                    // case 4 short
                    length = 6 + mILc
                    if forceExtended {
                        length = 9 + mILc
                    }
                }
            } else {
                if lengthExpected == 0 {
                    // case 3 extended
                    length = 7 + mILc
                } else {
                    // case 4 extended
                    length = 9 + mILc
                }
            }
        }
        return length
    }

    /// Returns a byte sequence representation of the APDU command.
    ///
    /// - Returns: A byte sequence representation of the APDU command.
    ///
    public func toData() -> Data {
        var abCommand = Data(count: getLength())
        var offset = 4
        let iLc = commandData?.count ?? 0

        // set first four header bytes
        _ = Utils.dataCopy(src: header,
                           srcOffset: 0,
                           dest: &abCommand,
                           destOffset: 0,
                           length: 4)

        // check if short APDU format
        if (iLc <= 255) && (lengthExpected <= 256) && !forceExtended {
            if iLc > 0 {
                // set Lc byte and copy data
                abCommand[offset] = UInt8(iLc)
                offset += 1
                _ = Utils.dataCopy(src: commandData!,
                                   srcOffset: 0,
                                   dest: &abCommand,
                                   destOffset: offset,
                                   length: iLc)
                offset += iLc
            }

            if lengthExpected > 0 {
                abCommand[offset] = UInt8(exactly: lengthExpected) ?? UInt8(0x00)
            }
        } else {
            // Handle extended APDU
        }
        return abCommand
    }

    /// Gets command data header of APDU.
    ///
    /// - Returns: Byte array containing the command data of APDU.
    ///
    public func getData() -> Data? {
        return commandData
    }

    /// Gets command data header of APDU.
    ///
    /// - Returns: Byte array containing the command data header of APDU.
    ///
    public func getHeader() -> Data {
        return header
    }
}
