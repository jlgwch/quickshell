import QtQuick
import QtQuick.Controls

import "../flucontrols"
import "../services"
import "../style"

Button {
    id: control

    checkable: true
    horizontalPadding: 12
    verticalPadding: 0

    contentItem: Text {
        text: SysClock.time
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font: FluTheme.normalFont
        color: {
            if (control.checked) {
                return "#000000";
            } else {
                return "#cfcfcf";
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: FluTheme.animationDuration
            }
        }
    }

    background: Rectangle {
        radius: 100
        color: {
            if (control.checked) {
                return FluTheme.draculaPrimaryColor;
            } else {
                return FluTheme.draculaForegroundColor;
            }
        }

        border.width: 1.4
        border.color: {
            if (control.checked) {
                return FluTheme.draculaPrimaryColor;
            } else {
                return "#cfcfcf";
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: FluTheme.animationDuration
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: FluTheme.animationDuration
            }
        }
    }
}
