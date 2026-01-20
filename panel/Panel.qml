import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

import "../common"
import "../style"
import "../utils"
import "../services"
import "../flucontrols"
import "../qscontrols"

FluPanelWindow {
    id: window

    anchors {
        top: true
        right: true
    }

    implicitWidth: 340
    implicitHeight: mainLayout.implicitHeight + 8

    WlrLayershell.layer: WlrLayer.Top
    exclusiveZone: 0

    color: "#00000000"
    backgroundColor: "#00000000"
    radius: 0

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: FluTheme.draculaBackgroundColor
        // color: "green"

        radius: 6

        FluShadow {
            elevation: 4
            radius: parent.radius
        }

        ColumnLayout {
            id: mainLayout
            width: parent.width

            Item {
                Layout.preferredHeight: 3
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: sysContent.implicitHeight + 12
                Layout.leftMargin: 6
                Layout.rightMargin: 6
                radius: 6
                color: FluTheme.draculaForegroundColor

                ColumnLayout {
                    id: sysContent
                    anchors.centerIn: parent
                    width: parent.width
                    spacing: 10

                    RowLayout {
                        Layout.leftMargin: 6
                        Layout.rightMargin: 6
                        ClippingRectangle {

                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 60
                            radius: 30
                            color: "#00000000"
                            clip: true

                            Image {
                                anchors.fill: parent
                                fillMode: Image.PreserveAspectCrop
                                source: Qt.resolvedUrl("../assets/avatar/avatar.jpg")
                                smooth: true
                            }
                        }

                        Column {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 6
                            spacing: 0
                            Text {
                                text: System.user
                                font: FluTheme.largeBoldFont
                                color: "#ffffff"
                            }

                            Text {
                                id: uptimeText
                                text: System.uptime
                                font: FluTheme.smallFont
                                color: "#ffffff"
                            }
                        }
                    }

                    RowLayout {
                        Layout.leftMargin: 6

                        readonly property int iconBtnSize: 26
                        readonly property int iconSize: 18

                        FluIconButton {
                            Layout.preferredWidth: parent.iconBtnSize
                            Layout.preferredHeight: parent.iconBtnSize
                            iconSize: parent.iconSize
                            iconSource: FluentIcons.PowerButton
                            iconColor: hovered ? "#000000" : "#ffffff"
                            normalColor: "#00000000"
                            hoverColor: Qt.lighter("#ff79c6", 1.1)
                            pressedColor: Qt.lighter("#ff79c6", 1.05)
                            text: qsTr("关机")

                            onClicked: System.poweroff()
                        }

                        FluIconButton {
                            Layout.preferredWidth: parent.iconBtnSize
                            Layout.preferredHeight: parent.iconBtnSize
                            iconSize: parent.iconSize
                            iconSource: FluentIcons.QuietHours
                            iconColor: hovered ? "#000000" : "#ffffff"
                            normalColor: "#00000000"
                            hoverColor: Qt.lighter("#ff79c6", 1.1)
                            pressedColor: Qt.lighter("#ff79c6", 1.05)
                            text: qsTr("挂起")

                            onClicked: System.suspend()
                        }

                        FluIconButton {
                            Layout.preferredWidth: parent.iconBtnSize
                            Layout.preferredHeight: parent.iconBtnSize
                            iconSize: parent.iconSize
                            iconSource: FluentIcons.UpdateRestore
                            iconColor: hovered ? "#000000" : "#ffffff"
                            normalColor: "#00000000"
                            hoverColor: Qt.lighter("#ff79c6", 1.1)
                            pressedColor: Qt.lighter("#ff79c6", 1.05)
                            text: qsTr("重启")

                            onClicked: System.reboot()
                        }

                        FluIconButton {
                            Layout.preferredWidth: parent.iconBtnSize
                            Layout.preferredHeight: parent.iconBtnSize
                            iconSize: parent.iconSize
                            iconSource: FluentIcons.Lock
                            iconColor: hovered ? "#000000" : "#ffffff"
                            normalColor: "#00000000"
                            hoverColor: Qt.lighter("#ff79c6", 1.1)
                            pressedColor: Qt.lighter("#ff79c6", 1.05)
                            text: qsTr("锁屏")

                            onClicked: System.lock()
                        }

                        FluIconButton {
                            Layout.preferredWidth: parent.iconBtnSize
                            Layout.preferredHeight: parent.iconBtnSize
                            iconSize: parent.iconSize
                            iconSource: FluentIcons.SwitchUser
                            iconColor: hovered ? "#000000" : "#ffffff"
                            normalColor: "#00000000"
                            hoverColor: Qt.lighter("#ff79c6", 1.1)
                            pressedColor: Qt.lighter("#ff79c6", 1.05)
                            text: qsTr("注销")

                            onClicked: System.logout()
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: gridLayout.height + 12
                Layout.leftMargin: 6
                Layout.rightMargin: 6
                color: FluTheme.draculaForegroundColor
                radius: 6

                GridLayout {
                    id: gridLayout
                    anchors.centerIn: parent
                    width: parent.width
                    columns: 2

                    Speaker {
                        Layout.alignment: Qt.AlignVCenter

                        onClicked: {
                            AudioDevice.setSinkMute()
                        }
                    }

                    FluSlider {
                        id: speakerValue
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        from: 0
                        to: 150
                        stepSize: 1
                        value: AudioDevice.sinkLevel * 100
                        tooltipEnabled: false
                        onMoved: {
                            AudioDevice.setSinkLevel(value / 100);
                        }
                    }

                    Microphone {
                        Layout.alignment: Qt.AlignVCenter
                        onClicked: {
                            AudioDevice.setSourceMute()
                        }
                    }

                    FluSlider {
                        id: microphoneValue
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        from: 0
                        to: 100
                        stepSize: 1
                        value: AudioDevice.sourceLevel * 100
                        tooltipEnabled: false
                        onMoved: {
                            AudioDevice.setSourceLevel(value / 100);
                        }
                    }

                    Brightness {
                        Layout.alignment: Qt.AlignVCenter
                        scale: 0.7 + 0.3 * (brightnessSlider.value / brightnessSlider.to)
                        onScaleChanged: {
                            rotation = rotation + 0.5;
                        }
                    }

                    FluSlider {
                        id: brightnessSlider
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                        from: 0
                        stepSize: 1
                        to: System.maxBrightness
                        value: System.currentBrightness
                        onMoved: {
                            System.setScreenBrightness(value);
                        }
                    }
                }
            }

            Item {
                Layout.preferredHeight: 3
            }
        }
    }


}