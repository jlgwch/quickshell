import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../flucontrols"
import "../utils"
import "../style"
import "../services"
import "../utils/markdown2html.js" as Markdown2Html

Item {
    id: control

    signal close(var id)

    implicitWidth: parent.width
    implicitHeight: preferredHeight

    required property var notify

    readonly property int preferredHeight: mainLayout.height + 8

    function formatNotifyBody(body) {
        return body.replace(/：\s*\n\s*/g, "：").replace(/\r?\n/g, "<br>");
    }

    Component {
        id: appName
        Rectangle {
            radius: 8
            color: "#21222c"
            Text {
                anchors.centerIn: parent
                text: notify.appName.charAt(0).toUpperCase()
                font.pixelSize: 30
                font.bold: true
                color: "#ffffff"
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    Component {
        id: appIcon
        ClippingRectangle {
            radius: 8
            color: "#00000000"
            clip: true

            Image {
                anchors.centerIn: parent
                anchors.fill: parent
                source: notify.image
                smooth: true
                asynchronous: true
                visible: status === Image.Ready
            }
        }
    }


    Rectangle {
        id: content
        anchors.fill: parent
        anchors.margins: 4
        radius: 6
        color: FluTheme.draculaBackgroundColor

        FluShadow {
            elevation: 4
            radius: parent.radius
        }

        ColumnLayout {
            id: mainLayout
            width: parent.width

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 6
                Layout.rightMargin: 6
                Layout.topMargin: 10
                Layout.bottomMargin: 10
                Loader {
                    Layout.leftMargin: 10
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 60
                    Layout.alignment: Qt.AlignTop

                    sourceComponent: notify.image === "" ? appName : appIcon
                }

                ColumnLayout {
                    id: columnLayout
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop

                        Text {
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            text: notify.appName.toUpperCase()
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 18
                            font.bold: true
                            color: "#ffffff"
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        FluIconButton {
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            iconSource: FluentIcons.Cancel
                            iconColor: hovered ? "#000000" : "#ffffff"
                            normalColor: "#00000000"
                            hoverColor: Qt.lighter("#ff79c6", 1.1)
                            pressedColor: Qt.lighter("#ff79c6", 1.05)
                            // visible: !root.autoDestroy

                            onClicked: {
                                NotificationService.dismiss(notify.id)
                            }
                        }
                    }

                    Text {
                        text: notify.summary
                        font.pixelSize: 14
                        font.bold: true
                        color: "#ffffff"
                    }

                    Text {
                        Layout.fillWidth: true
                        textFormat: Text.RichText
                        // text: {
                        //     if (notify.body && (notify.body.includes('<') && notify.body.includes('>'))) {
                        //         return notify.body;
                        //     }
                        //     return Markdown2Html.markdownToHtml(notify.body);
                        // }
                        text: formatNotifyBody(notify.body)
                        font.pixelSize: 12
                        color: "#ffffff"
                        wrapMode: Text.WrapAnywhere
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 16
                Layout.bottomMargin: 10
                // visible: notify.actions.length > 0
                visible: true
                Repeater {
                    model: notify.actions
                    FluFilledButton {
                        required property var modelData
                        text: modelData.text
                        textColor: FluTheme.white
                        onClicked: {
                            NotificationService.triggerNotificationAction(notify.id, modelData.identifier, modelData.text)
                        }
                    }
                }
            }
        }
    }

}