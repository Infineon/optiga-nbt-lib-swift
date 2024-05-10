// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Each NDEF record is an abstract record. Abstract record is used to get/set
/// the record type. Gets the record ID, gets and sets the key value, and gets
/// and sets the type name format.
open class AbstractRecord {
    /// Record identifier meta-data
    public var id = Data()

    /// The variable length type field.
    public var recordType: RecordType?

    /// Type name format (TNF) mask. The TNF field value indicates the structure
    /// of the value of the type field.
    public var recordTnf: UInt8?

    /// The actual payload.
    public var payload: Data?

    /// Application data that has been partitioned into multiple chunks each
    /// carried in a separate NDEF record, where each of these records except the
    /// last has the CF flag set to 1. This facility can be used to carry
    /// dynamically generated content for which the payload size is not known in
    /// advance or very large entities that do not fit into a single NDEF record.
    public var isChuncked: Bool?

    /// Constructor to create an abstract record.
    ///
    /// - Parameters:
    ///   - recordType: Record type of string (For example, "T").
    ///   - tnf: TNF of record
    ///
    public init(recordType: String, tnf: UInt8) {
        self.recordTnf = tnf
        self.recordType = RecordType(type: recordType)
    }

    /// Constructor to create an abstract record.
    ///
    /// - Parameters:
    ///   - recordType: Record type of byte array.
    ///   - tnf: TNF of record
    ///
    public init(recordType: Data, tnf: UInt8) {
        self.recordTnf = tnf
        self.recordType = RecordType(type: recordType)
    }

    /// Constructor to create an abstract record.
    ///
    /// - Parameters:
    ///   - recordType: Record type of byte array.
    ///   - tnf: Record Type Name Format
    ///   - id: Record ID
    ///   - payload: Record Payload Data
    ///   - isChuncked: Specifies whether the data is chunk
    ///
    public init(recordType: Data, tnf: UInt8, id: Data, payload: Data, isChuncked: Bool) {
        self.recordTnf = tnf
        self.recordType = RecordType(type: recordType)
        self.id = id
        self.payload = payload
        self.isChuncked = isChuncked
    }

    /// Gets the type of NDEF record
    ///
    /// - Returns: The type of record
    ///
    public func getRecordType() -> RecordType? {
        return recordType
    }

    /// Method is to set to a specific record type
    ///
    /// - Parameter recordType: sets the type of record
    ///
    public func setRecordType(recordType: RecordType) {
        self.recordType = recordType
    }

    /// Returns the specific record type bytes.
    ///
    /// - Returns: Returns the variable length type field.
    ///
    public func getType() -> Data {
        if let recordType = recordType {
            return recordType.getType()
        } else {
            return Data()
        }
    }

    /// Gets the NDEF record ID
    ///
    /// - Returns: The record id
    ///
    public func getId() -> Data {
        return id
    }

    /// Sets the ID for a well known record
    ///
    /// - Parameter id: sets the record id
    ///
    public func setId(id: Data) {
        self.id = id
    }

    /// Returns true, if the record has a record ID in it.
    ///
    /// - Returns: Returns a status based on key availability.
    ///
    public func hasId() -> Bool { return !id.isEmpty }

    /// Sets the id ID for a NDEF record
    ///
    /// - Parameter id: sets the id value
    ///
    public func setIdAsString(id: String) {
        self.id = id.data(using: NdefConstants.defaultCharset)!
    }

    /// Gets the id type of a NDEF record
    ///
    /// - Returns: The id value as String
    ///
    public func getIdAsString() -> String {
        return String(data: id, encoding: NdefConstants.defaultCharset)!
    }

    /// Sets the type name format for a record
    ///
    /// - Parameter tnf: sets the type name format
    ///
    public func setTnf(tnf: UInt8) {
        recordTnf = tnf
    }

    /// Gets the type name format of a NDEF record
    ///
    /// - Returns: The type name format
    ///
    public func getTnf() -> UInt8? {
        return recordTnf
    }

    /// Returns the record payload bytes.
    ///
    /// - Returns: Returns the record payload bytes.
    ///
    /// **Note**: Use encode payload() method to convert payload to the byte array.
    /// This method will return the existing payload if present and the payload
    /// content will be out-of-sync if the record fields are updated.
    /// The state of the payload byte array is updated only during encode.
    ///
    public func getPayload() -> Data? {
        return payload
    }

    /// Sets the record payload bytes.
    ///
    /// - Parameter payload: The record payload bytes.
    ///
    public func setPayload(payload: Data) {
        self.payload = payload
    }

    /// The CF flag indicates if this is the first record chunk or a middle record
    ///
    /// - Parameter isChunked: The CF flag indicates record is chunked.
    ///
    public func setIsChunked(isChunked: Bool) {
        isChuncked = isChunked
    }

    /// The CF flag indicates if this is the first record chunk or a middle record chunk.
    ///
    /// - Returns: Returns true, if record is chunked.
    ///
    public func getIsChunked() -> Bool {
        if let isChunked = isChuncked {
            return isChunked
        } else {
            return false
        }
    }
}
