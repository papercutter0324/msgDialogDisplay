//
//  DialogController.swift
//  msgDialogDisplay
//
//  Created by Warren Feltmate on 3/16/26.
//


import AppKit

class DialogController: NSObject {

    @objc func buttonPressed(_ sender: NSButton) {
        print(sender.tag)
        fflush(stdout)
        
        NSApplication.shared.terminate(nil)
    }

}
