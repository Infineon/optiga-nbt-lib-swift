// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Contains utility methods used for NDEF parsing
public enum RecordUtils {
    /// Private instance to store the payload encoders with respect to the record type.
    private static var payloadEncoderList: [(String, IRecordPayloadEncoder)] = {
        var encoders = [(String, IRecordPayloadEncoder)]()
        encoders.append((UriRecord.uriType,
                         UriRecordPayloadEncoder()))
        encoders.append((HandoverSelectRecord.handoverSelectType,
                         HandoverSelectRecordPayloadEncoder()))
        encoders.append((ErrorRecord.errorRecordType,
                         ErrorRecordPayloadEncoder()))
        encoders.append((AlternativeCarrierRecord.alternativeCarrierRecordType,
                         AlternativeCarrierRecordPayloadEncoder()))
        encoders.append((BluetoothLeRecord.bleType,
                         BluetoothLeRecordPayloadEncoder()))
        encoders.append((BluetoothRecord.bluetoothType,
                         BluetoothRecordPayloadEncoder()))
        return encoders
    }()

    /// Private instance to store the payload decoders with respect to the record type.
    private static var payloadDecoderList: [(String, IRecordPayloadDecoder)] = {
        var decoders = [(String, IRecordPayloadDecoder)]()
        decoders.append((UriRecord.uriType,
                         UriRecordPayloadDecoder()))
        decoders.append((HandoverSelectRecord.handoverSelectType,
                         HandoverSelectRecordPayloadDecoder()))
        decoders.append((ErrorRecord.errorRecordType,
                         ErrorRecordPayloadDecoder()))
        decoders.append((AlternativeCarrierRecord.alternativeCarrierRecordType,
                         AlternativeCarrierRecordPayloadDecoder()))
        decoders.append((BluetoothLeRecord.bleType,
                         BluetoothLeRecordPayloadDecoder()))
        decoders.append((BluetoothRecord.bluetoothType,
                         BluetoothRecordPayloadDecoder()))
        return decoders
    }()

    /// Gets the payload encoder from the class
    ///
    /// - Parameter recordType: ``RecordType`` of record
    ///
    /// - Returns: Record payload encoder
    ///
    public static func getPayloadEncoder(recordType: RecordType)
        -> IRecordPayloadEncoder? {
        for encoder in payloadEncoderList where
            encoder.0 == recordType.getTypeAsString() {
                return encoder.1
        }
        return nil
    }

    /// Gets the payload decoder
    ///
    /// - Parameter recordType: ``RecordType`` of record
    ///
    /// - Returns: Record payload decoder
    ///
    public static func getPayloadDecoder(recordType: RecordType)
        -> IRecordPayloadDecoder? {
        for decoder in payloadDecoderList where
            decoder.0 == recordType.getTypeAsString() {
                return decoder.1
        }
        return nil
    }

    /// Registers the payload encoder. This method registers the encoder for
    /// the given record type to the payload encoder list.
    ///
    /// - Parameters:
    ///   - recordType: Type of record.
    ///   - encoder: Record specific payload encoder.
    ///
    /// **Note**: If record typeis already present it will replace with a new encoder.
    public static func registerEncoder(recordType: String,
                                       encoder: IRecordPayloadEncoder) {
        payloadEncoderList.append((recordType, encoder))
    }

    /// Registers the payload decoder. This method registers the
    /// decoder for the given record type to the payload decoder list.
    /// - Parameters:
    ///   - recordType: Record type for which decoder is to be
    ///   added to the payload decoder list.
    ///   - decoder: Record specific payload decoder.
    ///
    /// **Note**: If record type is already present it will replace with a new decoder.
    public static func registerDecoder(recordType: String,
                                       decoder: IRecordPayloadDecoder) {
        payloadDecoderList.append((recordType, decoder))
    }
}
