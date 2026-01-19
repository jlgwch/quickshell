import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import "../flucontrols"
import "../utils"
import "../common"

Scope {
    id: root

    IpcHandler {
        id: ipcHandler
        target: "applauncher"

        function open(): void {
            lazyLoader.loading = true
        }

        function close(): void {
            lazyLoader.active = false;
        }

        function toggle(): void {
            if (lazyLoader.active)
                close();
            else
                open();
        }
    }

    LazyLoader {
        id: lazyLoader

        FluPanelWindow {
            id: popup
            color: "#00000000"
            backgroundColor: "#00000000"
            visible: true
            screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

            property var filterModel: DesktopEntries.applications.values.filter(item => item.name && item.name.toLowerCase().includes(input.text.toLowerCase()) || item.keywords.indexOf(input.text) !== -1)

            // implicitWidth: screen.width * 0.3
            // implicitHeight: screen.height * 0.66
            implicitWidth: 500
            implicitHeight: 800
            enableFocusGrab: true
            radius: 6

            onFocusLost: {
                ipcHandler.close();
            }
            
            Rectangle {
                // anchors.centerIn: parent
                // width: parent.width
                // height: parent.height
                anchors.fill: parent
                anchors.margins: 4

                color: "#282a36"
                radius: 8

                FluShadow {
                    radius: 8
                }

                Component {
                    id: highlight
                    Rectangle {
                        width: listView.width
                        height: 40
                        color: "#ff79c6"
                        radius: 8
                        y: listView.currentItem == null ? 0 : listView.currentItem.y
                        Behavior on y {
                            SpringAnimation {
                                spring: 3
                                damping: 0.2
                                duration: 183
                            }
                        }
                    }
                }

                Rectangle {
                    id: searchBox
                    y: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    height: 40
                    radius: 8
                    color: "gray"

                    FluIcon {
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        iconSource: FluentIcons.SearchAndApps
                        iconSize: 30
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#ffffff"
                    }
                    TextField {
                        id: input
                        width: parent.width
                        height: parent.height
                        leftPadding: 10
                        rightPadding: 50
                        color: "#ffffff"
                        font.pixelSize: 14

                        Component.onCompleted: forceActiveFocus()

                        Keys.onEscapePressed: {
                            ipcHandler.close();
                        }

                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Up) {
                                if (listView.currentIndex > 0)
                                listView.currentIndex--;
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Down) {
                                if (listView.currentIndex < listView.count - 1)
                                listView.currentIndex++;
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                listView.model[listView.currentIndex].execute();
                                ipcHandler.close();
                            }
                        }

                        background: Item {}

                        onTextChanged: {
                            if (text === "")
                                listView.model = DesktopEntries.applications;
                            else
                                listView.model = popup.filterModel;
                        }
                    }
                }

                ListView {
                    id: listView
                    model: DesktopEntries.applications.values
                    anchors {
                        top: searchBox.bottom
                        topMargin: 10
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                    anchors.margins: 10
                    clip: true
                    spacing: 5

                    highlight: highlight
                    highlightFollowsCurrentItem: false

                    delegate: MouseArea {
                        required property DesktopEntry modelData
                        implicitWidth: ListView.view.width
                        implicitHeight: 40
                        hoverEnabled: true

                        // 背景矩形
                        Rectangle {
                            id: bg
                            anchors.fill: parent
                            color: "gray"
                            visible: false
                            radius: 8
                        }

                        onEntered: {
                            bg.visible = true;
                        }
                        onExited: bg.visible = false

                        onClicked: {
                            modelData.execute();
                            ipcHandler.toggle();
                        }

                        RowLayout {
                            spacing: 10
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 5
                            }

                            IconImage {
                                id: icon
                                Layout.alignment: Qt.AlignVCenter
                                implicitSize: 26
                                source: modelData.icon ? Quickshell.iconPath(modelData.icon, true) : ""
                                smooth: true
                                asynchronous: true
                                visible: status === Image.Ready
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignVCenter
                                width: 26
                                height: 26
                                radius: 8
                                visible: !icon.visible
                                Text {
                                    anchors.centerIn: parent
                                    text: name.text.charAt(0).toUpperCase()
                                    font.pixelSize: 14
                                    font.bold: true
                                    Layout.alignment: Qt.AlignVCenter
                                }
                            }

                            Text {
                                id: name
                                text: modelData.name
                                color: "#f0f0f0"
                                Layout.alignment: Qt.AlignVCenter
                                font.pixelSize: 14
                            }
                        }
                    }

                    // 滚动到选中项
                    onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Center)

                    move: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            duration: 1000
                        }
                    }

                    ScrollBar.vertical: ScrollBar {}
                }
            }

            // implicitWidth: rect.width
            // implicitHeight: rect.height

        }
    }
}
