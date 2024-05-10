# APDU Swift Library
This library offers utilities to encode and decode [APDU](https://en.wikipedia.org/wiki/Smart_card_application_protocol_data_unit) objects as well as their responses.

In smart card applications a host typically sends binary `APDU` data to a secure element and reads back a response. This binary data may be somewhat difficult to create and understand depending on the length of the data, etc. This library can be used to work with `APDU`s in a more generic and structured way.

## Example

1. Include headers

```swift
import Foundation
import InfineonApdu
import InfineonLogger
```
2. Create a logger 
 refers to `hsw-logger-swift/README.md` example section for creating a logger

```swift
//TODO: Implement example logger 
```

Initialize the created logger.

```swift
//Initialize the Logger
let exampleLogger : ExampleLogger = ExampleLogger()
//Set the log level (The logger levels, in order of increasing verbosity, are: `none`, `error`, `warning`, `info`, `debug`, and `all`)
exampleLogger.setLogLevel(loggerLevel: LoggerLevel.info)
```

3. Create a communication channel
   refers to `hsw-channel-swift/README.md` example section for creating a communication channel
        
```swift
//TODO: Implement example communication channel (For example, PCSC and NFC) 
```

Initialize the created communication channel.

```swift
//Initialize the Channel
let exampleChannel = ExampleChannel()
// Initialize the APDU channel with communication channel and logger
let apduChannel = ApduChannel(channel : ctkChannel, logger: exampleLogger) 
```

4. Initialize the command set

```swift
let aid = Data([0xd2, 0x76, 0x00, 0x00, 0x85, 0x01, 0x01])
let apduCommandSet = try ApduCommandSet(aid: aid, channel: apduChannel)
_ = try await apduCommandSet.connect(data: nil)
let apduCommand = try ApduCommand(
    cla: 0x00, ins: 0xa4, param1: 0x04, param2: 0x02,
    data: ApduUtils.toData(stream: aid), lengthExpected: ApduCommand.leAny)
//Log the Apdu cammand
exampleLogger.info(header: "APDU command", data: apduCommand.getData())
let apduResponse = try await apduCommandSet.send(apduCommand: apduCommand)
// Checks APDU Status word(SW) success, else throws an error
_ = try apduResponse.checkStatus() // Returns the Apdu response object
_ = apduResponse.getSW() // Returns response status word
//Log the Apdu response
exampleLogger.info(header: "APDU response", data: apduResponse.getData())
for b in apduResponse.toData() {
    print(String(format: "%02x", b))
}
```
