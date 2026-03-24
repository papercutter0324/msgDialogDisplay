//
//  DialogWindow.swift
//  msgDialogDisplay
//
//  Created by Warren Feltmate on 3/16/26.
//

import AppKit

class DialogWindow {
    
    let config: DialogConfig
    let controller: DialogController
    
    init(config: DialogConfig, controller: DialogController) {
        self.config = config
        self.controller = controller
    }
    
    func build() -> NSWindow {
        
        //--------------------------------------------------
        // Layout constants
        //--------------------------------------------------
        
        let marginLeft: CGFloat = 20
        let marginRight: CGFloat = 20
        let marginTop: CGFloat = 10
        let iconSize: CGFloat = 64
        let iconTextSpacing: CGFloat = 20
        let buttonSpacing: CGFloat = 12
        let buttonBottomMargin: CGFloat = 10
        let titleHeight: CGFloat = 20
        let messageSpacing: CGFloat = 6
        let textX = marginLeft + iconSize + iconTextSpacing
        
        //--------------------------------------------------
        // Determine optimal width (macOS-like behavior)
        //--------------------------------------------------

        let optimalTextWidth = optimalTextWidth(for: config.message)

        let calculatedWidth =
            marginLeft +
            iconSize +
            iconTextSpacing +
            optimalTextWidth +
            marginRight

        let width = max(CGFloat(config.width), calculatedWidth)
        
        //--------------------------------------------------
        // First, calculate message size
        //--------------------------------------------------
        let textWidth = width - textX - marginRight
        let messageLabel = NSTextField(wrappingLabelWithString: config.message)

        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.maximumNumberOfLines = 0

        messageLabel.frame = NSRect(
            x: textX,
            y: 0,
            width: textWidth,
            height: 0
        )

        let messageHeight = messageLabel.cell!.cellSize(forBounds: NSRect(
            x: 0,
            y: 0,
            width: textWidth,
            height: .greatestFiniteMagnitude
        )).height

        messageLabel.frame.size.height = messageHeight
        
        //--------------------------------------------------
        // Calculate button area
        //--------------------------------------------------
        var totalButtonWidth: CGFloat = 0
        var buttonWidths: [CGFloat] = []
        
        for buttonType in config.buttons.buttonList {
            let button = NSButton(title: buttonType.title, target: nil, action: nil)
            button.sizeToFit()
            buttonWidths.append(button.frame.width)
            totalButtonWidth += button.frame.width
        }
        totalButtonWidth += CGFloat(config.buttons.buttonList.count - 1) * buttonSpacing
        
        //--------------------------------------------------
        // Calculate total window height
        //--------------------------------------------------
        // Height = top margin + max(icon/title area) + message + spacing + buttons + bottom margin
        let contentHeight = max(iconSize, (config.showTitleInBar ? 0 : (titleHeight + messageSpacing)) + messageHeight) + marginTop + buttonBottomMargin + 30
        
        
        //--------------------------------------------------
        // Window
        //--------------------------------------------------
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: contentHeight),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        
        window.styleMask.remove(.resizable)
        window.title = config.showTitleInBar ? config.title : ""
        window.isReleasedWhenClosed = false
        
        //--------------------------------------------------
        // Create content view
        //--------------------------------------------------
        
        let contentFrame = window.contentRect(forFrameRect: window.frame)
        let content: NSView
        
        if config.useVibrancy {
            let visual = NSVisualEffectView(frame: contentFrame)
            visual.material = .hudWindow
            visual.blendingMode = .behindWindow
            visual.state = .active
            content = visual
        } else {
            content = NSView(frame: contentFrame)
        }
        
        window.contentView = content
        
        //--------------------------------------------------
        // Icon
        //--------------------------------------------------
        
        let iconView = NSImageView(frame: NSRect(
            x: marginLeft,
            y: 0,
            width: iconSize,
            height: iconSize))
        
        iconView.image = config.icon.image
        iconView.imageScaling = .scaleProportionallyUpOrDown
        iconView.imageAlignment = .alignCenter
        
        content.addSubview(iconView)
        
        //--------------------------------------------------
        // Title
        //--------------------------------------------------
        var titleLabel: NSTextField?
        if config.showTitleInBar == false {
            let label = NSTextField(labelWithString: config.title)
            label.font = NSFont.systemFont(ofSize: 13, weight: .semibold)
            label.frame = NSRect(x: marginLeft + iconSize + iconTextSpacing, y: 0, width: textWidth, height: titleHeight)
            content.addSubview(label)
            titleLabel = label
        }
        
        //--------------------------------------------------
        // Text area
        //--------------------------------------------------
        
        messageLabel.frame.origin = CGPoint(x: marginLeft + iconSize + iconTextSpacing, y: 0)
        content.addSubview(messageLabel)
        
        //--------------------------------------------------
        // Position elements from top
        //--------------------------------------------------
        
        let topY = contentHeight - marginTop
        if let titleLabel = titleLabel {
            titleLabel.frame.origin.y = topY - titleHeight
            messageLabel.frame.origin.y = titleLabel.frame.origin.y - messageSpacing - messageHeight
        } else {
            // No in-content title; place message directly under the top margin
            messageLabel.frame.origin.y = topY - messageHeight
        }
        iconView.frame.origin.y = topY - iconSize
        
        //--------------------------------------------------
        // Buttons
        //--------------------------------------------------
        var buttonX = width - marginRight
        let buttonY: CGFloat = buttonBottomMargin
        var cancelButton: NSButton?
        
        for (index, buttonType) in config.buttons.buttonList.enumerated().reversed() {
            let button = NSButton(
                title: buttonType.title,
                target: controller,
                action: #selector(DialogController.buttonPressed(_:))
            )
            button.tag = buttonType.rawValue
            button.bezelStyle = .rounded
            button.sizeToFit()
            
            buttonX -= button.frame.width
            button.frame.origin = CGPoint(x: buttonX, y: buttonY)
            content.addSubview(button)
            
            buttonX -= buttonSpacing
            
            // Default button
            if index + 1 == config.defaultButton {
                button.keyEquivalent = "\r"
                button.keyEquivalentModifierMask = []
                window.defaultButtonCell = button.cell as? NSButtonCell
            }
            
            // Cancel
            if buttonType == .cancel {
                cancelButton = button
            }
        }
        
        if let cancelButton = cancelButton {
            cancelButton.keyEquivalent = "\u{1b}"
        }
        
        //--------------------------------------------------
        // Show window
        //--------------------------------------------------
        window.center()
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
        window.level = .modalPanel
        
        return window
    }
    
    private func optimalTextWidth(for text: String) -> CGFloat {

        let minWidth: CGFloat = 260
        let maxWidth: CGFloat = 520
        let step: CGFloat = 20

        let label = NSTextField(wrappingLabelWithString: text)

        label.lineBreakMode = .byWordWrapping
        label.maximumNumberOfLines = 0
        
        var bestWidth = minWidth
        var previousHeight: CGFloat = .greatestFiniteMagnitude

        var width = minWidth

        while width <= maxWidth {

            label.frame.size.width = width

            let size = label.fittingSize
            
            if previousHeight - size.height < 10 {
                bestWidth = width
                break
            }

            previousHeight = size.height
            bestWidth = width

            width += step
        }

        return bestWidth
    }
}
