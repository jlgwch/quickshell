import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../common"
import "../style"
import "../qscontrols"
import "../services"

FluPanelWindow {
    id: bar
    color: "#00000000"
    backgroundColor: FluTheme.draculaBackgroundColor
    border.width: 2
    border.color: FluTheme.draculaPrimaryColor
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    implicitHeight: 38

    readonly property int itemHeight: 28

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 4
        left: 4
        right: 4
    }

    Clock {
        anchors.centerIn: parent
        height: bar.itemHeight
    }

    RowLayout {
        anchors.fill: parent
        spacing: 5
        Row {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.leftMargin: 6
            spacing: 5
            Workspace {
                anchors.verticalCenter: parent.verticalCenter
                height: bar.itemHeight
                screen: bar.screen
            }

            FocusedApp {
                anchors.verticalCenter: parent.verticalCenter
                width: 400
            }
        }

        Row {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 6
            spacing: 5

            MprisIndictor {
                anchors.verticalCenter: parent.verticalCenter
                width: bar.itemHeight
                height: bar.itemHeight
                visible: MprisService.activePlayer !== null
            }

            Caffeine {
                anchors.verticalCenter: parent.verticalCenter
                width: bar.itemHeight
                height: bar.itemHeight
                iconSize: 18
            }

            SysTray {
                anchors.verticalCenter: parent.verticalCenter
                height: bar.itemHeight
            }

            PanelIndicator {
                anchors.verticalCenter: parent.verticalCenter
                height: bar.itemHeight
            }
        }
    }
}
