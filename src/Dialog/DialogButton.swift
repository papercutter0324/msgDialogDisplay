//
//  DialogButton.swift
//  msgDialogDisplay
//
//  Created by Warren Feltmate on 3/16/26.
//

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
                return [.cancel, .ok]
            case .yesNo:
                return [.no, .yes]
            case .yesNoCancel:
                return [.cancel, .no, .yes]
            case .retryCancel:
                return [.cancel, .retry]
            case .abortRetryIgnore:
                return [.ignore, .retry, .abort]
            }
        }
    }
}
