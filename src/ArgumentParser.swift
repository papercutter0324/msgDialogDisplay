import Foundation

class ArgumentParser {

    static func parse() -> DialogConfig {

        let args = CommandLine.arguments

        //--------------------------------------------------
        // Remove executable path
        //--------------------------------------------------

        let parameters = Array(args.dropFirst())

        //--------------------------------------------------
        // Extract parameters safely
        //--------------------------------------------------

        let message = parameters.count > 0 ? parameters[0] : ""
        let title = parameters.count > 1 ? parameters[1] : ""
        let width = parameters.count > 2 ? Int(parameters[2]) ?? 420 : 420
        let iconString = parameters.count > 3 ? parameters[3] : "info"
        let buttonSetString = parameters.count > 4 ? parameters[4] : "ok"
        let defaultButton = parameters.count > 5 ? Int(parameters[5]) ?? 1 : 1
        let useVibrancy = parameters.count > 6 ? Bool(parameters[6]) ?? true : true

        //--------------------------------------------------
        // Convert icon
        //--------------------------------------------------

        let icon: DialogIcon

        switch iconString.lowercased() {

        case "warning", "exclamation":
            icon = .warning

        case "error", "critical":
            icon = .error

        case "info", "information":
            icon = .info

        default:
            icon = .info
        }

        //--------------------------------------------------
        // Convert button set
        //--------------------------------------------------

        let buttonSet: DialogButtons.Set

        switch buttonSetString.lowercased() {

        case "ok":
            buttonSet = .ok

        case "okcancel":
            buttonSet = .okCancel

        case "yesno":
            buttonSet = .yesNo

        case "yesnocancel":
            buttonSet = .yesNoCancel

        case "retrycancel":
            buttonSet = .retryCancel

        case "abortretryignore":
            buttonSet = .abortRetryIgnore

        default:
            buttonSet = .ok
        }

        //--------------------------------------------------
        // Build configuration
        //--------------------------------------------------

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
}
