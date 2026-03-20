import AppKit

enum DialogIcon {

    case warning
    case error
    case info
    case question

    var image: NSImage? {

        switch self {

        case .warning:

            // FUTURE: Replace with embedded asset
            // return NSImage(named: "dialog_warning")

            return NSImage(named: NSImage.cautionName)

        case .error:

            // FUTURE: Replace with embedded asset
            // return NSImage(named: "dialog_error")

            return NSImage(named: NSImage.stopProgressTemplateName)

        case .info:

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
