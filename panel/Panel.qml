import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "../common"
import "../style"
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

    WlrLayershell.layer: WlrLayer.Overlay
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
                Layout.preferredHeight: gridLayout.height + 12
                Layout.leftMargin: 6
                Layout.rightMargin: 6
                color: FluTheme.draculaForegroundColor
                radius: 6

                GridLayout {
                    id: gridLayout
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