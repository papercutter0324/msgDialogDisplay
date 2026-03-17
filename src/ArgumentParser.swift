import Foundation
import Darwin

class ArgumentParser {

    /// Supported flag keys
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

    // Hardcoded version info for binary releases
    private static let hardcodedVersion = "1.0.0"
    private static let hardcodedBuild = "1"

    /// Parse command line arguments into a DialogConfig using flags only.
    /// Short aliases supported: -h, -V, -m, -t, -w, -i, -b, -d, -v
    /// Long flags supported: --help, --version, --message, --title, --width, --icon, --buttons, --defaultButton, --vibrancy
    static func parse() -> DialogConfig {
        let args = CommandLine.arguments
        let parameters = Array(args.dropFirst())

        // Build flags dictionary (no positional support)
        let flags = parseFlags(from: parameters)

        // No arguments: print a short hint and exit
        if parameters.isEmpty {
            printShortUsageAndExit("No arguments provided.")
        }

        // Help flag: print usage and exit early
        if flags[.help] != nil {
            printHelpAndExit()
        }

        // Version flag: print version and exit early
        if flags[.version] != nil {
            printVersionAndExit()
        }

        // Message is required
        guard let message = flags[.message], message.isEmpty == false else {
            printShortUsageAndExit("Missing required argument: --message")
        }

        // Optional fields with defaults
        let title = flags[.title] ?? "Important Information:"

        let widthString = flags[.width]
        let width = Int(widthString ?? "") ?? 420

        let iconString = (flags[.icon] ?? "info").lowercased()
        let buttonsString = (flags[.buttons] ?? "ok").lowercased()

        let defaultButtonString = flags[.defaultButton]

        let vibrancyString = flags[.vibrancy]
        let useVibrancy = (vibrancyString?.asBool) ?? true

        // Convert icon
        let icon: DialogIcon
        switch iconString {
        case "warning", "exclamation":
            icon = .warning
        case "error", "critical":
            icon = .error
        case "info", "information":
            icon = .info
        default:
            icon = .info
        }

        // Convert button set and resolve default button per set
        let buttonSet: DialogButtons.Set
        var defaultButton: Int
        switch buttonsString {
        case "ok":
            buttonSet = .ok
            defaultButton = 1
        case "okcancel":
            buttonSet = .okCancel
            defaultButton = 1
        case "yesno":
            buttonSet = .yesNo
            defaultButton = 1
        case "yesnocancel":
            buttonSet = .yesNoCancel
            defaultButton = 1
        case "retrycancel":
            buttonSet = .retryCancel
            defaultButton = 1
        case "abortretryignore":
            buttonSet = .abortRetryIgnore
            defaultButton = 2
        default:
            buttonSet = .ok
            defaultButton = 1
        }

        // If user provided an explicit default button value, accept either index or name; validate and give a concise hint on error
        if let value = defaultButtonString, value.isEmpty == false {
            if let idx = Int(value) {
                if idx < 1 || idx > buttonSet.buttonList.count {
                    printShortUsageAndExit("Invalid value for --defaultButton: \(value). Provide an index 1..\(buttonSet.buttonList.count) or a button label: OK, Cancel, Yes, No, Retry, Ignore, Abort.")
                } else {
                    defaultButton = idx
                }
            } else {
                // Try to map a name like "OK", "Cancel", "Retry" to its 1-based position in the current set
                let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

                // Allow a few common aliases
                func normalizeAlias(_ s: String) -> String {
                    switch s {
                    case "okay": return "ok"
                    case "esc", "escape": return "cancel"
                    default: return s
                    }
                }

                let target = normalizeAlias(normalized)

                if let idx = buttonSet.buttonList.firstIndex(where: { $0.title.lowercased() == target }) {
                    defaultButton = idx + 1 // convert to 1-based index
                } else if let idx = buttonSet.buttonList.firstIndex(where: { button in
                    switch button {
                    case .ok: return target == "ok"
                    case .cancel: return target == "cancel"
                    case .abort: return target == "abort"
                    case .retry: return target == "retry"
                    case .ignore: return target == "ignore"
                    case .yes: return target == "yes"
                    case .no: return target == "no"
                    }
                }) {
                    defaultButton = idx + 1
                } else {
                    printShortUsageAndExit("Invalid value for --defaultButton: \(value). Provide an index 1..\(buttonSet.buttonList.count) or a button label: OK, Cancel, Yes, No, Retry, Ignore, Abort.")
                }
            }
        }

        // Build configuration
        return DialogConfig(
            title: title,
            message: message,
            width: width,
            icon: icon,
            buttons: buttonSet,
            defaultButton: defaultButton,
            useVibrancy: useVibrancy
        )
    }

