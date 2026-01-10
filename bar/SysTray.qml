pragma ComponentBehavior: Bound

import Quickshell.Services.SystemTray

import QtQuick

import "../style"

Rectangle {
    id: control
    width: mainLayout.width + 10
    color: FluTheme.draculaForegroundColor
    border.width: 1
    border.color: FluTheme.draculaPrimaryColor
    radius: 100
    visible: SystemTray.items.values.length > 0
    Row {
        id: mainLayout
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height
        spacing: 0
        Repeater {
            model: SystemTray.items
            delegate: SysTrayItem {
                width: control.height
                height: control.height
            }
        }
    }
}
