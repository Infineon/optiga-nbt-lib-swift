// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Interface for certificate encoder and decoder.
public protocol ICertificateHandler {
    /// Parses the certificate bytes and returns the decoded certificate object.
    ///
    /// - Parameter certificateBytes: Encoded certificate as bytes.
    ///
    /// - Returns: Decoded certificate object.
    ///
    /// - Throws: ``CertificateError`` if parsing certificate fails.
    ///
    func decodeCertificate(certificateBytes: Data) throws -> SecCertificate

    /// Encodes the certificate into bytes.
    ///
    /// - Parameter certificate: Certificate to be encoded.
    ///
    /// - Returns: Encoded certificate as byte data.
    ///
    /// - Throws: ``CertificateError`` if encoding the certificate fails.
    ///
    func encodeCertificate(certificate: SecCertificate) throws -> Data
}
