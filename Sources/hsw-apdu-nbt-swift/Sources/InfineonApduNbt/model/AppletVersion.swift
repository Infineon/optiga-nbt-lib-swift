// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu
import InfineonUtils

/// Parses the version of NBT applet.
public class AppletVersion {
    /// Offset position for the major version.
    private let offsetMajorVersion: Int = 0

    /// Offset position for the minor version.
    private let offsetMinorVersion: Int = 1

    /// Offset position for the build number.
    private let offsetBuildNumber: Int = 2

    /// Major version in file control information.
    private var majorVersion: UInt8 = .init()

    /// Minor version in file control information.
    private var minorVersion: UInt8 = .init()

    /// Build number in file control information.
    private var buildNumber: UInt16 = .init()
    
    /// Error message for invalid applet version
    private static let errInvalidAppletVersion = "Failed to parse applet version data"

    /// Constructor for creating an instance with the applet version.
    ///
    /// - Parameter data: Data bytes received from the secure element.
    ///
    /// - Throws: ``NbtError`` Throws the NBT error, if failed to parse the
    /// applet version.
    ///
    public init(data: Data) throws {
        do {
            let version: Data = try AppletVersion.parseAppletVersionBytes(data: data)
            try self.setBuildNumber(buildNumber: Utils.getUINT16(
                data: version, offset: self.offsetBuildNumber))
            self.setMajorVersion(majorVersion: version[self.offsetMajorVersion])
            self.setMinorVersion(minorVersion: version[self.offsetMinorVersion])
        } catch let error as UtilsError {
            throw NbtError(description: AppletVersion.errInvalidAppletVersion, error: error)
        }
    }
        /// Returns the applet version data from the tlv structure
        ///
        /// - Parameter data: Tlv data for applet version
        ///
        /// - Returns: Applet version data (Major version, minor version and build number)
        ///
        /// - Throws: ``NbtError`` Throws the Nbt error, if failed to parse the
        /// applet version.
        ///
    private static func parseAppletVersionBytes(data: Data) throws -> Data {
        let parser = TlvParser(structure: data)
        var tlvs: [Any] = try parser.parseTlvStructure()
        if tlvs.isEmpty {
            throw NbtError(description:
                self.errInvalidAppletVersion)
        }
        guard let tlv6f: Tlv = tlvs[0] as? Tlv
        else {
            throw NbtError(description:
                self.errInvalidAppletVersion)
        }
        tlvs = try TlvParser(structure: tlv6f.getValues()).parseTlvStructure()
        guard let tlvDf3a: Tlv = tlvs[0] as? Tlv
        else {
            throw NbtError(description:
                self.errInvalidAppletVersion)
        }
        return tlvDf3a.getValues()
    }

    /// Getter for the major version.
    ///
    /// - Returns: Returns the major version
    ///
    public func getMajorVersion() -> UInt8 { return self.majorVersion }

    /// Setter for the major version.
    ///
    /// - Parameter majorVersion: majorVersion Sets the major version.
    ///
    private func setMajorVersion(majorVersion: UInt8) {
        self.majorVersion = majorVersion
    }

    /// Getter for the minor version.
    ///
    /// - Returns: Returns the minor version.
    ///
    public func getMinorVersion() -> UInt8 { return self.minorVersion }

    /// Setter for the minor version.
    ///
    /// - Parameter minorVersion: Sets the minor version.
    ///
    private func setMinorVersion(minorVersion: UInt8) {
        self.minorVersion = minorVersion
    }

    /// Getter for the build number.
    ///
    /// - Returns: Returns the build number.
    ///
    public func getBuildNumber() -> UInt16 { return self.buildNumber }

    /// Setter for the build number.
    ///
    /// - Parameter buildNumber: Sets the build number.
    ///
    private func setBuildNumber(buildNumber: UInt16) {
        self.buildNumber = buildNumber
    }
}
