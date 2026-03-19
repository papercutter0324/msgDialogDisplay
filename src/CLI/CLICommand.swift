// CLICommand.swift
// Orchestrates parsing, validation, and building of DialogConfig

import Foundation
import Darwin

struct CLICommand {

    func run() -> DialogConfig {
        let args = CommandLine.arguments
        let program = URL(fileURLWithPath: args.first ?? "program").lastPathComponent
        let parameters = Array(args.dropFirst())

        if parameters.isEmpty {
            CLIOutput.printShortUsageAndExit(program: program, reason: "No arguments provided.")
        }

        do {
            let opts = try CLIParser.parse(parameters)

            if opts.help {
                CLIOutput.printHelpAndExit(program: program)
            }

            if opts.version {
                CLIOutput.printVersionAndExit(program: program)
            }

            let validated = try CLIValidators.validate(opts, program: program)

            // Compute final default button index based on set and optional override
            var defaultIndex: Int
            switch validated.buttons {
            case .ok: defaultIndex = 1
            case .okCancel: defaultIndex = 1
            case .yesNo: defaultIndex = 1
            case .yesNoCancel: defaultIndex = 1
            case .retryCancel: defaultIndex = 1
            case .abortRetryIgnore: defaultIndex = 2
            }

            if let override = validated.defaultButton, override.isEmpty == false {
                if let idx = Int(override) {
                    guard idx >= 1 && idx <= validated.buttons.buttonList.count else {
                        CLIOutput.printShortUsageAndExit(program: program, reason: "Invalid value for --defaultButton: \(override). Provide an index 1..\(validated.buttons.buttonList.count) or a button label: OK, Cancel, Yes, No, Retry, Ignore, Abort.")
                    }
                    defaultIndex = idx
                } else {
                    let normalized = override.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    func normalizeAlias(_ s: String) -> String {
                        switch s {
                        case "okay": return "ok"
                        case "esc", "escape": return "cancel"
                        default: return s
                        }
                    }
                    let target = normalizeAlias(normalized)
                    if let idx = validated.buttons.buttonList.firstIndex(where: { $0.title.lowercased() == target }) {
                        defaultIndex = idx + 1
                    } else if let idx = validated.buttons.buttonList.firstIndex(where: { button in
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
                        defaultIndex = idx + 1
                    } else {
                        CLIOutput.printShortUsageAndExit(program: program, reason: "Invalid value for --defaultButton: \(override). Provide an index 1..\(validated.buttons.buttonList.count) or a button label: OK, Cancel, Yes, No, Retry, Ignore, Abort.")
                    }
                }
            }

            return DialogConfig(
                title: validated.title,
                message: validated.message,
                width: validated.width,
                icon: validated.icon,
                buttons: validated.buttons,
                defaultButton: defaultIndex,
                useVibrancy: validated.useVibrancy
            )

        } catch let error as CLIError {
            CLIOutput.printShortUsageAndExit(program: program, reason: error.description)
        } catch {
            CLIOutput.printShortUsageAndExit(program: program, reason: "Unexpected error: \(error)")
        }
    }
}
