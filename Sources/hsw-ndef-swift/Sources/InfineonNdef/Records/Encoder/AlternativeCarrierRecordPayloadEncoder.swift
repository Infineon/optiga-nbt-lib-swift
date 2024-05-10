// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonUtils

/// Encodes the alternative carrier record type to payload byte array.
public class AlternativeCarrierRecordPayloadEncoder: IRecordPayloadEncoder {
    /// Defines carrier data reference size
    private static let emptyCarrierDataSize = 0

    /// Private tag for the logger message header
    private let headerTag = "AlternativeCarrierRecordPayloadEncoder"

    /// Defines auxiliary data size.
    private static let emptyAuxiliaryDataSize = 0

    /// Error message if carrier data reference bytes are null or not present.
    private static let errMessageEmptyCarrierData =
        "Carrier data references bytes are empty"

    /// Encodes the alternative carrier record data structure into the record
    /// payload byte array.
    ///
    /// - Parameter abstractRecord: WellKnownRecord ``AlternativeCarrierRecord``
    ///
    /// - Returns: Record payload data
    ///
    public func encodePayload(abstractRecord: AbstractRecord) -> Data {
        guard let alternativeCarrierRecord =
            abstractRecord as? AlternativeCarrierRecord
        else {
            NdefManager.getLogger()?.warning(header: headerTag,
                                             message: "WellKnownRecord is not type of AlternativeCarrierRecord")
            // Handle appropriately if the wellKnownRecord is not of type AlternativeCarrierRecord
            return Data()
        }

        guard let carrierDataReference =
            alternativeCarrierRecord.getCarrierDataReference(),
            let carrierData = carrierDataReference.getData(),
            carrierData.count !=
            AlternativeCarrierRecordPayloadEncoder.emptyCarrierDataSize
        else {
            NdefManager.getLogger()?.warning(header: headerTag,
                                             message: "CarrierDataReference is empty")
            return Data()
        }

        var alternativeCarrierRecordPayloadAsBytes = Data()
        alternativeCarrierRecordPayloadAsBytes.append(
            alternativeCarrierRecord.getCps())

        let encodedDataReference = encodeDataReference(
            dataReference: carrierDataReference)
        alternativeCarrierRecordPayloadAsBytes.append(
            contentsOf: encodedDataReference)

        let auxiliaryDataReferences =
            alternativeCarrierRecord.getAuxiliaryDataReferences()
        let encodedAuxiliaryDataReferences = encodeAuxiliaryDataReferences(
            auxiliaryDataReferences: auxiliaryDataReferences)
        alternativeCarrierRecordPayloadAsBytes.append(
            contentsOf: encodedAuxiliaryDataReferences)
        NdefManager.getLogger()?.debug(header: headerTag,
                                      data: alternativeCarrierRecordPayloadAsBytes)
        NdefManager.getLogger()?.info(header: headerTag, message: "Payload encoded successfully.")
        return alternativeCarrierRecordPayloadAsBytes
    }

    /// Encodes the auxiliary data reference list in the byte array.
    ///
    /// - Parameter auxiliaryDataReferences: Auxiliary data reference list
    ///
    /// - Returns: Auxiliary data reference byte array
    ///
    private func encodeAuxiliaryDataReferences(
        auxiliaryDataReferences: [DataReference]) -> Data {
        var alternativeCarrierRecordPayloadAsBytes = Data()

        if !auxiliaryDataReferences.isEmpty {
            alternativeCarrierRecordPayloadAsBytes.append(
                UInt8(auxiliaryDataReferences.count))

            for auxiliaryDataReference in auxiliaryDataReferences {
                let encodedDataReference = encodeDataReference(
                    dataReference: auxiliaryDataReference)
                alternativeCarrierRecordPayloadAsBytes.append(
                    contentsOf: encodedDataReference)
            }

        } else {
            NdefManager.getLogger()?.warning(header: headerTag,
                                             message: "AuxiliaryData is empty")
            alternativeCarrierRecordPayloadAsBytes.append(
                UInt8(AlternativeCarrierRecordPayloadEncoder.emptyAuxiliaryDataSize))
        }

        return alternativeCarrierRecordPayloadAsBytes
    }

    /// Encodes the data reference byte array.
    ///
    /// - Parameter dataReference: Data reference
    ///
    /// - Returns: Data reference byte array
    ///
    private func encodeDataReference(dataReference: DataReference) -> Data {
        guard let dataReferenceLength = dataReference.getLength(),
              let dataReferenceData = dataReference.getData()
        else {
            NdefManager.getLogger()?.warning(header: headerTag,
                                             message: "DataReference is empty")
            return Data()
        }
        return Utils.concat(
            firstData: Data([UInt8(truncatingIfNeeded: dataReferenceLength)]),
            secondData: dataReferenceData)
    }

    /// Provides public access to create initializer
    public init() {
        // Provides public access
    }
}
