import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes

import Quickshell

import "../services"
import "../style"

Item {
    id: control

    required property ShellScreen screen

    width: content.implicitWidth
    RowLayout {
        id: content
        height: control.height
        Repeater {
            model: Hyprland.workspaceModel(screen)

            Button {
                Layout.preferredWidth: control.height * 0.8
                Layout.preferredHeight: control.height * 0.8
                Layout.alignment: Qt.AlignVCenter

                onClicked: {
                    Hyprland.jump(modelData.id);
                }

                text: modelData.id
                font.pixelSize: 14

                palette.buttonText: modelData.focused ? "#ff79c6" : "#ffffff"
                background: Rectangle {
                    id: bg
                    radius: height / 2
                    color: "#00000000"
                    border.width: modelData.focused ? 2.5 : 1.5
                    border.color: modelData.focused ? "#ff79c6" : "#ffffff"

                    // 添加动画
                    Behavior on border.color {
                        ColorAnimation {
                            duration: FluTheme.animationDuration // 动画时长，单位毫秒
                        }
                    }

                    // border.width 动画
                    Behavior on border.width {
                        NumberAnimation {
                            duration: FluTheme.animationDuration
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }
}
