// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Stores the constants used in the NBT library.
public enum NbtConstants {
    /// AID of the NBT application
    public static let aid: Data = .init([0xd2, 0x76, 0x00, 0x00,
                                  0x85, 0x01, 0x01])

    /// AID of the NBT product configuration application
    public static let configuratorAid: Data = .init([0xd2, 0x76,
                                               0x00, 0x00, 0x04, 0x15,
                                               0x02, 0x00, 0x00, 0x0b,
                                               0x00, 0x01, 0x01])

    /// First five bits of byte are set to mask password ID for
    /// change/unblock password.
    public static let idMaskBits: UInt8 = 0x1f

    /// FAP File ID
    public static let fapFileId: UInt16 = 0xe1af

    /// NDEF File ID
    public static let ndefFileId: UInt16 = 0xe104

    /// Class byte for the NBT command: General.
    public static let cla: UInt8 = 0x00

    /// Class byte for the product configuration Set/Get APDU.
    public static let claConfiguration: UInt8 = 0x20

    /// Instruction byte for the NBT command: Select file.
    public static let insSelect: UInt8 = 0xa4

    /// Instruction byte for the NBT command: Create password.
    public static let insCreatePwd: UInt8 = 0xe1

    /// Instruction byte for the NBT command: Personalize data.
    public static let insPersonalizeData: UInt8 = 0xe2

    /// Instruction byte for the NBT command: Update binary.
    public static let insUpdateBinary: UInt8 = 0xd6

    /// Instruction byte for the NBT command: Read binary.
    public static let insReadBinary: UInt8 = 0xb0

    /// Instruction byte for the NBT command: Delete password.
    public static let insDeletePwd: UInt8 = 0xe4

    /// Instruction byte for the NBT command: Authenticate tag.
    public static let insAuthenticateTag: UInt8 = 0x88

    /// Instruction byte for the NBT command: Unblock password.
    public static let insUnblockPassword: UInt8 = 0x24

    /// Instruction byte for the NBT command: Get data.
    public static let insGetData: UInt8 = 0x30

    /// Instruction byte for the NBT command: Change password.
    public static let insChangePassword: UInt8 = 0x24

    /// Instruction byte for the product configuration Set APDU.
    public static let insSetConfiguration: UInt8 = 0x20

    /// Instruction byte for the product configuration Get APDU.
    public static let insGetConfiguration: UInt8 = 0x30

    /// The reference control parameter P1 for the NBT command: Wherever 00 is
    /// passed.
    public static let p1Default: UInt8 = 0x00

    /// P1 for the select application command.
    public static let p1SelectApplication: UInt8 = 0x04

    /// The reference control parameter P2 for the NBT command: Wherever 00 is
    /// passed.
    public static let p2Default: UInt8 = 0x00

    /// The reference control parameter tag for the NBT command: Get data with
    /// applet version.
    public static let tagAppletVersion: UInt16 = 0xdf3a

    /// The reference control parameter tag for the NBT command: Get data with
    /// available memory.
    public static let tagAvailableMemory: UInt16 = 0xdf3b

    /// The reference control parameter P2 for the NBT command: Select only first
    /// occurrence.
    public static let p2SelectFirst: UInt8 = 0x0c

    /// The reference control parameter P2 for the NBT command: bit 7 is set for
    /// change password.
    public static let p2ChangePwd: UInt8 = 0x40

    /// The APDU expected response length(Le) for the NBT commands, if Le is not
    /// needed.
    public static let leAbsent: UInt8 = 0x00

    /// The APDU expected response length(Le) for the NBT commands, if expected
    /// length 0 is present in Le.
    public static let leAny: UInt16 = 256

    /// Constant defines the length of read or write password field.
    public static let pwdLength: UInt8 = 0x04

    /// Constant defines the length of policy bytes field.
    public static let policyFieldLength: UInt8 = 0x04

    /// Constant defines the length of File ID.
    public static let fileIdLength: UInt8 = 0x02

    /// Constant defines the LC as null, if LC is not present.
    public static let lcNotPresent: Any? = nil

    /// TAG defines a password as read password.
    public static let tagPwdRead: UInt8 = 0x52

    /// TAG defines a password as write password.
    public static let tagPwdWrite: UInt8 = 0x54

    /// Constant of the offset denoting the start of file.
    public static let offsetFileStart: UInt16 = 0x0000

    /// First five bits of byte are set to mask password ID passed by user in
    /// case of change/block password.
    public static let passwordIdMask: UInt8 = 0x1f

    /// Constant defines the length of password length bytes field.
    public static let passwordLength: UInt8 = 0x04

