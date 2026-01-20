import QtQuick
import QtQuick.Controls
import Quickshell

import "../style"
import "../panel"

Button {
    id: control
    readonly property real preferredWidth: content.width
    property string contentDescription: qsTr("")

    verticalPadding: 0
    horizontalPadding: 6
    font.pixelSize: 16
    palette.buttonText: "#ffffff"

    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()

    property var clickListener: function () {
        checked = !checked;

    // panelWindow.visible = !panelWindow.visible
    }

    onClicked: clickListener()

    contentItem: Row {
        id: content
        anchors.centerIn: parent
        spacing: 4
        leftPadding: 0
        rightPadding: 0

        Speaker {
            anchors.verticalCenter: parent.verticalCenter
            enabled: false
            iconColor: control.checked ? "#000000" : "#ffffff"
            iconSize: 16
        }

        Battery {
            anchors.verticalCenter: parent.verticalCenter
            iconColor: control.checked ? "#000000" : "#ffffff"
            iconSize: 16
            height: 20
        }
    }

    background: Rectangle {
        anchors {
            fill: parent
            margins: 0
        }
        color: {
            if (!enabled)
                return "#646464";
            if (control.checked)
                return FluTheme.draculaPrimaryColor;
            else
                return "#00000000";
        }
        border.width: 1
        border.color: control.checked ? FluTheme.draculaPrimaryColor : "#ffffff"
        radius: height / 2

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

    LazyLoader {
        id: loader
        loading: false
        activeAsync: true

        Panel {
            enableFocusGrab: true
            onFocusLost: {
                control.checked = false
            }
        }
    }

    onCheckedChanged: {
        if (checked) {
            loader.loading = checked;
        } else {
            loader.active = false
        }
    }

}
