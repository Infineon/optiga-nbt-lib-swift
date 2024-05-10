# APDU Channel Swift Library

> Basis for all synchronous data stream communication to a security device. 

This library implements the IChannel protocol for establishing the generic synchronous communication channel. An example for this type of channel is a NFC or a PCSC channel. IChannel class is extended to implement the communication channel as shown in the below example. 


## Example

ExampleChannel class extends the IChannel interface and implements the functionality to open, connect, transmit data(command), disconnect, and close the communication channel. 

``` swift
import Foundation
import InfineonChannel

public class ExampleChannel: IChannel {
    public func open(exclusive: Bool) throws {
        // TODO: Begin session to the secure element or smart card.
    }

    public func close() throws {
        // TODO: Closes the connection to the secure element or smart card.
    }

    public func connect(request: Data?) async throws -> Data {
        // TODO: Connects to the secure element or smart card for exchange of commands.
        return Data()
    }

    public func disconnect(request: Data?) throws {
        // TODO: Disconnects from the secure element or smart card.
    }

    public func reset(request: Data?) async throws {
        // TODO: Resets the state of the card.
    }

    public func transmit(stream: Data) async throws -> Data {
        // TODO: Transceive the data between the host and secure element or smart card.
        return Data()
    }

    public func isOpen() -> Bool {
        // TODO: Checks the session state.
        return true
    }

    public func isConnected() -> Bool {
        // TODO: Checks the connection state.
        return true
    }

    public func getName() -> String {
        // TODO: Gets the name of connected device.
        return ""
    }
}
```


