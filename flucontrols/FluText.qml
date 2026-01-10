import QtQuick
import QtQuick.Controls
import "../style"

Text {
    id: text
    property color textColor: FluTheme.fontPrimaryColor
    color: enabled ? textColor : (FluTheme.dark ? Qt.rgba(131 / 255, 131 / 255, 131 / 255, 1) : Qt.rgba(160 / 255, 160 / 255, 160 / 255, 1))
    renderType: FluTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    font: FluTheme.normalFont
}
