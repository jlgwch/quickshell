pragma ComponentBehavior: Bound

import QtQuick

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import "../style"
import "../utils"

MouseArea {
    id: mouseArea
    required property SystemTrayItem modelData
    // readonly property rect globalRect: QsWindow.window.contentItem.mapFromItem(mouseArea, 0, mouseArea.height, mouseArea.width, mouseArea.height)

    property rect globalRect

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    Rectangle {
        id: background
        anchors.fill: parent
        anchors.margins: 2
        radius: 100
        // color: "#00000000"
        color: mouseArea.pressed ? Qt.rgba(FluTheme.draculaPrimaryColor.r, FluTheme.draculaPrimaryColor.g, FluTheme.draculaPrimaryColor.b, 0.35) : mouseArea.containsMouse ? Qt.rgba(FluTheme.draculaPrimaryColor.r, FluTheme.draculaPrimaryColor.g, FluTheme.draculaPrimaryColor.b, 0.20) : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }

        IconImage {
            id: trayIcon
            visible: true

            // source: {
            //     if (modelData.icon.includes("?path=")) {
            //         const [name, path] = modelData.icon.split("?path=");
            //         modelData.icon = Qt.resolvedUrl(`${path}/${name.slice(name.lastIndexOf("/") + 1)}`);
            //     }
            //     return modelData.icon;
            // }

            // property string iconSource: 

            source: Utils.getTrayIcon(modelData)

            anchors.centerIn: parent
            width: parent.width * 0.6
            height: parent.height * 0.6
        }
    }

    QsMenuAnchor {
        id: menuAnchor
        menu: modelData.menu

        anchor.window: mouseArea.QsWindow.window
        anchor.adjustment: PopupAdjustment.Flip

        anchor.onAnchoring: {
            const window = mouseArea.QsWindow.window;
            const widgetRect = window.contentItem.mapFromItem(mouseArea, 0, mouseArea.height, mouseArea.width, mouseArea.height);

            anchor.rect = QsWindow.window.itemRect(mouseArea);
        }
    }

    LazyLoader {
        id: trayMenuLoader
        loading: false
        activeAsync: true

        SysTrayMenu {
            anchor.window: mouseArea.QsWindow.window

            xPos: mouseArea.globalRect.x
            yPos: mouseArea.QsWindow.window.height + 2
            menu: modelData.menu
            enableFocusGrab: true

            onFocusLost: {
                trayMenuLoader.active = false;
            }

            onTriggered: {
                trayMenuLoader.active = false;
            }
        }

        onActiveChanged: {
            if (active && item) {
                item.visible = true;
            }
        }
    }

    onClicked: event => {
        if (modelData.onlyMenu || event.button === Qt.RightButton) {
            // menuAnchor.open();
            globalRect = QsWindow.window.itemRect(mouseArea);
            trayMenuLoader.loading = true;
        } else if (event.button == Qt.LeftButton) {
            modelData.activate();
        } else if (event.button == Qt.MiddleButton) {
            modelData.secondaryActivate();
        }
    }
}
