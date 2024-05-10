// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Enumeration represent appearance category assigned values within the assigned
/// ranges of appearance categories.
///
public enum AppearanceCategory: UInt16 {
    /// Unknown appearance category
    case unknown = 0x0000

    /// Phone appearance category
    case phone = 0x0040

    /// Computer appearance category
    case computer = 0x0080

    /// Desktop workstation appearance category
    case desktopWorkstation = 0x0081

    /// Server class computer appearance category
    case serverClassComputer = 0x0082

    /// Laptop appearance category
    case laptop = 0x0083

    /// Handheld PC/PDA (clamshell) appearance category
    case handheldPcOrPdaClamshell = 0x0084

    /// Palm size PC/PDA appearance category
    case palmSizePcOrPda = 0x0085

    /// Wearable computer (watch size) appearance category
    case wearableComputerWatchSize = 0x0086

    /// Tablet appearance category
    case table = 0x0087

    /// Docking station appearance category
    case dockingStation = 0x0088

    /// All in one appearance category
    case allInOne = 0x0089

    /// Blade server appearance category
    case bladeServer = 0x008a

    /// Convertible appearance category
    case convertible = 0x008b

    /// Detachable appearance category
    case detachable = 0x008c

    /// IoT gateway appearance category
    case iotGateway = 0x008d

    /// Mini PC appearance category
    case miniPc = 0x008e

    /// Stick PC appearance category
    case stickPc = 0x008f

    /// Watch appearance category
    case watch = 0x00c0

    /// Sports watch appearance category
    case sportsWatch = 0x00c1

    /// Smart watch appearance category
    case smartwatch = 0x00c2

    /// Clock appearance category
    case clock = 0x0100

    /// Display appearance category
    case display = 0x0140

    /// Remote control appearance category
    case remoteControl = 0x0180

    /// Eye-glasses appearance category
    case eyeGlasses = 0x01c0

    /// Tag appearance category
    case tag = 0x0200

    /// Keyring appearance category
    case keyring = 0x0240

    /// Media player appearance category
    case mediaPlayer = 0x0280

    /// Generic barcode scanner appearance category
    case genericBarcodeScanner = 0x02c0

    /// Thermometer appearance category
    case thermometer = 0x0300

    /// Ear thermometer appearance category
    case earThermometer = 0x0301

    /// Heart rate sensor appearance category
    case heartRateSensor = 0x0340

    /// Heart rate Belt appearance category
    case heartRateBelt = 0x0341

    /// Blood pressure appearance category
    case bloodPressure = 0x0380

    /// Arm blood pressure appearance category
    case armBloodPressure = 0x0381

    /// Wrist blood pressure appearance category
    case wristBloodPressure = 0x0382

    /// Human interface device appearance category
    case humanInterfaceDevice = 0x03c0

    /// Keyboard appearance category
    case keyboard = 0x03c1

    /// Mouse appearance category
    case mouse = 0x03c2

    /// Joystick appearance category
    case joystick = 0x03c3

    /// Game pad appearance category
    case gamePad = 0x03c4

    /// Digitizer tablet appearance category
    case digitizerTablet = 0x03c5

    /// Card reader appearance category
    case cardReader = 0x03c6

    /// Digital pen appearance category
    case digitalPen = 0x03c7

    /// Barcode scanner appearance category
    case barcodeScanner = 0x03c8

    /// Touch pad appearance category
    case touchPad = 0x03c9

    /// Presentation remote appearance category
    case presentationRemote = 0x03ca

    /// Glucose meter appearance category
    case glucoseMeter = 0x0400

    /// Running walking sensor appearance category
    case runningWalkingSensor = 0x0440

    /// In shoe running walking sensor appearance category
    case inShoeRunningWalkingSensor = 0x0441

    /// On shoe running walking sensor appearance category
    case onShoeRunningWalkingSensor = 0x0442

    /// On hip running walking sensor appearance category
    case onHipRunningWalkingSensor = 0x0443

    /// Cycling appearance category
    case cycling = 0x0480

    /// Cycling compute appearance category
    case cyclingCompute = 0x0481

    /// Speed sensor appearance category
    case speedSensor = 0x0482

    /// Cadence sensor appearance category
    case cadenceSensor = 0x0483

    /// Power sensor appearance category
    case powerSensor = 0x0484

    /// Speed and cadence sensor appearance category
    case speedAndCadenceSensor = 0x0485

    /// Control device appearance category
    case controlDevice = 0x04c0

    /// Switch appearance category
    case SWITCH = 0x04c1

