// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// This enum class represents the different levels of logging that can
/// be used in a logging framework.
///
/// **Note:** The logger levels, in order of increasing verbosity,
/// are: "none", "error", "warning", "info", "debug", and "all".
///
public enum LoggerLevel: Int {
    /// Indicates that no messages will be logged. It is the most
    /// restrictive logging level.
    ///
    /// **Note:** This level is used when you do not want to
    /// log any messages.
    ///
    case none = 0
    /// Indicates that only messages with an "error" level or
    /// higher will be logged. It is used to log messages that
    /// indicate an error in the application.
    ///
    /// **Note:** This level is used to log messages that indicate an
    /// error in the application that requires attention.
    ///
    case error = 1
    /// Indicates that messages with a "warning" level or higher will be logged.
    /// It is used to log messages that are not necessarily errors, but may
    /// indicate potential issues.
    ///
    /// **Note:** This level is used to log messages that may indicate
    /// potential issues that should be addressed.
    ///
    case warning = 2
    /// Indicates that messages with an "info" level or higher will be logged.
    /// It is used to log general information about the application, such as
    /// startup messages or configuration details.
    ///
    /// **Note:** This level is used to log general information about the
    /// application that may be useful for troubleshooting or monitoring
    /// purposes.
    ///
    case info = 3
    /// Indicates that messages with a "debug" level or higher will be logged.
    /// It is used to log messages that are helpful for debugging the application,
    /// such as variable values or function calls.
    ///
    /// **Note:** This level is used to log messages that are helpful for
    /// debugging the application during development or testing.
    ///
    case debug = 4
    /// Indicates that all messages will be logged. It is the least restrictive
    /// logging level.
    ///
    /// **Note:** This level is used when you want to log all messages,
    /// regardless of their severity or importance.
    ///
    case all = 5
}
