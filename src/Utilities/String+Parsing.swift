//
//  String+Parsing.swift
//    Common parsing helpers
//  msgDialogDisplay
//
//  Created by Warren Feltmate on 3/16/26.
//

import Foundation

extension String {
    var asBool: Bool? {
        switch self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "true", "yes", "1", "on": return true
        case "false", "no", "0", "off": return false
        default: return nil
        }
    }
}