    /// Multi switch appearance category
    case multiSwitch = 0x04c2

    /// Button appearance category
    case button = 0x04c3

    /// Slider appearance category
    case slider = 0x04c4

    /// Rotary switch appearance category
    case rotarySwitch = 0x04c5

    /// Touch panel appearance category
    case touchPanel = 0x04c6

    /// Single switch appearance category
    case singleSwitch = 0x04c7

    /// Double switch appearance category
    case doubleSwitch = 0x04c8

    /// Triple switch appearance category
    case tripleSwitch = 0x04c9

    /// Battery switch appearance category
    case batterySwitch = 0x04ca

    /// Energy harvesting Switch appearance category
    case energyHarvestingSwitch = 0x04cb

    /// Push button appearance category
    case pushButton = 0x04cc

    /// Network device appearance category
    case networkDevice = 0x0500

    /// Access point appearance category
    case accessPoint = 0x0501

    /// Mesh device appearance category
    case meshDevice = 0x0502

    /// Mesh network Proxy appearance category
    case meshNetworkProxy = 0x0503

    /// Sensor appearance category
    case sensor = 0x0540

    /// Motion sensor appearance category
    case motionSensor = 0x0541

    /// Air quality sensor appearance category
    case airQualitySensor = 0x0542

    /// Temperature sensor appearance category
    case temperatureSensor = 0x0543

    /// Humidity sensor appearance category
    case humiditySensor = 0x0544

    /// Leak sensor appearance category
    case leakSensor = 0x0545

    /// Smoke sensor appearance category
    case smokeSensor = 0x0546

    /// Occupancy sensor appearance category
    case occupancySensor = 0x0547

    /// Contact sensor appearance category
    case contactSensor = 0x0548

    /// Carbon monoxide sensor appearance category
    case carbonMonoxideSensor = 0x0549

    /// Carbon dioxide sensor appearance category
    case carbonDioxideSensor = 0x054a

    /// Ambient light sensor appearance category
    case ambientLightSensor = 0x054b

    /// Energy sensor appearance category
    case energySensor = 0x054c

    /// Color light sensor appearance category
    case colorLightSensor = 0x054d

    /// Rain sensor appearance category
    case rainSensor = 0x054e

    /// Fire sensor appearance category
    case fireSensor = 0x054f

    /// Wind sensor appearance category
    case windSensor = 0x0550

    /// Proximity sensor appearance category
    case proximitySensor = 0x0551

    /// Multi sensor appearance category
    case multiSensorA = 0x0552

    /// Flush mounted sensor appearance category
    case flushMountedSensor = 0x0553

    /// Ceiling mounted sensor appearance category
    case ceilingMountedSensor = 0x0554

    /// Wall mounted sensor appearance category
    case wallMountedSensor = 0x0555

    /// Multi sensor appearance category
    case multiSensorB = 0x0556

    /// Energy meter appearance category
    case energyMeter = 0x0557

    /// Flame detector appearance category
    case flameDetector = 0x0558

    /// Vehicle tire pressure sensor appearance category
    case vehicleTirePressureSensor = 0x0559

    /// Light fixtures appearance category
    case lightFixtures = 0x0580

    /// Wall light appearance category
    case wallLight = 0x0581

    /// Ceiling light appearance category
    case ceilingLight = 0x0582

    /// Floor light appearance category
    case floorLight = 0x0583

    /// Cabinet light appearance category
    case cabinetLight = 0x0584

    /// Desk light appearance category
    case deskLight = 0x0585

    /// Troffer light appearance category
    case trofferLight = 0x0586

    /// Pendant light appearance category
    case pendantLight = 0x0587

    /// In ground light appearance category
    case inGroundLight = 0x0588

    /// Flood light appearance category
    case floodLight = 0x0589

    /// Underwater light appearance category
    case underwaterLight = 0x058a

    /// Bollard with light appearance category
    case bollardWithLight = 0x058b

    /// Pathway light appearance category
    case pathwayLight = 0x058c

    /// Garden light appearance category
    case gardenLight = 0x058d

    /// Pole top light appearance category
    case poleTopLight = 0x058e

    /// Spot light appearance category
    case spotlight = 0x058f

    /// Linear light appearance category
    case linearLight = 0x0590

    /// Street light appearance category
    case streetLight = 0x0591

    /// Shelves light appearance category
    case shelvesLight = 0x0592

    /// Bay light appearance category
    case bayLight = 0x0593

    /// Emergency exit light appearance category
    case emergencyExitLight = 0x0594

