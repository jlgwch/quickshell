import Quickshell
import Quickshell.Hyprland

import QtQuick

import "../style"

PopupWindow {
    id: window

    required property int xPos
    required property int yPos

    property alias radius: region.radius
    property alias border: region.border
    property alias backgroundColor: region.color
    property bool enableFocusGrab: false

    signal focusLost

    anchor.rect.x: xPos
    anchor.rect.y: yPos
    implicitWidth: 600
    implicitHeight: 400
    visible: true

    mask: Region {
        item: region
    }

    Rectangle {
        id: region
        anchors.fill: parent
        radius: window.radius
    }

    HyprlandFocusGrab {
        windows: [window]
        active: window.enableFocusGrab
        onCleared: {
            window.focusLost();
        }
    }
}
