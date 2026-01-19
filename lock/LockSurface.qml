import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Wayland
import Quickshell.Widgets

import "../services"
import "../style"
import "../flucontrols"

Rectangle {
    id: root
    required property var screen
    required property LockContext context
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    function clear() {
        passwordBox.clear;
    }

    // color: colors.window
    color: FluTheme.draculaBackgroundColor

    Button {
        text: "Its not working, let me out"
        onClicked: context.unlocked()
        visible: false
    }

    ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.rightMargin: 10

        FluText {
            Layout.alignment: Qt.AlignRight
            text: SysClock.clock
            font.family: FluTheme.fontFamily
            font.pixelSize: 90
            font.bold: true
            renderType: Text.NativeRendering
            color: FluTheme.draculaPrimaryColor
        }

        FluText {
            Layout.alignment: Qt.AlignRight
            text: qsTr("%1 %2").arg(SysClock.weekday).arg(SysClock.date)
            font.family: FluTheme.fontFamily
            font.pixelSize: 25
            // font.bold: true
            renderType: Text.NativeRendering
            color: FluTheme.draculaPrimaryColor
        }
    }

    ColumnLayout {
        // Uncommenting this will make the password entry invisible except on the active monitor.
        // visible: Window.active

        // anchors {
        //     horizontalCenter: parent.horizontalCenter
        //     top: parent.verticalCenter
        // }

        anchors.centerIn: parent
        spacing: 10

        ClippingRectangle {

            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 60
            Layout.preferredHeight: 60
            radius: 30
            color: "#00000000"
            clip: true

            IconImage {
                anchors.fill: parent
                // source: Qt.resolvedUrl("../assets/avatar/avatar.jpg")
                source: Qt.resolvedUrl("/var/lib/AccountsService/icons/xuqiang")
                smooth: true
            }
            border.width: 2
            border.color: FluTheme.draculaPrimaryColor
        }

        TextField {
            id: passwordBox

            Layout.preferredWidth: 200
            padding: 10

            focus: true
            enabled: !root.context.unlockInProgress
            echoMode: TextInput.Password
            // cursorVisible: false
            // cursorDelegate: Item {}
            // inputMethodHints: Qt.ImhSensitiveData
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            color: "gray"

            // Try to unlock when enter is pressed.
            onAccepted: root.context.tryUnlock(text)

            placeholderText: qsTr("Locked by xuqiang")
            placeholderTextColor: "gray"

            background: Rectangle {
                radius: 100
                color: Qt.lighter(FluTheme.draculaBackgroundColor, 1.2)
                border.width: 2
                border.color: FluTheme.draculaPrimaryColor
            }
        }

        Label {
            visible: root.context.showFailure
            text: "Incorrect password"
        }
    }
}