    /// Light controller appearance category
    case lightController = 0x0595

    /// Light driver appearance category
    case lightDriver = 0x0596

    /// Bulb appearance category
    case bulb = 0x0597

    /// Low bay light appearance category
    case lowBayLight = 0x0598

    /// High bay light appearance category
    case highBayLight = 0x0599

    /// Fan appearance category
    case fan = 0x05c0

    /// Ceiling Fan appearance category
    case ceilingFan = 0x05c1

    /// Axial fan appearance category
    case axialFan = 0x05c2

    /// Exhaust fan appearance category
    case exhaustFan = 0x05c3

    /// Pedestal fan appearance category
    case pedestalFan = 0x05c4

    /// Desk fan appearance category
    case deskFan = 0x05c5

    /// Wall fan appearance category
    case wallFan = 0x05c6

    /// HVAC appearance category
    case hvac = 0x0600

    /// Thermostat appearance category
    case thermostat = 0x0601

    /// Humidifier appearance category
    case humidifier = 0x0602

    /// Dehumidifier appearance category
    case deHumidifier = 0x0603

    /// Heater appearance category
    case heater = 0x0604

    /// HVAC radiator appearance category
    case hvacRadiator = 0x0605

    /// HVAC boiler appearance category
    case hvacBoiler = 0x0606

    /// HVAC heat pump appearance category
    case heatPump = 0x0607

    /// HVAC infrared heater appearance category
    case hvacInfraredHeater = 0x0608

    /// HVAC radiant panel heater appearance category
    case hvacRadiantPanelHeater = 0x0609

    /// HVAC fan heater appearance category
    case hvacFanHeater = 0x060a

    /// HVAC air curtain appearance category
    case hvacAirCurtain = 0x060b

    /// Air conditioning appearance category
    case airConditioning = 0x0640

    /// Generic humidifier appearance category
    case genericHumidifier = 0x0680

    /// Heating appearance category
    case heating = 0x06c0

    /// Heating radiator appearance category
    case heatingRadiator = 0x06c1

    /// Heating boiler appearance category
    case heatingBoiler = 0x06c2

    /// Heating heat pump appearance category
    case heatingHeatPump = 0x06c3

    /// Heating infrared heater appearance category
    case heatingInfraredHeater = 0x06c4

    /// Heating radiant panel heater appearance category
    case heatingRadiantPanelHeater = 0x06c5

    /// Heating fan heater appearance category
    case heatingFanHeater = 0x06c6

    /// Heating air curtain appearance category
    case heatingAirCurtain = 0x06c7

    /// Access control appearance category
    case accessControl = 0x0700

    /// Access door appearance category
    case accessDoor = 0x0701

    /// Garage door appearance category
    case garageDoor = 0x0702

    /// Emergency exit door appearance category
    case emergencyExitDoor = 0x0703

    /// Access lock appearance category
    case accessLock = 0x0704

    /// Elevator appearance category
    case elevator = 0x0705

    /// Window appearance category
    case window = 0x0706

    /// Entrance gate appearance category
    case entranceGate = 0x0707

    /// Door lock appearance category
    case doorLock = 0x0708

    /// Locker appearance category
    case locker = 0x0709

    /// Motorized device appearance category
    case motorizedDevice = 0x0740

    /// Motorized gate appearance category
    case motorizedGate = 0x0741

    /// Awning appearance category
    case awning = 0x0742

    /// Blinds or shades appearance category
    case blindsOrShades = 0x0743

    /// Curtains appearance category
    case curtains = 0x0744

    /// Screen appearance category
    case screen = 0x0745

    /// Power device appearance category
    case powerDevice = 0x0780

    /// Power outlet appearance category
    case powerOutlet = 0x0781

    /// Power strip appearance category
    case powerStrip = 0x0782

    /// Plug appearance category
    case plug = 0x0783

    /// Power Supply appearance category
    case powerSupply = 0x0784

    /// LED Driver appearance category
    case ledDriver = 0x0785

    /// Fluorescent Lamp Gear appearance category
    case fluorescentLampGear = 0x0786

    /// HID lamp Gear appearance category
    case hidLampGear = 0x0787

    /// Charge case appearance category
    case chargeCase = 0x0788

    /// Power bank appearance category
    case powerBank = 0x0789

    /// Light source appearance category
    case lightSource = 0x07c0

    /// Incandescent Light Bulb appearance category
    case incandescentLightBulb = 0x07c1

    /// LED lamp appearance category
    case ledLamp = 0x07c2

    /// HID lamp appearance category
    case hidLamp = 0x07c3