    /// Constant defines the LC as to get a specific configuration value.
    public static let lcGetConfiguration: UInt8 = 0x02

    /// Constant for the empty string.

    public static let emptyString: String = ""

    /// Constant defines the LC as 0D for product configurator.
    public static let configuratorAidLength: UInt8 = 0x0d

    /// Constant defines the offset value pointing to start of file.
    public static let fileStartOffset: UInt16 = 0x0000

    /// Constant defines the offset value pointing to start of NDEF message in
    /// file.
    public static let t4tNdefMsgStartOffset: UInt16 = 0x0002

    /// Constant defines the maximum possible LE value.
    public static let maxLe: UInt16 = 0x0100

    /// Constant defines the maximum possible LC value.
    public static let maxLc: UInt16 = 0x00ff

    /// Enumeration defines the list of tags and length of the configuration data.
    public enum ConfigurationTags: UInt16 {
        /// Tag ID for the product short name
        case tagProductShortName = 0xc020

        /// Tag ID for the product life cycle
        case tagProductLifeCycle = 0xc021

        /// Tag ID for the software version information
        case tagSwVersionInfo = 0xc022

        /// Tag ID for the Flash Loader
        case tagFlashLoader = 0xc02f

        /// Tag ID for the GPIO function
        case tagGpioFunction = 0xc030

        /// Tag ID for the GPIO assert level
        case tagGpioAssertLevel = 0xc031

        /// Tag ID for the GPIO output type
        case tagGpioOutputType = 0xc032

        /// Tag ID for the GPIO pull type
        case tagGpioPullType = 0xc033

        /// Tag ID for the I2C idle timeout
        case tagI2cIdleTimeout = 0xc040

        /// Tag ID for the I2C drive strength
        case tagI2cDriveStrength = 0xc041

        /// Tag ID for the I2C speed
        case tagI2cSpeed = 0xc042

        /// Tag ID for the NFC IRQ event type
        case tagNfcIrqEventType = 0xc034

        /// Tag ID for the NFC ATS configuration
        case tagNfcAtsConfiguration = 0xc050

        /// Tag ID for the NFC WTX mode
        case tagNfcWtxMode = 0xc051

        /// Tag ID for the NFC RF hardware configuration
        case tagNfcRfHwConfiguration = 0xc052

        /// Tag ID for the NFC UID type for anti collision
        case tagNfcUidTypeForAntiCollision = 0xc053

        /// Tag ID for the communication interface
        case tagCommunicationInterfaceEnable = 0xc060

        public var length: Int {
            switch self {
            /// Tag ID for the product short name
            case .tagProductShortName:
                return 16

            /// Tag ID for the product life cycle
            case .tagProductLifeCycle:
                return 2

            /// Tag ID for the software version information
            case .tagSwVersionInfo:
                return 8

            /// Tag ID for the Flash Loader
            case .tagFlashLoader:
                return 2

            /// Tag ID for the GPIO function
            case .tagGpioFunction:
                return 1

            /// Tag ID for the GPIO assert level
            case .tagGpioAssertLevel:
                return 1

            /// Tag ID for the GPIO output type
            case .tagGpioOutputType:
                return 1

            /// Tag ID for the GPIO pull type
            case .tagGpioPullType:
                return 1

            /// Tag ID for the I2C idle timeout
            case .tagI2cIdleTimeout:
                return 4

            /// Tag ID for the I2C drive strength
            case .tagI2cDriveStrength:
                return 1

            /// Tag ID for the I2C speed
            case .tagI2cSpeed:
                return 1

            /// Tag ID for the NFC IRQ event type
            case .tagNfcIrqEventType:
                return 1

            /// Tag ID for the NFC ATS configuration
            case .tagNfcAtsConfiguration:
                return 14

            /// Tag ID for the NFC WTX mode
            case .tagNfcWtxMode:
                return 1

            /// Tag ID for the NFC RF hardware configuration
            case .tagNfcRfHwConfiguration:
                return 312

            /// Tag ID for the NFC UID type for anti collision
            case .tagNfcUidTypeForAntiCollision:
                return 1

            /// Tag ID for the communication interface
            case .tagCommunicationInterfaceEnable:
                return 1
            }
        }
    }

    /// Enumeration defines the tag values of product life cycle.
    public enum ConfigProductLifeCycleState: UInt16 {
        /// Value of product life cycle - operational
        case productLifeCycleOperational = 0xc33c

        /// Value of product life cycle - personalization
        case productLifeCyclePersonalization = 0x5aa5
    }

