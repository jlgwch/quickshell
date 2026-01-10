pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Services.Mpris

import "../flucontrols"
import "../qscontrols"
import "../utils"
import "../services"
import "../style"
import "../common"

Button {
    id: control
    property int size: 20
    property int iconSize: 18
    property string contentDescription: ""
    readonly property MprisPlayer player: MprisService.activePlayer

    width: size
    height: size
    hoverEnabled: true

    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()

    property var clickListener: function () {
        checked = !checked;
    }
    onClicked: clickListener()

    background: Rectangle {
        id: background
        anchors {
            fill: parent
            margins: 0
        }
        // color: {
        //     if (!enabled)
        //         return "#646464";
        //     if (checked)
        //         return "#ff79c6";
        //     else
        //         // return "#0066b4";
        //         return "#00000000";
        // }

        color: {
            if (!enabled)
                return "#646464"; // 禁用颜色
            if (pressed)
                return Qt.rgba(FluTheme.draculaPrimaryColor.r, FluTheme.draculaPrimaryColor.g, FluTheme.draculaPrimaryColor.b, 0.35);
            if (hovered)
                return Qt.rgba(FluTheme.draculaPrimaryColor.r, FluTheme.draculaPrimaryColor.g, FluTheme.draculaPrimaryColor.b, 0.20);
            if (checked)
                return FluTheme.draculaPrimaryColor;
            return FluTheme.draculaForegroundColor;
        }
        border.width: 0
        border.color: "#ffffff"
        radius: 6

        FluIcon {
            anchors.centerIn: parent
            iconSource: FluentIcons.CircleRing
            color: {
                if (!enabled)
                    return "#646464";
                if (checked)
                    return "#000000";
                else
                    return "#ffffff";
            }
            iconSize: control.iconSize

            Behavior on color {
                ColorAnimation {
                    duration: FluTheme.animationDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        FluIcon {
            anchors.centerIn: parent
            iconSource: FluentIcons.PlaySolid
            color: {
                if (!enabled)
                    return "#646464";
                if (checked)
                    return "#000000";
                else
                    return "#ffffff";
            }
            iconSize: control.iconSize * 0.5

            Behavior on color {
                ColorAnimation {
                    duration: FluTheme.animationDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: FluTheme.animationDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    LazyLoader {
        id: loader
        loading: false
        activeAsync: true
        property rect globalRect

        FluPopupWindow {

            implicitWidth: content.implicitWidth + 8
            implicitHeight: content.implicitHeight + 8
            anchor.window: control.QsWindow.window
            xPos: loader.globalRect.x
            yPos: control.QsWindow.window.implicitHeight + 2
            enableFocusGrab: true
            visible: control.checked
            color: "#00000000"
            // backgroundColor: "red"
            backgroundColor: color
            radius: 6

            FluShadow {
                id: shadow
                anchors.margins: 4
                radius: 6
                elevation: 4
            }

            Rectangle {
                id: content

                anchors.fill: parent
                anchors.margins: 4
                radius: 6
                color: FluTheme.draculaBackgroundColor

                NumberAnimation {
                    id: fadeIn
                    target: content
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: FluTheme.animationDuration
                    easing.type: Easing.OutCubic
                }

                ParallelAnimation {
                    id: fadeOut
                    NumberAnimation {
                        target: content
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: FluTheme.animationDuration
                        easing.type: Easing.OutCubic
                    }

                    NumberAnimation {
                        target: shadow
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: FluTheme.animationDuration
                        easing.type: Easing.OutCubic
                    }

                    onFinished: {
                        loader.active = false;
                    }
                }

                Component.onCompleted: {
                    fadeIn.start();
                }

                implicitWidth: 300
                implicitHeight: mpris.height
                Mpris {
                    id: mpris
                    width: parent.width
                }
            }

            onFocusLost: {
                control.checked = false;
                fadeOut.start();
            }
        }
    }

    onCheckedChanged: {
        if (checked) {
            loader.globalRect = QsWindow.window.itemRect(control);
            loader.loading = checked;
        }
    }
}
