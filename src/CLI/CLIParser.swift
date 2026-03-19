// CLIParser.swift
// Tokenization and flag extraction only (no domain mapping)

import Foundation

struct CLIOptions {
    var help = false
    var version = false
    var message: String?
    var title: String?
    var width: String?
    var icon: String?
    var buttons: String?
    var defaultButton: String?
    var vibrancy: String?
}

struct CLIParser {

    private enum Key: String, CaseIterable {
        case message
        case title
        case width
        case icon
        case buttons
        case defaultButton
        case vibrancy
        case help
        case version
    }

    static func parse(_ parameters: [String]) throws -> CLIOptions {
        var opts = CLIOptions()
        var result: [Key: String] = [:]
        var index = 0

        func mapShort(_ s: String) -> Key? {
            switch s {
            case "h": return .help
            case "V": return .version
            case "m": return .message
            case "t": return .title
            case "w": return .width
            case "i": return .icon
            case "b": return .buttons
            case "d": return .defaultButton
            case "v": return .vibrancy
            default: return nil
            }
        }

        while index < parameters.count {
            let token = parameters[index]

            if token.hasPrefix("--") {
                let flagBody = String(token.dropFirst(2))
                guard flagBody.isEmpty == false else { throw CLIError.invalidFlag(token) }

                if let eqIndex = flagBody.firstIndex(of: "=") {
                    let keyPart = String(flagBody[..<eqIndex])
                    let valuePart = String(flagBody[flagBody.index(after: eqIndex)...])
                    guard let key = Key(rawValue: keyPart) else { throw CLIError.unknownOption("--\(keyPart)") }
                    result[key] = valuePart
                    index += 1
                } else {
                    guard let key = Key(rawValue: flagBody) else { throw CLIError.unknownOption("--\(flagBody)") }
                    if index + 1 < parameters.count, parameters[index + 1].hasPrefix("-") == false {
                        result[key] = parameters[index + 1]
                        index += 2
                    } else {
                        result[key] = "true"
                        index += 1
                    }
                }

            } else if token.hasPrefix("-") {
                let flagBody = String(token.dropFirst(1))
                guard flagBody.isEmpty == false else { throw CLIError.invalidFlag(token) }

                let keyChar: String
                let valueAfterEq: String?
                if let eqIndex = flagBody.firstIndex(of: "=") {
                    keyChar = String(flagBody[..<eqIndex])
                    valueAfterEq = String(flagBody[flagBody.index(after: eqIndex)...])
                } else {
                    keyChar = flagBody
                    valueAfterEq = nil
                }

                guard keyChar.count == 1 else { throw CLIError.invalidShortFlag(keyChar) }
                guard let key = mapShort(keyChar) else { throw CLIError.unknownOption("-\(keyChar)") }

                if let v = valueAfterEq {
                    result[key] = v
                    index += 1
                } else if index + 1 < parameters.count, parameters[index + 1].hasPrefix("-") == false {
                    result[key] = parameters[index + 1]
                    index += 2
                } else {
                    result[key] = "true"
                    index += 1
                }

            } else {
                throw CLIError.unexpectedArgument(token)
            }
        }

        // Map raw dictionary to options
        opts.help = result[.help] != nil
        opts.version = result[.version] != nil
        opts.message = result[.message]
        opts.title = result[.title]
        opts.width = result[.width]
        opts.icon = result[.icon]
        opts.buttons = result[.buttons]
        opts.defaultButton = result[.defaultButton]
        opts.vibrancy = result[.vibrancy]

        return opts
    }
}
