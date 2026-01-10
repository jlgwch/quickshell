pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: theme

    property bool dark: true
    property bool nativeText: true

    readonly property int animationDuration: 167

    readonly property color fontPrimaryColor: "#ffffff"
    readonly property color primaryColor: "#0066b4"
    readonly property color draculaPrimaryColor: "#ff79c6"
    readonly property color draculaBackgroundColor: "#282a36"
    readonly property color draculaForegroundColor: "#21222c"

    readonly property color itemNormalColor: Qt.rgba(0, 0, 0, 0)
    readonly property color itemHoverColor: Qt.rgba(0, 0, 0, 0.06)
    readonly property color itemPressColor: Qt.rgba(0, 0, 0, 0.06)
    readonly property color itemCheckColor: Qt.rgba(0, 0, 0, 0.06)

    readonly property color transparent: Qt.rgba(0, 0, 0, 0)
    readonly property color black: Qt.rgba(0, 0, 0)
    readonly property color white: Qt.rgba(255, 255, 255, 1)
    readonly property color grey10: Qt.rgba(250, 249, 248, 1)
    readonly property color grey20: Qt.rgba(243, 242, 241, 1)
    readonly property color grey30: Qt.rgba(237, 235, 233, 1)
    readonly property color grey40: Qt.rgba(225, 223, 221, 1)
    readonly property color grey50: Qt.rgba(210, 208, 206, 1)
    readonly property color grey60: Qt.rgba(200, 198, 196, 1)
    readonly property color grey70: Qt.rgba(190, 185, 184, 1)
    readonly property color grey80: Qt.rgba(179, 176, 173, 1)
    readonly property color grey90: Qt.rgba(161, 159, 157, 1)
    readonly property color grey100: Qt.rgba(151, 149, 146, 1)
    readonly property color grey110: Qt.rgba(138, 136, 134, 1)
    readonly property color grey120: Qt.rgba(121, 119, 117, 1)
    readonly property color grey130: Qt.rgba(96, 94, 92, 1)
    readonly property color grey140: Qt.rgba(72, 70, 68, 1)
    readonly property color grey150: Qt.rgba(59, 58, 57, 1)
    readonly property color grey160: Qt.rgba(50, 49, 48, 1)
    readonly property color grey170: Qt.rgba(41, 40, 39, 1)
    readonly property color grey180: Qt.rgba(37, 36, 35, 1)
    readonly property color grey190: Qt.rgba(32, 31, 30, 1)
    readonly property color grey200: Qt.rgba(27, 26, 25, 1)
    readonly property color grey210: Qt.rgba(22, 21, 20, 1)
    readonly property color grey220: Qt.rgba(17, 16, 15, 1)

    readonly property color appleBlue: "#4c82f7"

    readonly property string fontFamily: "Source Han Sans CN Medium"
    readonly property font titleFont: Qt.font({
        family: fontFamily,
        pixelSize: 18,
        bold: true
    })
    readonly property font largeFont: Qt.font({
        family: fontFamily,
        pixelSize: 16
    })
    readonly property font largeBoldFont: Qt.font({
        family: fontFamily,
        pixelSize: 16,
        bold: true
    })
    readonly property font normalFont: Qt.font({
        family: fontFamily,
        pixelSize: 14
    })
    readonly property font normalBoldFont: Qt.font({
        family: fontFamily,
        pixelSize: 14,
        bold: true
    })
    readonly property font smallFont: Qt.font({
        family: fontFamily,
        pixelSize: 12
    })
    readonly property font smallBoldFont: Qt.font({
        family: fontFamily,
        pixelSize: 12,
        bold: true
    })

    function randomColor() {
        return Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0);
    }

    function withOpacity(color, opacity) {
        // color: Qt.rgba 或 Qt.colorString
        // opacity: 0.0 ~ 1.0

        // 获取原来的 RGB
        var r = color.r;
        var g = color.g;
        var b = color.b;

        // 计算新的 alpha
        var a = Math.round(opacity * 255) / 255;

        // 返回新的颜色
        return Qt.rgba(r, g, b, a);
    }
}
