import QtQuick
import QtQuick.Controls
import "../style"

Item {
    id: control
    property int radius: 4
    anchors.fill: parent
    Rectangle {
        width: control.width
        height: control.height
        anchors.centerIn: parent
        color: "#00000000"
        border.width: 2
        radius: control.radius
        border.color: FluTheme.dark ? Qt.rgba(1, 1, 1, 1) : Qt.rgba(0, 0, 0, 1)
        z: 65535
    }
}
