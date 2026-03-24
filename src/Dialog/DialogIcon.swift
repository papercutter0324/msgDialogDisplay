import AppKit

enum DialogIcon {

    case warning
    case exclamation
    case error
    case critical
    case info
    case information
    case question

    var image: NSImage? {

        switch self {

        case .warning, .exclamation:

            // FUTURE: Replace with embedded asset
            // return NSImage(named: "dialog_warning")

            return NSImage(named: NSImage.cautionName)

        case .error, .critical:

            // FUTURE: Replace with embedded asset
            // return NSImage(named: "dialog_error")

            return NSImage(named: NSImage.stopProgressTemplateName)

        case .info, .information:

            // FUTURE: Replace with embedded asset
            // return NSImage(named: "dialog_info")

            return NSImage(named: NSImage.infoName)

        case .question:

            // FUTURE: Replace with embedded asset
            // return NSImage(named: "dialog_question")

            // macOS convention: questions use the info icon
            return NSImage(named: NSImage.infoName)
        }
    }
}
