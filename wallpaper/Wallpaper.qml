import Quickshell
import Quickshell.Wayland

import QtQuick

PanelWindow {
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    Item {

        anchors.fill: parent

        Image {
            id: currentWallpaper
            anchors.fill: parent
            opacity: 1
            layer.enabled: false
            asynchronous: true
            smooth: true
            cache: true
            visible: true
            fillMode: Image.PreserveAspectCrop
            source: Qt.resolvedUrl("../assets/wallpapers/asdafdya.jpg")
        }
    }
}
