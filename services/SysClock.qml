pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property alias time: sysClock.time
    readonly property string date: Qt.formatDateTime(sysClock.date, "yyyy-MM-dd")
    readonly property string clock: Qt.formatDateTime(sysClock.date, "hh:mm")
    readonly property string weekday: sysClock.weekday
    SystemClock {
        id: sysClock
        precision: SystemClock.Minutes // SystemClock.Hours, SystemClock.Minutes.
        readonly property var weekdays: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        readonly property string weekday: weekdays[date.getDay()]
        property string time: qsTr("%1 %2").arg(Qt.formatDateTime(date, "yyyy-MM-dd hh:mm")).arg(weekday)
    }
}
