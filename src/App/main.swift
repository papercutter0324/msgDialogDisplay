import AppKit

let config = CLICommand().run()

let controller = DialogController()
let windowBuilder = DialogWindow(config: config, controller: controller)

let window = windowBuilder.build()

AppRunner.run(window)
