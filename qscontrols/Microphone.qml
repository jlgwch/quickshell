import QtQuick
import "../flucontrols"
import "../services"
import "../utils"
import "../style"

FluIconButton {
    id: control
    iconSize: 20
    iconSource: AudioDevice.sourceIcon
    iconColor: "#ffffff"
    horizontalPadding: 0
    verticalPadding: 0
    width: 20
    height: 20

    Loader {
        anchors.centerIn: parent
        active: AudioDevice.sourceMute
        asynchronous: true
        sourceComponent: Rectangle {
            width: 1.5
            height: control.height * 0.6
            rotation: -45
            color: FluTheme.white
        }
    }
}
