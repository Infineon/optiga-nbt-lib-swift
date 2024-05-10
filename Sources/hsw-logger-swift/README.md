# Logger Swift Library

This library implements the ILogger protocol to log messages in a binary compressed format, deferring much of the work to turn them into human-readable text messages. Using a binary format allows the log system to store more messages and reduces the overhead of logging data.

## Example

ExampleLogger class extends the ILogger interface and implements the functionality to log different levels of messages like error, warning, info and debug. By default, the log level is set to `all`, so all log messages will be logged. To change the log level, set the loggerLevel property of the Logger instance (The logger levels, in order of increasing verbosity, are: `none`, `error`, `warning`, `info`, `debug`, and `all`).

``` swift
import Foundation
import InfineonLogger

public class ExampleLogger: ILogger {
    /// Current log level.
    private var loggerLevel: Int = LoggerLevel.all.rawValue

    public func error(header: String, message: String) {
        if loggerLevel >= LoggerLevel.error.rawValue {
            // TODO: Implement the logging functionality
        }
    }

    public func error(header: String, data: Data) {
        if loggerLevel >= LoggerLevel.error.rawValue {
            // TODO: Implement the logging functionality
        }
    }

    public func warning(header: String, message: String) {
        if loggerLevel >= LoggerLevel.warning.rawValue {
            // TODO: Implement the logging functionality
        }
    }

    public func warning(header: String, data: Data) {
        if loggerLevel >= LoggerLevel.warning.rawValue {
            // TODO: Implement the logging functionality
        }
    }

    public func info(header: String, message: String) {
        if loggerLevel >= LoggerLevel.info.rawValue {
            // TODO: Implement the logging functionality
        }
    }

    public func info(header: String, data: Data) {
        if loggerLevel >= LoggerLevel.info.rawValue {
            // TODO: Implement the logging functionality
        }
    }

    public func debug(header: String, message: String) {
        if loggerLevel >= LoggerLevel.debug.rawValue {
            // TODO: Implement the logging functionality
        }
    }

    public func debug(header: String, data: Data) {
        if loggerLevel >= LoggerLevel.debug.rawValue {
            // TODO: Implement the logging functionality
        }
    }

    public func setLogLevel(loggerLevel: LoggerLevel) {
        self.loggerLevel = loggerLevel.rawValue
    }

    public init() {}
}

```


