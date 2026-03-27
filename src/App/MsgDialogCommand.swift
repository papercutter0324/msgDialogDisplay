//
//  MsgDialogCommand.swift
//  msgDialogDisplay
//
//  Created by Warren Feltmate on 3/16/26.
//

import ArgumentParser
import AppKit

// MARK: - Argument types

enum IconArg: String, ExpressibleByArgument {
    case info, information, question, warning, exclamation, error, critical

    init?(argument: String) {
        self.init(rawValue: argument.lowercased())
    }
    
    func toDialogIcon() -> DialogIcon {
        switch self {
        case .info, .information, .question: return .info
        case .warning, .exclamation: return .warning
        case .error, .critical: return .error
        }
    }
}

enum ButtonsArg: String, ExpressibleByArgument {
    case ok
    case okcancel
    case yesno
    case yesnocancel
    case retrycancel
    case abortretryignore

    init?(argument: String) {
        self.init(rawValue: argument.lowercased())
    }
    
    func toDialogButtonsSet() -> DialogButtons.Set {
        switch self {
        case .ok: return .ok
        case .okcancel: return .okCancel
        case .yesno: return .yesNo
        case .yesnocancel: return .yesNoCancel
        case .retrycancel: return .retryCancel
        case .abortretryignore: return .abortRetryIgnore
        }
    }
}

struct DefaultButtonArg: ExpressibleByArgument {
    enum Storage { case index(Int), label(String) }
    let storage: Storage

    init?(argument: String) {
        if let n = Int(argument) {
            storage = .index(n)
        } else {
            storage = .label(argument)
        }
    }
}

// MARK: - Command

struct MsgDialogCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "msgDialogDisplay",
        abstract: "A lightweight custom message dialog for macOS.",
        discussion: """
            Examples:
                msgDialogDisplay -m "Hello"
                msgDialogDisplay -m "Proceed?" -t "Confirm" -b okcancel -d cancel
                msgDialogDisplay -m "Try again?" -b retrycancel -d 1 -i warning -T true
            """,
        version: "2.1.0 (Build: 21)"
    )

    // Required
    @Option(name: [.customShort("m"), .long], help: "Message to display.")
    var message: String

    // Optionals with defaults
    @Option(name: [.customShort("t"), .long], help: "Message Title")
    var title: String = "Important Information:"

    @Option(name: [.customShort("w"), .long], help: "Custom dialog width.")
    var width: Int = 400

    @Option(name: [.customShort("s"), .customLong("buttonSpacing")], help: "Custom spacing between buttons (min 10).")
    var buttonSpacing: Int? = nil

    @Option(name: [.customShort("i"), .long], help: "Message icon: info|warning|error")
    var icon: IconArg = .info

    @Option(name: [.customShort("b"), .long], help: "Button combination: ok|okcancel|yesno|yesnocancel|retrycancel|abortretryignore")
    var buttons: ButtonsArg = .ok

    @Option(name: [.customShort("d"), .customLong("default")], help: "Set default button using either its index or label.")
    var defaultButton: DefaultButtonArg?

    // Booleans
    @Option(name: [.customShort("v"), .customLong("vibrant")], help: "Use new vibrancy-style dialogs.")
    var vibrancy: Bool = false

    @Option(name: [.customShort("T"), .customLong("inTitleBar")], help: "Show title in title bar instead of inside the content window.")
    var titleInBar: Bool = false

    func run() throws {
        let set = buttons.toDialogButtonsSet()
        var defaultIndex = defaultIndex(for: set)

        if let override = defaultButton {
            defaultIndex = try resolveDefault(override, for: set)
        }

        let config = DialogConfig(
            title: title,
            message: message,
            width: width,
            buttonSpacing: max(10, buttonSpacing ?? 15),
            icon: icon.toDialogIcon(),
            buttons: set,
            defaultButton: defaultIndex,
            useVibrancy: vibrancy,
            showTitleInBar: titleInBar
        )

        let controller = DialogController()
        let windowBuilder = DialogWindow(config: config, controller: controller)
        let window = windowBuilder.build()
        AppRunner.run(window)
    }

    // MARK: - Helpers

    private func defaultIndex(for set: DialogButtons.Set) -> Int {
        switch set {
        case .ok: return 1
        case .okCancel: return 1
        case .yesNo: return 1
        case .yesNoCancel: return 1
        case .retryCancel: return 1
        case .abortRetryIgnore: return 2
        }
    }

    private func resolveDefault(_ arg: DefaultButtonArg, for set: DialogButtons.Set) throws -> Int {
        switch arg.storage {
        case .index(let i):
            guard (1...set.buttonList.count).contains(i) else {
                throw ValidationError("Invalid value for --default: \(i). Provide an index 1..\(set.buttonList.count) or a button label: OK, Cancel, Yes, No, Retry, Ignore, Abort.")
            }
            return i

        case .label(let raw):
            let normalized = normalizeAlias(raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
            if let idx = set.buttonList.firstIndex(where: { $0.title.lowercased() == normalized }) {
                return idx + 1
            }
            if let idx = set.buttonList.firstIndex(where: { button in
                switch button {
                case .ok: return normalized == "ok"
                case .cancel: return normalized == "cancel"
                case .abort: return normalized == "abort"
                case .retry: return normalized == "retry"
                case .ignore: return normalized == "ignore"
                case .yes: return normalized == "yes"
                case .no: return normalized == "no"
                }
            }) {
                return idx + 1
            }
            throw ValidationError("Invalid value for --default: \(raw). Provide an index 1..\(set.buttonList.count) or a button label: OK, Cancel, Yes, No, Retry, Ignore, Abort.")
        }
    }

    private func normalizeAlias(_ s: String) -> String {
        switch s {
        case "okay": return "ok"
        case "esc", "escape": return "cancel"
        default: return s
        }
    }
}
