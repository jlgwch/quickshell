import Quickshell
import QtQuick
import Quickshell.Hyprland

PanelWindow {
    id: window
    property alias radius: region.radius
    property alias border: region.border
    property alias backgroundColor: region.color
    property bool enableFocusGrab: false

    signal focusLost

    mask: Region {
        item: region
    }

    Rectangle {
        id: region
        anchors.fill: parent
        radius: 100
    }

    HyprlandFocusGrab {
        windows: [window]
        active: window.enableFocusGrab
        onCleared: {
            window.focusLost();
        }
    }
}
