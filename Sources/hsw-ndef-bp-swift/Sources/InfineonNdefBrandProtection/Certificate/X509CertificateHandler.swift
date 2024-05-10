// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import Security
import InfineonNdef

/// Certificate handler implementation for handling X509 certificates.
public class X509CertificateHandler: ICertificateHandler {
    /// Private tag for the logger message header
    private let headerTag = "X509CertificateHandler"

    /// Error message if the payload is invalid.
    private let errMessagePayloadNull =
        "Payload should not be null"

    /// Error message if the certificate is not an X.509 certificate.
    private let errMessageUnknownCertificate =
        "Certificate is not an X.509 certificate"

    /// Decodes the X.509 certificate bytes into X.509 certificate object.
    ///
    /// - Parameter certificateBytes: X.509 certificate as bytes.
    ///
    /// - Returns: Decoded X.509 certificate.
    ///
    /// - Throws: ``CertificateError`` If certificate decoding fails.
    ///
    public func decodeCertificate(certificateBytes: Data) throws -> SecCertificate {
        guard !certificateBytes.isEmpty else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errMessagePayloadNull)
            throw CertificateError(description: errMessagePayloadNull)
        }
        if let certificateFactory = SecCertificateCreateWithData(nil, certificateBytes as CFData) {
            return certificateFactory
        } else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errMessagePayloadNull)
            throw CertificateError(description: errMessagePayloadNull)
        }
    }

    /// Encodes the X.509 certificate into bytes.
    ///
    /// - Parameter certificate: X.509 certificate to be encoded.
    ///
    /// - Returns: Encoded X.509 certificate.
    ///
    public func encodeCertificate(certificate: SecCertificate) -> Data {
        return SecCertificateCopyData(certificate) as Data
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
