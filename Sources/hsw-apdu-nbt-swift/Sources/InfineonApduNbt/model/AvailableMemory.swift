// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Parses the available memory information from the NBT applet.
public class AvailableMemory {
    /// Tag for available transient of clear on deselect (COD) type.
    private static let tagCodMemory: UInt8 = 0xc8

    /// Tag for available transient of clear on reset (COR) type.
    private static let tagCorMemory: UInt8 = 0xc7

    /// Tag for available persistent/NVM memory.
    private static let tagNvmMemory: UInt8 = 0xc6

    /// NVM/available persistent memory in the available memory.
    private var nvmMemory: UInt16 = .init()

    /// Available transient of clear on reset type memory in the available memory.
    private var availableTransientCor: UInt16 = .init()

    /// Available transient of clear on deselect type memory in the available
    /// memory.
    private var availableTransientCod: UInt16 = .init()
    
    /// Error message for invalid memory data
    private let errInvalidMemoryData = "Failed to parse available memory data"

    /// Constructor for creating an instance with the available memory.
    ///
    /// - Parameter data: Data bytes received from the secure element.
    ///
    /// - Throws: ``NbtError`` Throws the NBT error, if failed to parse the
    /// available memory data.
    ///
    public init(data: Data) throws {
        do {
            let parser: TlvParser = .init(structure: data)

            // Extract 6f Tlv
            var tlvs: [Any] = try parser.parseTlvStructure()
            guard let tlv6f: Tlv = tlvs[0] as? Tlv
            else {
                throw NbtError(description: errInvalidMemoryData)
            }

            // Extract DF3B Tlv
            tlvs = try TlvParser(structure: tlv6f.getValues()).parseTlvStructure()
            guard let tlvDf3b: Tlv = tlvs[0] as? Tlv
            else {
                throw NbtError(description: errInvalidMemoryData)
            }

            // Extract c6,c7,c8 TLVs
            tlvs = try TlvParser(structure: tlvDf3b.getValues()).parseTlvStructure()

            for tlvDf3bFragments: Any in tlvs {
                if let tlvDf3bFragment: Tlv = tlvDf3bFragments as? Tlv {
                    let tag = UInt8(tlvDf3bFragment.getTag())
                    let value: Data = tlvDf3bFragment.getValues()

                    if tag == AvailableMemory.tagNvmMemory {
                        try setNvmMemory(nvmMemory: UInt16(
                            Utils.getUINT16(data: value, offset: 0)))
                    }
                    if tag == AvailableMemory.tagCorMemory {
                        try setAvailableTransientCor(availableTransientCor: UInt16(
                            Utils.getUINT16(data: value, offset: 0)))
                    }
                    if tag == AvailableMemory.tagCodMemory {
                        try setAvailableTransientCod(availableTransientCod: UInt16(
                            Utils.getUINT16(data: value, offset: 0)))
                    }
                }
            }
        } catch let error as UtilsError {
            throw NbtError(description: errInvalidMemoryData, error: error)
        }
    }

    /// Getter for NVM memory
    ///
    /// - Returns: Returns the NVM memory.
    ///
    public func getNvmMemory() -> UInt16 { return nvmMemory }

    /// Setter for NVM memory
    ///
    /// - Parameter nvmMemory: Sets the NVM memory.
    ///
    private func setNvmMemory(nvmMemory: UInt16) {
        self.nvmMemory = nvmMemory
    }

    /// Getter for available transient of COR memory type
    ///
    /// - Returns: Gets the available transient of COR memory type.
    ///
    public func getAvailableTransientCor() -> UInt16 { return availableTransientCor }

    /// Setter for available transient of COR memory type
    ///
    /// - Parameter availableTransientCor: Sets the available transient of
    /// COR memory type.
    ///
    private func setAvailableTransientCor(availableTransientCor: UInt16) {
        self.availableTransientCor = availableTransientCor
    }

    /// Getter for available transient of COD memory type
    ///
    /// - Returns: Gets the available transient of COD memory type.
    ///
    public func getAvailableTransientCod() -> UInt16 { return availableTransientCod }

    /// Setter for available transient of COD memory type.
    ///
    /// - Parameter availableTransientCod: Sets the available transient
    /// of COD memory type.
    ///
    private func setAvailableTransientCod(availableTransientCod: UInt16) {
        self.availableTransientCod = availableTransientCod
    }
}
