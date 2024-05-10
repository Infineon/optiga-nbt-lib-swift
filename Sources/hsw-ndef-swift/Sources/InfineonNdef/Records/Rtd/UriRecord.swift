// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// The NFC Local Type Name for the action is "U" (0x55).
/// URI record is a record that stores the URI information such as a website URL in a tag.
/// URI is the core of the smart poster, and all the records are just associated with
/// metadata about this record. Only one URI record can be present in the smart poster record.
public class UriRecord: AbstractWellKnownTypeRecord {
    public static let defaultUriCharset = Swift.String.Encoding.utf8

    /// The well known type for an URI record is 'U' (0x55 in the NDEF binary
    /// representation).
    public static let uriType = "U"

    /// Error message stating that the URI should not be empty.
    public static let errMessageUriNotEmpty = "URI cannot be empty"

    /// The rest of the URI other than URI identifier, or the entire URI (if identifier code is 0x00).
    private var uri: String = ""

    /// URI identifier
    private var uriIdentifier = UriIdentifier.uriNa

    /// Constructor is to create a new URI record
    ///
    /// - Parameter uri: Uniform Resource Identifier (URI). Eg.
    /// <i>https://www.company.com/</i>
    ///
    /// - Throws: Throws an ``NdefError``, if URI is empty.
    ///
    public init(uri: String) throws {
        if uri.isEmpty {
            throw NdefError(description: UriRecord.errMessageUriNotEmpty)
        }
        super.init(recordType: UriRecord.uriType)
        self.uriIdentifier = findMatchingIdentifier(uriWithPrefix: uri)

        self.uri = String(uri.dropFirst(uriIdentifier.prefix.count))
    }

    /// Constructor to create a new URI record with separate URI prefix and URI field.
    ///
    /// - Parameters:
    ///   - uriIdentifier: URI protocol prefix (For example, UriIdentifier.uriHttpsWww)
    ///   - uri: URI without protocol prefix. For example, <i>company.com/</i>
    ///
    /// - Throws: Throws an ``NdefError``, if URI is empty.
    ///
    public init(uriIdentifier: UriIdentifier, uri: String) throws {
        if uri.isEmpty {
            throw NdefError(description:
                UriRecord.errMessageUriNotEmpty)
        }
        super.init(recordType: UriRecord.uriType)
        self.uriIdentifier = uriIdentifier
        self.uri = uri
    }

    /// Constructor to create a new URI record with separate URI prefix and URI field
    ///
    /// - Parameters:
    ///   - identifierCode: URI protocol prefix code (For example, 0x02 for https://www.)
    ///   - uri: URI. For example, <i>https://www.company.com/</i>
    ///
    /// - Throws: Throws an ``NdefError``, if URI is empty.
    ///
    public init(identifierCode: Int, uri: String) throws {
        if uri.isEmpty {
            throw NdefError(description:
                UriRecord.errMessageUriNotEmpty)
        }
        super.init(recordType: UriRecord.uriType)
        self.uriIdentifier = UriIdentifier.getEnumByUriIdentifierCode(
            identifierCode: identifierCode)
        self.uri = uri
    }

    /// Check for the closely matching protocol identifier from the list of URI identifiers.
    ///
    /// - Parameter uriWithPrefix: URI including identifier protocol prefix.
    /// - Returns: Returns the matched URI identifier.
    ///
    private func findMatchingIdentifier(uriWithPrefix: String) -> UriIdentifier {
        var matchedUriIdentifier = UriIdentifier.uriNa
        for tempUriIdentifier in UriIdentifier.allCases {
            if uriWithPrefix.starts(with: tempUriIdentifier.prefix) &&
                tempUriIdentifier.prefix.count > matchedUriIdentifier.prefix.count {
                matchedUriIdentifier = tempUriIdentifier
            }
        }
        return matchedUriIdentifier
    }

    /// Gets the URI string without identifier.
    ///
    /// - Returns: Returns the URI.
    ///
    public func getUri() -> String {
        return uri
    }

    /// Sets the Uniform Resource Identifier string onto the record
    ///
    /// - Parameter uri: sets the Uniform Resource Identifier (URI).
    ///
    public func setUri(uri: String) {
        self.uri = uri
    }

    /// Gets the URI string with prefix if present.
    ///
    /// - Returns: Returns the URI.
    ///
    public func getUriWithIdentifier() -> String {
        return uriIdentifier.prefix + uri
    }

    /// Gets the index to abbreviate the URI identifier including prefix and value.
    ///
    /// - Returns: Returns the URI identifier.
    ///
    public func getUriIdentifier() -> UriIdentifier {
        return uriIdentifier
    }

    /// Sets the URI identifier enumeration onto the record.
    ///
    /// - Parameter uriIdentifier: URI identifier
    ///
    public func setUriIdentifier(uriIdentifier: UriIdentifier) {
        self.uriIdentifier = uriIdentifier
    }

    /// Enumeration to store all abbreviate URI's values defined in the URI RTD specification.
    public enum UriIdentifier: Int, CaseIterable {
        /// N/A. No prepending is done, and the URI field contains the unabridged
        /// URI.
        case uriNa = 0x00

        /// Abbreviation enumeration for http://www.
        case uriHttpWww = 0x01

        /// Abbreviation enumeration for https://www.
        case uriHttpsWww = 0x02

        /// Abbreviation enumeration for http://
        case uriHttp = 0x03

        /// Abbreviation enumeration for https://
        case uriHttps = 0x04

        /// Abbreviation enumeration for tel:
        case uriTel = 0x05

        /// Abbreviation enumeration for mailto:
        case uriMailto = 0x06