    /// Enumeration defines the configuration values for Flash Loader.
    ///
    /// **Note:** Use this configuration value setting cautiously as this makes
    ///       device go into Flash Loader mode.
    ///       Reverting to application mode is possible, only in engineering
    ///       samples and not in any other samples.
    public enum ConfigFlashLoader: UInt16 {
        /// Configuration value of Flash Loader - Enable
        case flashLoaderEnable = 0xac95

        /// Configuration value of Flash Loader - Disable
        case flashLoaderDisable = 0xffff
    }

    /// Enumeration defines the configuration values of GPIO function.
    public enum ConfigGpioFunction: UInt8 {
        /// Configuration value for the GPIO function - Disabled
        case gpioFunctionDisabled = 0x01

        /// Configuration value for the GPIO function - NFC IRQ output
        case gpioFunctionNfcIrqOutput = 0x02

        /// Configuration value for the GPIO function - I2C data ready IRQ output
        case gpioFunctionI2cDataReadyIrqOutput = 0x03

        /// Configuration value for the GPIO function - NFC I2C pass-through IRQ
        /// output
        case gpioFunctionNfcI2cPassThroughIrqOutput = 0x04
    }

    /// Enumeration defines the configuration values of GPIO assert level.
    public enum ConfigGpioAssertLevel: UInt8 {
        /// Configuration value for the GPIO assert level - Low active
        case gpioAssertLowLevelActive = 0x01

        /// Configuration value for the GPIO assert level - High active
        case gpioAssertHighLevelActive = 0x02
    }

    /// Enumeration defines the configuration values of GPIO output type.
    public enum ConfigGpioOutputType: UInt8 {
        /// Configuration value for the GPIO output type - Push pull
        case gpioOutputTypePushPull = 0x01

        /// Configuration value for the GPIO output type - Open drain
        case gpioOutputTypeOpenDrain = 0x02
    }

    /// Enumeration defines the configuration values of GPIO pull type.
    public enum ConfigGpioPullType: UInt8 {
        /// Configuration value for the GPIO pull type - No pull
        case gpioNoPull = 0x01

        /// Configuration value for the GPIO pull type - Pull up
        case gpioPullUp = 0x02

        /// Configuration value for the GPIO pull type - Pull down
        case gpioPullDown = 0x03
    }

    /// Enumeration defines the configuration values of NFC IRQ event.
    public enum ConfigNfcIrqEventType: UInt8 {
        /// Configuration value for the NFC IRQ event type - Signal field presence
        case nfcIrqEventSignalFieldPresence = 0x01

        /// Configuration value for the NFC IRQ event type - Signal layer 4 entry
        case nfcIrqEventSignalLayer4Entry = 0x02

        /// Configuration value for the NFC IRQ event type - Signal APDU processing
        /// stage
        case nfcIrqEventSignalApduProcessingStage = 0x03
    }

    /// Enumeration defines the tag values of I2C drive strength.
    public enum ConfigI2cDriveStrength: UInt8 {
        /// Configuration value for the I2C drive strength - weak
        case i2cDriveStrengthWeak = 0x01

        /// Configuration value for the I2C drive strength - strong
        case i2cDriveStrengthStrong = 0x02
    }

    /// Enumeration defines the configuration values of I2C speed.
    public enum ConfigI2cSpeed: UInt8 {
        /// Configuration value for the I2C speed - 400 kHz
        case i2cSpeed400Khz = 0x01

        /// Configuration value for the I2C speed - 1000 kHz
        case i2cSpeed1000Khz = 0x02
    }

    /// Enumeration defines the configuration values of NFC uid type for anti
    /// collision.
    public enum ConfigNfcUidTypeForAntiCollision: UInt8 {
        /// Configuration value for the unique 7-byte device specific NFC UID type
        /// for anti collision.
        case uniqueDeviceSpecific7ByteNfcUid = 0x00

        /// Configuration value for the random 4-byte NFC UID Type for anti
        /// collision
        case random4ByteNfcUid = 0x01
    }

    /// Enumeration defines the configuration values of communication interface.
    public enum ConfigCommunicationInterface: UInt8 {
        /// Configuration value for the communication interface - NFC disabled, I2C
        /// enabled
        case commIntfNfcDisabledI2cEnabled = 0x01

        /// Configuration value for the communication interface - NFC enabled, I2C
        /// disabled
        case commIntfNfcEnabledI2cDisabled = 0x10

        /// Configuration value for the communication interface - NFC enabled, I2C
        /// enabled
        case commIntfNfcEnabledI2cEnabled = 0x11
    }
}