    /// Print usage information and exit the program.
    private static func printHelpAndExit() -> Never {
        let prog = URL(fileURLWithPath: CommandLine.arguments.first ?? "program").lastPathComponent
        let usage = """
        Usage:
          \(prog) -m <message> [options]

        Options:
          -h, --help                        Show this help and exit
          -V, --version                     Show version and exit
          -m, --message <text>              Required. Dialog message text.
          -t, --title <text>                Optional. (Default: \"Important Information:\")
          -w, --width <int>                 Optional. (Default: 420)
          -i, --icon <type>                 Optional. (Default: info)
          -b, --buttons <set>               Optional. (Default: ok)
          -d, --defaultButton <index|label> Optional. 1-based index or a button label (OK, Cancel, Yes, No, Retry, Ignore, Abort).
          -v, --vibrancy <bool>             Optional. true|false. (Default: true)

        Button sets:
          ok
          okcancel
          yesno
          yesnocancel
          retrycancel
          abortretryignore

        Icon types:
          info
          warning
          error

        Examples:
          \(prog) -m \"Hello\"
          \(prog) -m \"Proceed?\" -t \"Confirm\" -b okcancel -d cancel
          \(prog) -m \"Try again?\" -b retrycancel -d 1 -i warning
        
        """
        print(usage)
        fflush(stdout)
        exit(0)
    }

    /// Print version information and exit the program.
    private static func printVersionAndExit() -> Never {
        let prog = URL(fileURLWithPath: CommandLine.arguments.first ?? "program").lastPathComponent
        let versionLine: String
        if Self.hardcodedBuild.isEmpty {
            versionLine = "\(prog) \(Self.hardcodedVersion)"
        } else {
            versionLine = "\(prog) \(Self.hardcodedVersion) (\(Self.hardcodedBuild))"
        }
        print(versionLine)
        fflush(stdout)
        exit(0)
    }

    /// Print a short error and hint to use -h/--help, then exit with a non-zero status.
    private static func printShortUsageAndExit(_ reason: String) -> Never {
        let prog = URL(fileURLWithPath: CommandLine.arguments.first ?? "program").lastPathComponent
        let message = """
        Error: \(reason)
        Run \(prog) -h or --help for usage.
        """
        print(message)
        fflush(stdout)
        exit(64)
    }

    // MARK: - Helpers

    /// Parse flags from parameters supporting short (-k) and long (--) forms with `value` or `=value`.
    private static func parseFlags(from parameters: [String]) -> [Key: String] {
        var result: [Key: String] = [:]
        var index = 0
        while index < parameters.count {
            let token = parameters[index]

            if token.hasPrefix("--") {
                // Long flag
                let flagBody = String(token.drop(while: { $0 == "-" }))
                if let eqIndex = flagBody.firstIndex(of: "=") {
                    let keyPart = String(flagBody[..<eqIndex])
                    let valuePart = String(flagBody[flagBody.index(after: eqIndex)...])
                    if let key = Key(rawValue: keyPart) { result[key] = valuePart }
                    index += 1
                } else {
                    if let key = Key(rawValue: flagBody) {
                        if index + 1 < parameters.count, parameters[index + 1].hasPrefix("-") == false {
                            result[key] = parameters[index + 1]
                            index += 2
                        } else {
                            result[key] = "true"
                            index += 1
                        }
                    } else {
                        index += 1
                    }
                }
            } else if token.hasPrefix("-") {
                // Short flag(s). We only support single-letter flags, not bundles like -abc.
                let flagBody = String(token.drop(while: { $0 == "-" }))
                // Support -k=value as well
                let keyChar: String
                let valueAfterEq: String?
                if let eqIndex = flagBody.firstIndex(of: "=") {
                    keyChar = String(flagBody[..<eqIndex])
                    valueAfterEq = String(flagBody[flagBody.index(after: eqIndex)...])
                } else {
                    keyChar = flagBody
                    valueAfterEq = nil
                }

                func mapShort(_ s: String) -> Key? {
                    switch s {
                    case "h": return .help
                    case "m": return .message
                    case "t": return .title
                    case "w": return .width
                    case "i": return .icon
                    case "b": return .buttons
                    case "d": return .defaultButton
                    case "v": return .vibrancy
                    case "V": return .version
                    default: return nil
                    }
                }

                if let key = mapShort(keyChar) {
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
                    index += 1
                }
            } else {
                // Not a flag; ignore (no positional support)
                index += 1
            }
        }
        return result
    }
}
// MARK: - Small utilities

private extension Array where Element == String {
    subscript(safe index: Int) -> String? {
        return indices.contains(index) ? self[index] : nil
    }
}

private extension String {
    /// Accepts common boolean spellings: true/false, yes/no, 1/0, on/off
    var asBool: Bool? {
        switch self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "true", "yes", "1", "on": return true
        case "false", "no", "0", "off": return false
        default: return nil
        }
    }
}

