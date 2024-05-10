// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Decodes the payload data of alternative carrier record type
public class AlternativeCarrierRecordPayloadDecoder: IRecordPayloadDecoder {
    /// Defines the minimum length of alternative carrier record payload data.
    private static let minLength = 1

    /// Error message if unable to decode the Auxiliary data reference.
    private let invalidAuxiliaryData =
        "Unable to read Auxiliary data reference"
    
    /// Private tag for the logger message header
    private let headerTag = "AlternativeCarrierRecordPayloadDecoder"

    /// Decodes the alternative carrier record payload byte array into the record data structure.
    ///
    /// - Parameter payload: Alternative carrier record payload data
    ///
    /// - Returns: Abstract record data structure
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    public func decodePayload(payload: Data) throws -> AbstractRecord {
        NdefManager.getLogger()?.debug(header: headerTag, data: payload)
        do {
            try RecordDecoderUtils.validatePayload(
                payload: payload, minExpectedLength:
                AlternativeCarrierRecordPayloadDecoder.minLength)
            var index: Int = 0
            let cps: UInt8 = try Utils.getUInt8WithIndex(index: index, data: payload)
            index += 1
            guard let carrierDataReferences =
                try readCarrierDataReference(
                    stream: payload, index: &index)
            else {
                NdefManager.getLogger()?.error(header: headerTag,
                                              message: RecordDecoderUtils.errMessageInvalidPayload)
                throw NdefError(description:
                    RecordDecoderUtils.errMessageInvalidPayload)
            }
            let alternativeCarrierRecord = AlternativeCarrierRecord(
                cps: cps, carrierDataReference: carrierDataReferences)

            try readAuxiliaryDataReference(
                stream: payload, index: &index,
                alternativeCarrierRecord: alternativeCarrierRecord)
            NdefManager.getLogger()?.info(header: headerTag, message: "Payload decoded successfully.")
            return alternativeCarrierRecord
        } catch {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: RecordDecoderUtils.errMessageInvalidPayload)
            throw NdefError(description:
                RecordDecoderUtils.errMessageInvalidPayload)
        }
    }

    /// Decodes the auxiliary data references.
    ///
    /// - Parameters:
    ///   - stream: Data stream to be decoded.
    ///   - index: Current index to be decoded.
    ///   - alternativeCarrierRecord: Decoded auxiliary data will be
    ///   added to the provided alternative carrier record.
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    private func readAuxiliaryDataReference(
        stream: Data, index: inout Int,
        alternativeCarrierRecord: AlternativeCarrierRecord) throws {
        do {
            let auxiliaryDataReferencesLength: UInt8 =
                try Utils.getUInt8WithIndex(index: index, data: stream)
            index += 1
            for _ in 0 ..< auxiliaryDataReferencesLength {
                let auxiliaryDataReferenceLength: UInt8 =
                    try Utils.getUInt8WithIndex(index: index, data: stream)
                index += 1
                let data = try Utils.getDataFromStream(
                    length: Int(auxiliaryDataReferenceLength),
                    data: stream, index: &index)
                let auxiliaryDataReference = DataReference(data: data)
                alternativeCarrierRecord.addAuxiliaryDataReference(
                    auxiliaryDataReference: auxiliaryDataReference)
            }
        } catch {
            NdefManager.getLogger()?.error(header: headerTag,
                                          message: invalidAuxiliaryData)
            throw NdefError(description:
                invalidAuxiliaryData)
        }
    }

    /// Decodes the carrier data references.
    ///
    /// - Parameters:
    ///   - stream: Data stream to be decoded.
    ///   - index: Current index to be decoded.
    ///
    /// - Returns: ``DataReference``
    ///
    /// - Throws: ``NdefError`` In case of errors
    ///
    private func readCarrierDataReference(
        stream: Data, index: inout Int) throws -> DataReference? {
        let carrierDataReferencesLength: UInt8 =
            try Utils.getUInt8WithIndex(index: index, data: stream)
        index += 1
        if carrierDataReferencesLength >=
            AlternativeCarrierRecordPayloadDecoder.minLength {
            return try DataReference(
                data: Utils.getDataFromStream(
                    length: Int(carrierDataReferencesLength),
                    data: stream, index: &index))
        }
        return nil
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
