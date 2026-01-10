import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../common"
import "../flucontrols"
import "../style"
import "../utils"

FluPopupWindow {
    id: window
    required property QsMenuHandle menu
    signal triggered

    color: "#00000000"
    backgroundColor: color
    implicitWidth: content.implicitWidth + 8
    implicitHeight: content.implicitHeight + 8
    radius: 6

    FluShadow {
        anchors.margins: 4
        radius: window.radius
        elevation: 4
    }

    Rectangle {
        id: content
        anchors.fill: parent
        anchors.margins: 4
        radius: 6
        color: FluTheme.draculaBackgroundColor
        implicitWidth: stackView.implicitWidth
        implicitHeight: stackView.implicitHeight

        StackView {
            id: stackView

            implicitWidth: currentItem.implicitWidth
            implicitHeight: currentItem.implicitHeight

            pushEnter: Transition {
                OpacityAnimator {
                    from: 0
                    to: 1
                    duration: 83
                }
                ScaleAnimator {
                    from: 0.5
                    to: 1
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }
            pushExit: Transition {
                OpacityAnimator {
                    from: 1
                    to: 0
                    duration: 83
                }
                ScaleAnimator {
                    from: 1.0
                    to: 0.5
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }

            popEnter: Transition {
                OpacityAnimator {
                    from: 0
                    to: 1
                    duration: 83
                }
                ScaleAnimator {
                    from: 0.5
                    to: 1
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }
            popExit: Transition {
                OpacityAnimator {
                    from: 1
                    to: 0
                    duration: 83
                }
                ScaleAnimator {
                    from: 1.0
                    to: 0.5
                    duration: 167
                    easing.type: Easing.OutCubic
                }
            }

            initialItem: SubMenu {
                handle: window.menu
                isSubMenu: false
            }
        }
    }

    component SubMenu: ColumnLayout {
        id: subMenu
        required property QsMenuHandle handle
        required property bool isSubMenu

        QsMenuOpener {
            id: menuOpener
            menu: subMenu.handle
        }

        Item {
            Layout.preferredHeight: 1
        }

        Repeater {

            model: menuOpener.children

            delegate: MouseArea {
                required property QsMenuEntry modelData
                Layout.preferredWidth: 260
                Layout.preferredHeight: modelData ? modelData.isSeparator ? 1 : 30 : 30

                hoverEnabled: true

                FluToolTip {
                    text: modelData ? modelData.text : ""
                    visible: containsMouse && menuItemLabel.isElided
                    delay: 500
                    font: FluTheme.smallFont
                }

                visible: {
                    if (menuOpener.children.values.length - 1 === menuOpener.children.indexOf(modelData) && modelData.isSeparator)
                        return false;
                    return true;
                }

                onClicked: {
                    if (!modelData.hasChildren) {
                        modelData.triggered();
                        window.triggered();
                    } else {
                        stackView.push(subMenuComp.createObject(null, {
                            handle: modelData,
                            isSubMenu: true
                        }));
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: modelData ? modelData.isSeparator ? 12 : 4 : 4
                    anchors.rightMargin: modelData ? modelData.isSeparator ? 12 : 4 : 4
                    color: {
                        if (!modelData)
                            return "#00000000";

                        modelData.isSeparator ? "#ffffff" : parent.containsMouse ? FluTheme.draculaPrimaryColor : "#00000000";
                    }
                    radius: 6
                    Behavior on color {
                        PropertyAnimation {
                            duration: 167
                        }
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    Item {
                        Layout.leftMargin: 10
                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: parent.height

                        Loader {
                            anchors.verticalCenter: parent.verticalCenter
                            active: modelData ? modelData.buttonType === QsMenuButtonType.CheckBox : false
                            asynchronous: true
                            sourceComponent: FluCheckBox {
                                anchors.verticalCenter: parent.verticalCenter
                                checked: modelData.checkState
                                onClicked: {
                                    modelData.triggered();
                                    window.triggered();
                                }
                                // text: modelData.text
                                // textColor: "#ffffff"
                            }
                        }

                        Loader {
                            anchors.verticalCenter: parent.verticalCenter
                            active: modelData ? modelData.buttonType === QsMenuButtonType.RadioButton : false
                            asynchronous: true
                            sourceComponent: FluRadioButton {
                                checked: modelData.checkState
                                // text: modelData.text
                                textColor: "#ffffff"
                                onClicked: {
                                    modelData.triggered();
                                    window.triggered();
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Label {
                            id: menuItemLabel
                            property bool isElided: metrics.width > menuItemLabel.width
                            anchors.fill: parent
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            color: "#cfcfcf"
                            font: FluTheme.smallFont
                            text: modelData ? modelData.text : qsTr("")

                            TextMetrics {
                                id: metrics
                                text: menuItemLabel.text
                                font: menuItemLabel.font
                            }
                        }
                    }
                    Item {
                        Layout.rightMargin: 10
                        Layout.preferredHeight: parent.height
                        Layout.preferredWidth: parent.height

                        FluIcon {
                            anchors.centerIn: parent
                            iconSource: FluentIcons.ChevronRightMed
                            iconColor: "#cfcfcf"
                            visible: {
                                if (!modelData)
                                    return false;
                                modelData.isSeparator ? false : modelData.hasChildren ? true : false;
                            }
                        }
                    }
                }
            }
        }

        MouseArea {

            Layout.preferredWidth: 260
            Layout.preferredHeight: modelData.isSeparator ? 1 : 30
            visible: parent.isSubMenu
            hoverEnabled: true

            onClicked: {
                stackView.pop();
            }

            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                color: parent.containsMouse ? FluTheme.draculaPrimaryColor : "#00000000"
                radius: 6
                Behavior on color {
                    PropertyAnimation {
                        duration: 167
                    }
                }
            }

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.leftMargin: 10
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: parent.height

                    // FluIcon {
                    //     anchors.centerIn: parent
                    //     iconSource: FluentIcons.ChevronLeftMed
                    //     iconColor: "#cfcfcf"
                    // }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Label {
                        anchors.fill: parent
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        color: "#cfcfcf"
                        font: FluTheme.smallFont
                        text: qsTr("返回")
                    }
                }
            }
        }

        Item {
            Layout.preferredHeight: 1
        }
    }

    Component {
        id: subMenuComp

        SubMenu {}
    }
}
