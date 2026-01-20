import QtQuick
import QtQuick.Controls

import "../style"
import "../services"

Label {
    text: Hyprland.focusedAppId === "" ? "" : qsTr("%1 · %2").arg(Hyprland.focusedAppName).arg(Hyprland.focusedAppTitle)
    color: FluTheme.draculaPrimaryColor
    font: FluTheme.normalBoldFont
    visible: Hyprland.focusedMonitorName == bar.screen.name
    opacity: visible ? 1 : 0
    elide: Text.ElideRight

    scale: visible ? 1 : 0.85

    Behavior on opacity {
        NumberAnimation {
            duration: FluTheme.animationDuration
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: FluTheme.animationDuration
        }
    }

    Behavior on visible {
        PropertyAnimation {
            duration: FluTheme.animationDuration
        }
    }

    Behavior on text {
        PropertyAnimation {
            duration: FluTheme.animationDuration
        }
    }
}
