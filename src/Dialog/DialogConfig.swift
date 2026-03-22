import Foundation

struct DialogConfig {

    let title: String
    let message: String
    let width: Int
    let icon: DialogIcon
    let buttons: DialogButtons.Set
    let defaultButton: Int
    let useVibrancy: Bool
    let showTitleInBar: Bool

    init(
        title: String,
        message: String,
        width: Int,
        icon: DialogIcon,
        buttons: DialogButtons.Set,
        defaultButton: Int,
        useVibrancy: Bool,
        showTitleInBar: Bool
    ) {
        self.title = title
        self.message = message
        self.width = width
        self.icon = icon
        self.buttons = buttons
        self.defaultButton = defaultButton
        self.useVibrancy = useVibrancy
        self.showTitleInBar = showTitleInBar
    }
}
