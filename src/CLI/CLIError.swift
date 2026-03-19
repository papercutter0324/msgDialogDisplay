// CLIError.swift
// Errors used by the CLI parsing/validation layer

import Foundation

enum CLIError: Error, CustomStringConvertible {
    case missingRequired(String)                 // e.g., --message
    case invalidValue(flag: String, value: String, expected: String)
    case unknownOption(String)                  // e.g., -z or --zebra
    case unexpectedArgument(String)             // non-flag token
    case invalidFlag(String)                    // malformed flag like "--"
    case invalidShortFlag(String)               // e.g., "-ab" bundles not supported

    var description: String {
        switch self {
        case .missingRequired(let flag):
            return "Missing required argument: \(flag)"
        case .invalidValue(let flag, let value, let expected):
            return "Invalid value for \(flag): \(value). Expected: \(expected)"
        case .unknownOption(let opt):
            return "Unknown option: \(opt)"
        case .unexpectedArgument(let arg):
            return "Unexpected argument: \(arg)"
        case .invalidFlag(let flag):
            return "Invalid flag: \(flag)"
        case .invalidShortFlag(let flag):
            return "Invalid short flag: -\(flag). Use single-letter flags like -m, -t, -w."
        }
    }
}
