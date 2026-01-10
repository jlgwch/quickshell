// import Quickshell.Hyprland
// import Quickshell.Io

import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Controls.Basic

import "../services"
import "../style"
import "../flucontrols"
import "../utils"

Button {
    id: control
    property int iconSize: 20

    property bool caffeine: Hypridle.caffeine

    hoverEnabled: true

    onClicked: {
        if (caffeine)
            Hypridle.caffeine_off();
        else
            Hypridle.caffeine_on();
    }

    background: Item {
        anchors.fill: parent
        Rectangle {
            id: background
            anchors {
                fill: parent
                margins: 0
            }

            radius: 6
            color: control.pressed ? Qt.rgba(FluTheme.draculaPrimaryColor.r, FluTheme.draculaPrimaryColor.g, FluTheme.draculaPrimaryColor.b, 0.35) : control.hovered ? Qt.rgba(FluTheme.draculaPrimaryColor.r, FluTheme.draculaPrimaryColor.g, FluTheme.draculaPrimaryColor.b, 0.20) : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: 120
                    easing.type: Easing.OutCubic
                }
            }

            Image {
                anchors.centerIn: parent
                width: iconSize
                height: iconSize
                source: caffeine ? "../assets/images/caffeine_on.svg" : "../assets/images/caffeine_off.svg"
            }

            // FluIcon {
            //     anchors.centerIn: parent
            //     iconSource: FluentIcons.LEDLight
            //     iconSize: Math.min(parent.height, parent.width) * 0.8
            //     iconColor: caffeine ? FluTheme.draculaPrimaryColor : FluTheme.white

            //     Behavior on color {
            //         ColorAnimation {
            //             duration: 120
            //             easing.type: Easing.OutCubic
            //         }
            //     }
            // }
        }
    }
}
