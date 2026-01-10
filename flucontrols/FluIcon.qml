import QtQuick
import QtQuick.Controls
import "../style"
import "../services"

Text {
    id: control
    property int iconSource
    property int iconSize: 20
    property color iconColor: {
        if (FluTheme.dark) {
            if (!enabled) {
                return Qt.rgba(130 / 255, 130 / 255, 130 / 255, 1);
            }
            return Qt.rgba(1, 1, 1, 1);
        } else {
            if (!enabled) {
                return Qt.rgba(161 / 255, 161 / 255, 161 / 255, 1);
            }
            return Qt.rgba(0, 0, 0, 1);
        }
    }
    font.family: FontProvider.segoeFamily
    font.pixelSize: iconSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: iconColor
    text: (String.fromCharCode(iconSource).toString(16))
    opacity: iconSource > 0
}
