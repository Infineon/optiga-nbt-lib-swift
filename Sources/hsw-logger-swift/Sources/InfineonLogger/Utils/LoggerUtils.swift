// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
/// This class provides utility logging functions using static methods.
public enum LoggerUtils {
    /// Returns the formatted string representation of data
    ///
    /// - Parameter data: Represents a sequence of
    /// bytes that can be interpreted as binary data.
    ///
    /// - Returns: A string representation of the input
    /// data in hexadecimal byte format.
    ///
    public static func getFormattedString(data: Data) -> String {
        return data.map { String(format: "0x%02x",
                                 $0) }.joined(separator: ", ")
    }

    /// Returns a formatted string representation of the list of strings.
    ///
    /// - Parameter stringArray: The array of strings to be formatted.
    ///
    /// - Returns: String representation of the input strings, with each string separated by a newline character.
    ///
    public static func getConsoleString(stringArray: [String]) -> String {
        return stringArray.joined(separator: "\n")
    }

    /// Returns a formatted console string representation of the string.
    ///
    /// - Parameter consoleString: The console string to be formatted.
    ///
    /// - Returns: A string representation of the input console string,
    /// with an arrow and newline added for formatting purposes.
    ///
    public static func getFormattedConsoleString(consoleString: String) -> String {
        return "\n-->\(consoleString)"
    }
}
