// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/**
 *  NFC Data Exchange Format (NDEF) Record.
 *   Contains the Following parameters or fields
 *
 *  **Payload Length** :  Regardless of the relationship of the record to other record, 
 *  the Payload length always indicated the length of the payload encapsulated in this record.
 *
 *  **Payload Type**:  The Payload  Type of a record indicates the
 *  kind of data being carried in the payload of that record. This may be
 *  used to guide the processing of the payload at the description of the user application.
 *
 *  **Payload Identification**: The optional payload identifier
 *  allows user application to identify the payload carried within an NDEF record.
 *  By providing a payload identifier. it becomes  possible for other payloads supporting
 *  URI-Based Linking technologies to refer to that payload.
 *
 *  **TNF Type Name Format**  : The TNF field value indicates the structure of
 *  the value of the Type Field. The TNF field is 3-bit field.
 *  ## Following are the types of TNF supported
 *
 *      1. Empty : 0x00
 *      2. NFC Forum well-Known type [NFC RTD ] : 0x01
 *      3. Media-Type as defined in RFC 2046 [RFC 2046] : 0x02
 *      4. Absolute URI as Defined In RFC 3986 [RFC 3986] : 0x03
 *      5. NFC Forum external Type [NFC RTD ] : 0x04
 *      6. unknown : 0x05
 *      7. unchanged : 0x06
 *      8. Reserved : 0x07
 */
public final class NdefRecord: AbstractRecord {
    /// This constructor is used to create NDEF Record. Each Record is made
    /// up of header such as the record type, and so forth, and the payload,
    /// which contains the content of the message.
    ///
    /// - Parameters:
    ///   - tnf: Record Type Name Format
    ///   - type: Record Type
    ///   - id: Record ID
    ///   - payload: Record Payload Data
    ///
    public init(tnf: UInt8, type: Data, id: Data, payload: Data) {
        super.init(recordType: type, tnf: tnf, id: id, payload: payload, isChuncked: false)
    }

    /// This constructor is used to create a NDEF record. Each record is made
    /// up of a header, which contains message about the record, such as the
    /// record type, length, and so forth, and the payload, which contains the
    /// content of the message.
    ///
    /// - Parameters:
    ///   - tnf: Record Type Name Format
    ///   - isChuncked: Specifies whether the data is chunk
    ///   - type: Record Type
    ///   - id: Record ID
    ///   - payload: Record Payload Data
    ///
    public init(tnf: UInt8, isChuncked: Bool, type: Data, id: Data, payload: Data) {
        super.init(recordType: type, tnf: tnf, id: id, payload: payload, isChuncked: isChuncked)
    }
}
