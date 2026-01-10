import QtQuick
import "../flucontrols"
import "../services"
import "../utils"
import "../style"

FluIconButton {
    id: control
    iconSize: 20
    iconSource: AudioDevice.sinkIcon
    iconColor: "#ffffff"
    horizontalPadding: 0
    verticalPadding: 0
    width: 20
    height: 20

    Loader {
        anchors.centerIn: parent
        active: AudioDevice.sinkMute
        asynchronous: true
        sourceComponent: FluIcon {
            opacity: 0.4
            iconSource: FluentIcons.VolumeBars
            color: FluTheme.grey120
            iconSize: control.iconSize
        }
    }

    onClicked: sink.audio.muted = !sink.audio.muted
}
