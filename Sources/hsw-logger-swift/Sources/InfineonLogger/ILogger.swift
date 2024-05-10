// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// This protocol defines the methods for logging different levels of messages.
public protocol ILogger {
    /// Logs an error message along with a header to categorize the error.
    /// The header parameter is a string that represents the category or
    /// the source of the error, while the message parameter is a string
    /// that contains the error message.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the error.
    ///   - message: A string that contains the error message.
    ///
    func error(header: String, message: String)

    /// Logs an error message along with a header to categorize the error.
    /// The header parameter is a string that represents the category or
    /// the source of the error, while the data parameter is a binary data
    /// that contains additional information about the error.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the error.
    ///   - data: A binary data that contains additional information about the error.
    ///
    func error(header: String, data: Data)

    /// Logs a warning message along with a header to categorize the warning.
    /// The header parameter is a string that represents the category or
    /// the source of the warning, while the message parameter is a string
    /// that contains the warning message.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the warning.
    ///   - message: A string that contains the warning message.
    ///
    func warning(header: String, message: String)

    /// Logs a warning message along with a header to categorize the warning.
    /// The header parameter is a string that represents the category or
    /// the source of the warning, while the data parameter is a binary
    /// data that contains additional information about the warning.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the warning.
    ///   - data: A binary data that contains additional information about the warning.
    ///
    func warning(header: String, data: Data)

    /// Logs an informational message along with a header to categorize the message.
    /// The header parameter is a string that represents the category or
    /// the source of the message, while the message parameter is a
    /// string that contains the informational message.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the message.
    ///   - message: A string that contains the informational message.
    ///
    func info(header: String, message: String)

    /// Logs an informational message along with a header to categorize the message.
    /// The header parameter is a string that represents the category or
    /// the source of the message, while the data parameter is a binary
    /// data that contains additional information about the message.
    ///
    /// - Parameters:
    ///   - header:  A string that represents the category or the source of the message.
    ///   - data: A binary data that contains additional information about the message.
    ///
    func info(header: String, data: Data)

    /// Logs a debug message along with a header to categorize the message.
    /// The header parameter is a string that represents the category or
    /// the source of the message, while the message parameter is a
    /// string that contains the debug message.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the message.
    ///   - message: A string that contains the debug message.
    ///
    func debug(header: String, message: String)

    /// Logs a debug message along with a header to categorize the message.
    /// The header parameter is a string that represents the category or
    /// the source of the message, while the data parameter is a binary
    /// data that contains additional information about the message.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the message.
    ///   - data: A binary data that contains additional information about the message.
    ///
    func debug(header: String, data: Data)

    /// Sets the logger level. The logger level determines which messages are
    /// logged and which ones are not. By setting the logger level, it controls the
    /// granularity of the log messages.
    ///
    /// - Parameter loggerLevel: A value that represents the logger level.
    ///
    func setLogLevel(loggerLevel: LoggerLevel)
}
