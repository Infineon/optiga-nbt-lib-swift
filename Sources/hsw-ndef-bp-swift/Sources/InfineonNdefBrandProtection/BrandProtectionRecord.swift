// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonNdef
import Security

/// Stores the brand protection record, including an X.509 v3 certificate for
/// offline authentication use cases.
public class BrandProtectionRecord: AbstarctExternalTypeRecord {
    /// Private tag for the logger message header
    private let headerTag = "BrandProtectionRecord"

    // Error message if ICertificateHandler is not set.
    private let errMessageUnknownHandler = "Certificate handler is not provided"

    // Error message if the payload is invalid.
    private let errMessagePayloadNull = "Payload should not be null"

    // CertificateHandler for encoding and decoding a specific type of certificate.
    private var certificateHandler: ICertificateHandler?

    // Defines the brand protection record type definition (RTD).
    public static let brandProtectionRtdType = "infineon.com:nfc-bridge-tag.x509"

    /// Constructor to create the brand protection record.
    ///
    /// - Parameter certificate: Content of the X.509 v3 certificate as byte data.
    ///
    public init(certificate: Data) {
        super.init(recordType: BrandProtectionRecord.brandProtectionRtdType)
        setPayload(payload: certificate)
        setCertificateHandler(certificateHandler: X509CertificateHandler())
    }

    /// Constructor to create a brand protection record.
    public init() {
        super.init(recordType: BrandProtectionRecord.brandProtectionRtdType)
        setCertificateHandler(certificateHandler: X509CertificateHandler())
    }

    /// Gets the decoded payload with the help of ICertificateHandler and provide
    /// a certificate object.
    ///
    /// - Returns:  Certificate object.
    ///
    /// - Throws: ``CertificateError`` If ICertificateHandler is unable to decode
    /// the certificate.
    ///
    public func getCertificate() throws -> SecCertificate {
        guard let payloadData = getPayload() else {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: errMessagePayloadNull)
            throw CertificateError(description: errMessagePayloadNull)
        }
        let certificate = try certificateHandler!.decodeCertificate(certificateBytes: payloadData)
        return certificate
    }

    /// Sets the certificate object as a payload of the record.
    ///
    /// - Parameter certificate: Certificate object.
    ///
    /// - Throws: ``CertificateError`` If ICertificateHandler is unable to encode
    /// the certificate.
    ///
    public func setCertificate(certificate: SecCertificate) throws {
        try setPayload(payload: certificateHandler?.encodeCertificate(certificate: certificate) ?? Data())
    }

    /// Sets the certificate handler.
    ///
    /// - Parameter certificateHandler: Certificate handler to be
    /// used for encoding and decoding.
    ///
    private func setCertificateHandler(certificateHandler: ICertificateHandler) {
        self.certificateHandler = certificateHandler
    }
}
