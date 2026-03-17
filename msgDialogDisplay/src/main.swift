import AppKit

let config = ArgumentParser.parse()

let controller = DialogController()
let windowBuilder = DialogWindow(config: config, controller: controller)

let window = windowBuilder.build()

AppRunner.run(window)
