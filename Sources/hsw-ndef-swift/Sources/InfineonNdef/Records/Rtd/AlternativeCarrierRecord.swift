// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// The NFC Forum well known local type (defined in [NDEF], [RTD]) for the
/// alternative carrier record shall be "ac" (in NFC binary encoding: 0x61, 0x63)
/// The alternative carrier record is used within global handover NDEF records to
/// describe a single alternative carrier. It shall not be used elsewhere.
public class AlternativeCarrierRecord: AbstractWellKnownTypeRecord {
    /// Constant defines the NFC Forum well known type (defined in [NDEF], [RTD])
    /// for the alternative carrier record (in NFC binary encoding: 0x61, 0x63).
    public static let alternativeCarrierRecordType = "ac"

    /// Constant defines the carrier power state 'inactive', If the carrier is
    /// currently off.
    public static let inactive: UInt8 = 0x00

    /// Mask for cps value of 2-bit.
    public static let cpsMask: UInt8 = 0x03

    /// Constant defines the carrier power state 'active',
    /// If the carrier is currently on.
    public static let active: UInt8 = 0x01

    /// Constant defines the carrier power state 'activating',
    /// If the device is in the process of activating the carrier,
    /// but the carrier is not yet active.
    public static let activating: UInt8 = 0x02

    /// Constant defines the carrier power state 'unknown',
    /// the device is only reachable via the carrier through a
    /// router and does not directly support an interface for
    /// the carrier.
    public static let unknown: UInt8 = 0x03

    /// A 2-bit field that indicates the carrier power state (CPS).
    private var cps: UInt8 = 0

    /// List of 1-byte pointer to an NDEF record
    /// that uniquely identifies the carrier technology.
    private var carrierDataReference: DataReference?

    /// List of 1-byte pointer to an NDEF record that gives
    /// additional information about the alternative carrier.
    /// No limitations are imposed on the NDEF payload
    /// type being pointed to.
    private var auxiliaryDataReferences = [DataReference]()

    /// Constructor to create a new alternative carrier record.
    ///
    /// - Parameters:
    ///   - cps: 2-bit field that indicates the carrier power state.
    ///   - carrierDataReference: 1-byte pointer to an NDEF record that uniquely
    ///   identifies the carrier technology.
    ///
    public init(cps: UInt8, carrierDataReference: DataReference) {
        self.cps = cps
        self.carrierDataReference = carrierDataReference
        super.init(recordType:
            AlternativeCarrierRecord.alternativeCarrierRecordType)
    }

    /// Gets the carrier power state.
    ///
    /// - Returns: Returns the carrier power state.
    ///
    public func getCps() -> UInt8 {
        return UInt8(cps & AlternativeCarrierRecord.cpsMask)
    }

    /// Sets the carrier power state.
    ///
    /// - Parameter cps: A 2-bit field carrier power state.
    ///
    public func setCps(cps: UInt8) {
        self.cps = cps
    }

    /// Gets the carrier data references.
    ///
    /// - Returns: Returns the carrier data references.
    ///
    public func getCarrierDataReference() -> DataReference? {
        return carrierDataReference
    }

    /// Sets the carrier data references.
    ///
    /// - Parameter carrierDataReference: Carrier data references.
    ///
    public func setCarrierDataReference(carrierDataReference: DataReference) {
        self.carrierDataReference = carrierDataReference
    }

    /// Gets the auxiliary data references.
    ///
    /// - Returns: Returns the auxiliary data references.
    ///
    public func getAuxiliaryDataReferences() -> [DataReference] {
        return auxiliaryDataReferences
    }

    /// Gets the auxiliary data references count.
    ///
    /// - Returns: Returns the auxiliary data references count.
    ///
    public func getAuxiliaryDataReferencesCount() -> Int {
        return auxiliaryDataReferences.count
    }

    /// Add new auxiliary data reference to the list.
    ///
    /// - Parameter auxiliaryDataReference: Auxiliary data reference.
    ///
    public func addAuxiliaryDataReference(auxiliaryDataReference: DataReference) {
        auxiliaryDataReferences.append(auxiliaryDataReference)
    }
}