    /// Fluorescent Lamp appearance category
    case fluorescentLamp = 0x07c4

    /// LED Array appearance category
    case ledArray = 0x07c5

    /// MultiColor LED Array appearance category
    case multicolorLedArray = 0x07c6

    /// Low voltage halogen appearance category
    case lowVoltageHalogen = 0x07c7

    /// Organic light emitting diode (OLED) appearance category
    case organicLightEmittingDiodeOled = 0x07c8

    /// Window covering appearance category
    case windowCovering = 0x0800

    /// Window shades appearance category
    case windowShades = 0x0801

    /// Window blinds appearance category
    case windowBlinds = 0x0802

    /// Window awning appearance category
    case windowAwning = 0x0803

    /// Window curtain appearance category
    case windowCurtain = 0x0804

    /// Exterior shutter appearance category
    case exteriorShutter = 0x0805

    /// Exterior screen appearance category
    case exteriorScreen = 0x0806

    /// Audio sink appearance category
    case audioSink = 0x0840

    /// Standalone speaker appearance category
    case standaloneSpeaker = 0x0841

    /// Soundbar appearance category
    case soundbar = 0x0842

    /// Bookshelf Speaker appearance category
    case bookshelfSpeaker = 0x0843

    /// Stand mounted Speaker appearance category
    case standMountedSpeaker = 0x0844

    /// Speaker phone appearance category
    case speakerPhone = 0x0845

    /// Audio Source appearance category
    case audioSource = 0x0880

    /// Microphone appearance category
    case microphone = 0x0881

    /// Alarm appearance category
    case alarm = 0x0882

    /// Bell appearance category
    case bell = 0x0883

    /// Horn appearance category
    case horn = 0x0884

    /// Broadcasting Device appearance category
    case broadcastingDevice = 0x0885

    /// Service Desk appearance category
    case serviceDesk = 0x0886

    /// Kiosk appearance category
    case kiosk = 0x0887

    /// Broadcasting Room appearance category
    case broadcastingRoom = 0x0888

    /// Auditorium appearance category
    case auditorium = 0x0889

    /// Motorized vehicle appearance category
    case motorizedVehicle = 0x08c0

    /// Car appearance category
    case car = 0x08c1

    /// Large goods vehicle appearance category
    case largeGoodsVehicle = 0x08c2

    /// 2 Wheeled vehicle appearance category
    case twoWheeledVehicle = 0x08c3

    /// Motorbike appearance category
    case motorbike = 0x08c4

    /// Scooter appearance category
    case scooter = 0x08c5

    /// Moped appearance category
    case moped = 0x08c6

    /// 3 Wheeled vehicle appearance category
    case threeWheeledVehicle = 0x08c7

    /// Light Vehicle appearance category
    case lightVehicle = 0x08c8

    /// Quad bike appearance category
    case quadBike = 0x08c9

    /// Minibus appearance category
    case minibus = 0x08ca

    /// Bus appearance category
    case bus = 0x08cb

    /// Trolley appearance category
    case trolley = 0x08cc

    /// Agricultural vehicle appearance category
    case agriculturalVehicle = 0x08cd

    /// Camper OR caravan appearance category
    case camperOrCaravan = 0x08ce

    /// Recreational vehicle or motor home appearance category
    case recreationalVehicleOrMotorHome = 0x08cf

    /// Domestic appliance appearance category
    case domesticAppliance = 0x0900

    /// Refrigerator appearance category
    case refrigerator = 0x0901

    /// Freezer appearance category
    case freezer = 0x0902

    /// Oven appearance category
    case oven = 0x0903

    /// Microwave appearance category
    case microwave = 0x0904

    /// Toaster appearance category
    case toaster = 0x0905

    /// Washing Machine appearance category
    case washingMachine = 0x0906

    /// Dryer appearance category
    case dryer = 0x0907

    /// Coffee maker appearance category
    case coffeeMaker = 0x0908

    /// Clothes iron appearance category
    case clothesIron = 0x0909

    /// Curling iron appearance category
    case curlingIron = 0x090a

    /// Hair dryer appearance category
    case hairDryer = 0x090b

    /// Vacuum cleaner appearance category
    case vacuumCleaner = 0x090c

    /// Robotic vacuum cleaner appearance category
    case roboticVacuumCleaner = 0x090d

    /// Rice cooker appearance category
    case riceCooker = 0x090e

    /// Clothes steamer appearance category
    case clothesSteamer = 0x090f

    /// Wearable audio device appearance category
    case wearableAudioDevice = 0x0940

