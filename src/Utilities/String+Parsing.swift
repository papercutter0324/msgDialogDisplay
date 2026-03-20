// String+Parsing.swift
// Common parsing helpers

import Foundation

extension String {
    /// Accepts common boolean spellings: true/false, yes/no, 1/0, on/off
    var asBool: Bool? {
        switch self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "true", "yes", "1", "on": return true
        case "false", "no", "0", "off": return false
        default: return nil
        }
    }
}
