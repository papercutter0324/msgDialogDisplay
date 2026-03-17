import Foundation

enum DialogButtons {

    //--------------------------------------------------
    // Individual buttons (match VBA MsgBox values)
    //--------------------------------------------------

    enum Button: Int {

        case ok = 1
        case cancel = 2
        case abort = 3
        case retry = 4
        case ignore = 5
        case yes = 6
        case no = 7

        var title: String {
            switch self {
            case .ok: return "OK"
            case .cancel: return "Cancel"
            case .abort: return "Abort"
            case .retry: return "Retry"
            case .ignore: return "Ignore"
            case .yes: return "Yes"
            case .no: return "No"
            }
        }
    }

    //--------------------------------------------------
    // Standard button layouts (like VBA MsgBox)
    //--------------------------------------------------

    enum Set {

        case ok
        case okCancel
        case yesNo
        case yesNoCancel
        case retryCancel
        case abortRetryIgnore

        var buttonList: [Button] {
            switch self {
            case .ok:
                return [.ok]
            case .okCancel:
                return [.ok, .cancel]
            case .yesNo:
                return [.yes, .no]
            case .yesNoCancel:
                return [.yes, .no, .cancel]
            case .retryCancel:
                return [.retry, .cancel]
            case .abortRetryIgnore:
                return [.abort, .retry, .ignore]
            }
        }
    }
}
