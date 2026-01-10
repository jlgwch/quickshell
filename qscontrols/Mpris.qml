import Quickshell.Services.Mpris
import Quickshell.Widgets

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../flucontrols"
import "../utils"
import "../services"

Item {
    id: control
    height: content.height
    property MprisPlayer player: MprisService.activePlayer

    FrameAnimation {
        // only emit the signal when the position is actually changing.
        running: player.playbackState == MprisPlaybackState.Playing && !slider.pressed
        // emit the positionChanged signal every frame.
        onTriggered: player.positionChanged()
    }

    Item {
        id: content
        anchors.margins: 2
        width: parent.width
        height: contentLayout.height

        ColumnLayout {
            id: contentLayout
            width: parent.width
            RowLayout {
                Layout.topMargin: 10
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.fillWidth: true

                ClippingRectangle {
                    width: 60
                    height: 60
                    radius: 6
                    color: "#000000"
                    Image {
                        id: image
                        anchors.fill: parent
                        asynchronous: true
                        fillMode: Image.PreserveAspectCrop
                        source: player?.trackArtUrl
                    }

                    FluIcon {
                        id: baseIcon
                        anchors.centerIn: parent
                        visible: !(image.status === Image.Ready)
                        iconSource: FluentIcons.MusicNote
                        color: "#ffffff"
                        iconSize: Math.min(parent.width, parent.height) * 0.8
                    }
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 5
                    Layout.fillWidth: true

                    FluMarqueeText {
                        Layout.fillWidth: true
                        text: player?.trackTitle
                        font.pixelSize: 16
                        font.bold: true
                        scrollSpeed: 20
                        backgroundColor: "#00000000"
                        textColor: "#ff79c6"
                    }

                    FluMarqueeText {
                        Layout.fillWidth: true
                        text: player?.trackArtist + " - " + player?.trackTitle
                        font.pixelSize: 14
                        font.bold: false
                        scrollSpeed: 20
                        backgroundColor: "#00000000"
                        textColor: "#ff79c6"
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 10
                Layout.leftMargin: 10
                Layout.rightMargin: 10

                FluSlider {
                    id: slider
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    tooltipEnabled: false
                    from: 0
                    to: player?.length
                    value: player?.position
                    enabled: player.canSeek && player.positionSupported

                    onPressedChanged: {
                        if (!pressed) {
                            player.position = slider.value;
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10

                Item {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    Label {
                        anchors.left: parent.left
                        text: {
                            if (!player)
                                return "0:00";
                            const rawPos = Math.max(0, player.position || 0);
                            const pos = player.length ? rawPos % Math.max(1, player.length) : rawPos;
                            const minutes = Math.floor(pos / 60);
                            const seconds = Math.floor(pos % 60);
                            const timeStr = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                            return timeStr;
                        }
                        color: "#ffffff"
                    }

                    Label {
                        anchors.right: parent.right
                        text: {
                            if (!player || !player.length)
                                return "0:00";
                            const dur = Math.max(0, player.length || 0); // Length is already in seconds
                            const minutes = Math.floor(dur / 60);
                            const seconds = Math.floor(dur % 60);
                            return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
                        }
                        color: "#ffffff"
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                FluIconButton {
                    implicitWidth: 30
                    implicitHeight: 30
                    iconSource: FluentIcons.Previous
                    iconColor: hovered ? "#000000" : "#ffffff"
                    iconSize: 20
                    normalColor: "#00000000"
                    hoverColor: Qt.lighter("#ff79c6", 1.1)
                    pressedColor: Qt.lighter("#ff79c6", 1.05)
                    display: Button.IconOnly
                    visible: player?.canGoPrevious
                    onClicked: player.previous()
                }

                FluIconButton {
                    implicitWidth: 30
                    implicitHeight: 30
                    display: Button.IconOnly
                    iconSource: player?.isPlaying ? FluentIcons.Pause : FluentIcons.Play
                    iconColor: hovered ? "#000000" : "#ffffff"
                    normalColor: "#00000000"
                    hoverColor: Qt.lighter("#ff79c6", 1.1)
                    pressedColor: Qt.lighter("#ff79c6", 1.05)
                    iconSize: 20
                    onClicked: {
                        if (player?.isPlaying) {
                            player.pause();
                        } else {
                            player.play();
                        }
                    }
                }

                FluIconButton {
                    implicitWidth: 30
                    implicitHeight: 30
                    display: Button.IconOnly
                    iconSource: FluentIcons.Next
                    iconColor: hovered ? "#000000" : "#ffffff"
                    iconSize: 20
                    normalColor: "#00000000"
                    hoverColor: Qt.lighter("#ff79c6", 1.1)
                    pressedColor: Qt.lighter("#ff79c6", 1.05)
                    visible: player?.canGoNext
                    onClicked: player.next()
                }
            }
        }
    }
}
