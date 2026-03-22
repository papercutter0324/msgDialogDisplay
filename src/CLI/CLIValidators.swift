// CLIValidators.swift
// Convert CLIOptions into validated DialogOptions and then DialogConfig

import Foundation

struct DialogOptions {
    let message: String
    let title: String
    let width: Int
    let icon: DialogIcon
    let buttons: DialogButtons.Set
    let defaultButton: String? // either index (as string) or label; resolved later
    let useVibrancy: Bool
}

struct CLIValidators {

    static func validate(_ opts: CLIOptions, program: String) throws -> DialogOptions {
        guard let message = opts.message, message.isEmpty == false else {
            throw CLIError.missingRequired("--message")
        }

        let title = opts.title ?? "Important Information:"

        let width: Int
        if let w = opts.width {
            guard let intVal = Int(w) else {
                throw CLIError.invalidValue(flag: "--width", value: w, expected: "an integer")
            }
            width = intVal
        } else {
            width = 400
        }

        let iconString = (opts.icon ?? "info").lowercased()
        let icon: DialogIcon
        switch iconString {
        case "warning", "exclamation": icon = .warning
        case "error", "critical": icon = .error
        case "info", "information": icon = .info
        default: icon = .info
        }

        let buttonsString = (opts.buttons ?? "ok").lowercased()
        let buttons: DialogButtons.Set
        switch buttonsString {
        case "ok": buttons = .ok
        case "okcancel": buttons = .okCancel
        case "yesno": buttons = .yesNo
        case "yesnocancel": buttons = .yesNoCancel
        case "retrycancel": buttons = .retryCancel
        case "abortretryignore": buttons = .abortRetryIgnore
        default: buttons = .ok
        }

        let useVibrancy: Bool
        if let vStr = opts.vibrancy {
            guard let v = vStr.asBool else {
                throw CLIError.invalidValue(flag: "--vibrancy", value: vStr, expected: "true|false")
            }
            useVibrancy = v
        } else {
            useVibrancy = true
        }

        return DialogOptions(
            message: message,
            title: title,
            width: width,
            icon: icon,
            buttons: buttons,
            defaultButton: opts.defaultButton,
            useVibrancy: useVibrancy
        )
    }
}