        /// Abbreviation enumeration for ftp://anonymous:anonymous@
        case uriFtpAnonymousAnonymous = 0x07

        /// Abbreviation enumeration for ftp://ftp.
        case uriFtpFtp = 0x08

        /// Abbreviation enumeration for ftps://
        case uriFtps = 0x09

        /// Abbreviation enumeration for sftp://
        case uriSftp = 0x0a

        /// Abbreviation enumeration for smb://
        case uriSmb = 0x0b

        /// Abbreviation enumeration for nfs://
        case uriNfs = 0x0c

        /// Abbreviation enumeration for ftp://
        case uriFtp = 0x0d

        /// Abbreviation enumeration for dav://
        case uriDav = 0x0e

        /// Abbreviation enumeration for news:
        case uriNews = 0x0f

        /// Abbreviation enumeration for telnet://
        case uriTelnet = 0x10

        /// Abbreviation enumeration for imap:
        case uriImap = 0x11

        /// Abbreviation enumeration for rtsp://
        case uriRtsp = 0x12

        /// Abbreviation enumeration for urn:
        case uriUrn = 0x13

        /// Abbreviation enumeration for pop:
        case uriPop = 0x14

        /// Abbreviation enumeration for sip:
        case uriSip = 0x15

        /// Abbreviation enumeration for sips:
        case uriSips = 0x16

        /// Abbreviation enumeration for tftp:
        case uriTftp = 0x17

        /// Abbreviation enumeration for btspp://
        case uriBtspp = 0x18

        /// Abbreviation enumeration for btl2cap://
        case uriBt12cap = 0x19

        /// Abbreviation enumeration for btgoep://
        case uriBtgoep = 0x1a

        /// Abbreviation enumeration for tcpobex://
        case uriTcpobex = 0x1b

        /// Abbreviation enumeration for irdaobex://
        case uriIrdaobex = 0x1c

        /// Abbreviation enumeration for file://
        case uriFile = 0x1d

        /// Abbreviation enumeration for urn:epc:id:
        case uriUrnEpcId = 0x1e

        /// Abbreviation enumeration for urn:epc:tag:
        case uriUrnEpcTag = 0x1f

        /// Abbreviation enumeration for urn:epc:pat:
        case uriUrnEpcPat = 0x20

        /// Abbreviation enumeration for urn:epc:raw:
        case uriUrnEpcRaw = 0x21

        /// Abbreviation enumeration for urn:epc:
        case uriUrnEpc = 0x22

        /// Abbreviation enumeration for urn:nfc:
        case uriUrnNfc = 0x23

        /// Prefix for URI identifier
        public var prefix: String {
            switch self {
            case .uriNa:
                return ""
            case .uriHttpWww:
                return "http://www."
            case .uriHttpsWww:
                return "https://www."
            case .uriHttp:
                return "http://"
            case .uriHttps:
                return "https://"
            case .uriTel:
                return "tel:"
            case .uriMailto:
                return "mailto:"
            case .uriFtpAnonymousAnonymous:
                return "ftp://anonymous:anonymous@"
            case .uriFtpFtp:
                return "ftp://ftp."
            case .uriFtps:
                return "ftps://"
            case .uriSftp:
                return "sftp://"
            case .uriSmb:
                return "smb://"
            case .uriNfs:
                return "nfs://"
            case .uriFtp:
                return "ftp://"
            case .uriDav:
                return "dav://"
            case .uriNews:
                return "news:"
            case .uriTelnet:
                return "telnet://"
            case .uriImap:
                return "imap:"
            case .uriRtsp:
                return "rtsp://"
            case .uriUrn:
                return "urn:"
            case .uriPop:
                return "pop:"
            case .uriSip:
                return "sip:"
            case .uriSips:
                return "sips:"
            case .uriTftp:
                return "tftp:"
            case .uriBtspp:
                return "btspp://"
            case .uriBt12cap:
                return "btl2cap://"
            case .uriBtgoep:
                return "btgoep://"
            case .uriTcpobex:
                return "tcpobex://"
            case .uriIrdaobex:
                return "irdaobex://"
            case .uriFile:
                return "file://"
            case .uriUrnEpcId:
                return "urn:epc:id:"
            case .uriUrnEpcTag:
                return "urn:epc:tag:"
            case .uriUrnEpcPat:
                return "urn:epc:pat:"
            case .uriUrnEpcRaw:
                return "urn:epc:raw:"
            case .uriUrnEpc:
                return "urn:epc:"
            case .uriUrnNfc:
                return "urn:nfc:"
            }
        }

        /// Returns the URI identifier by the closely matching protocol identifier.
        ///
        /// - Parameter uriWithPrefix: URI including identifier protocol prefix.
        ///
        /// - Returns: Matched URI identifier enumeration, null if no matching
        /// enumeration is found.
        ///
        public static func getEnumByUriIdentifierPrefix(
            uriWithPrefix: String) -> UriIdentifier {
            for uriIdentifier in UriIdentifier.allCases where
                uriIdentifier.prefix == uriWithPrefix {
                    return uriIdentifier
            }
            return UriIdentifier.uriNa
        }

        /// Returns the URI identifier by the closely matching protocol identifier code.
        ///
        /// - Parameter identifierCode: URI identifier code.
        ///
        /// - Returns: Returns the matched URI identifier enumeration, null if no
        /// matching enumeration is found.
        ///
        public static func getEnumByUriIdentifierCode(
            identifierCode: Int) -> UriIdentifier {
            for uriIdentifier in UriIdentifier.allCases where
                uriIdentifier.rawValue == identifierCode {
                    return uriIdentifier
            }
            return UriIdentifier.uriNa
        }
    }
}
