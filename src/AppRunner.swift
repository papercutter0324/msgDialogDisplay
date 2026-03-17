//
//  AppRunner.swift
//  msgDialogDisplay
//
//  Created by Warren Feltmate on 3/16/26.
//


import AppKit

struct AppRunner {

    static func run(_ window: NSWindow) {

        let app = NSApplication.shared
        app.setActivationPolicy(.accessory)

        window.makeKeyAndOrderFront(nil)
        app.activate(ignoringOtherApps: true)

        app.run()
    }
}