    /// Earbud appearance category
    case earbud = 0x0941

    /// Headset appearance category
    case headset = 0x0942

    /// Headphones appearance category
    case headphones = 0x0943

    /// Neck band appearance category
    case neckBand = 0x0944

    /// Aircraft appearance category
    case aircraft = 0x0980

    /// Light aircraft appearance category
    case lightAircraft = 0x0981

    /// Microlight appearance category
    case microlight = 0x0982

    /// Paraglider appearance category
    case paraglider = 0x0983

    /// Large passenger aircraft appearance category
    case largePassengerAircraft = 0x0984

    /// AV equipment appearance category
    case avEquipment = 0x09c0

    /// Amplifier appearance category
    case amplifier = 0x09c1

    /// Receiver appearance category
    case receiver = 0x09c2

    /// Radio appearance category
    case radio = 0x09c3

    /// Tuner appearance category
    case tuner = 0x09c4

    /// Turntable appearance category
    case turntable = 0x09c5

    /// CD player appearance category
    case cdPlayer = 0x09c6

    /// DVD player appearance category
    case dvdPlayer = 0x09c7

    /// Blu ray player appearance category
    case bluRayPlayer = 0x09c8

    /// Optical disc player appearance category
    case opticalDiscPlayer = 0x09c9

    /// Set top box appearance category
    case setTopBox = 0x09ca

    /// Display equipment appearance category
    case displayEquipment = 0x0a00

    /// Television appearance category
    case television = 0x0a01

    /// Monitor appearance category
    case monitor = 0x0a02

    /// Projector appearance category
    case projector = 0x0a03

    /// Hearing aid appearance category
    case hearingAid = 0x0a40

    /// In ear hearing aid appearance category
    case inEarHearingAid = 0x0a41

    /// Behind ear hearing aid appearance category
    case behindEarHearingAid = 0x0a42

    /// Cochlear implant appearance category
    case cochlearImplant = 0x0a43

    /// Generic gaming appearance category
    case genericGaming = 0x0a80

    /// Home video game console appearance category
    case homeVideoGameConsole = 0x0a81

    /// Portable handheld console appearance category
    case portableHandheldConsole = 0x0a82

    /// Generic asignage appearance category
    case genericSignage = 0x0ac0

    /// Digital signage appearance category
    case digitalSignage = 0x0ac1

    /// Electronic label appearance category
    case electronicLabel = 0x0ac2

    /// Generic pulse oximeter appearance category
    case genericPulseOximeter = 0x0c40

    /// Fingertip pulse oximeter appearance category
    case fingertipPulseOximeter = 0x0c41

    /// Wrist worn pulse oximeter appearance category
    case wristWornPulseOximeter = 0x0c42

    /// Generic weight scale appearance category
    case genericWeightScale = 0x0c80

    /// Generic personal mobility device appearance category
    case genericPersonalMobilityDevice = 0x0cc0

    /// Powered wheelchair appearance category
    case poweredWheelchair = 0x0cc1

    /// Mobility scooter appearance category
    case mobilityScooter = 0x0cc2

    /// Generic continuous glucose monitor appearance category
    case genericContinuousGlucoseMonitor = 0x0d00

    /// Generic insulin pump appearance category
    case genericInsulinPump = 0x0d40

    /// Insulin pump and durable pump appearance category
    case insulinPumpAndDurablePump = 0x0d41

    /// Insulin pump and patch pump appearance category
    case insulinPumpAndPatchPump = 0x0d44

    /// Insulin pen appearance category
    case insulinPen = 0x0d48

    /// Generic medication delivery appearance category
    case genericMedicationDelivery = 0x0d80

    /// Generic outdoor sports activity appearance category
    case genericOutdoorSportsActivity = 0x1440

    /// Location display appearance category
    case locationDisplay = 0x1441

    /// Location and navigation display appearance category
    case locationAndNavigationDisplay = 0x1442

    /// Location pod appearance category
    case locationPod = 0x1443

    /// Location and navigation pod appearance category
    case locationAndNavigationPod = 0x1444

    public func getName() -> String {
        return String(describing: self).replacingOccurrences(of: "_", with: " ")
    }

    /// Gets the enumeration with respect to the value.
    ///
    /// - Parameter value: Known enumeration value
    /// - Returns: Returns the enumeration registers with respect to the value.
    ///
    public static func getEnumByValue(value: UInt16) -> AppearanceCategory? {
        if let enumCategory = AppearanceCategory(rawValue: value) {
            return enumCategory
        }
        return nil
    }
}
