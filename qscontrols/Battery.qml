import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import "../flucontrols"
import "../utils"
import "../services"

Item {
    id: control
    property bool showPercentage: true
    property color iconColor: "#ffffff"
    property int iconSize: 20

    property var unChargingBatteryIcon: [FluentIcons.VerticalBattery0, FluentIcons.VerticalBattery1, FluentIcons.VerticalBattery2, FluentIcons.VerticalBattery3, FluentIcons.VerticalBattery4, FluentIcons.VerticalBattery5, FluentIcons.VerticalBattery6, FluentIcons.VerticalBattery7, FluentIcons.VerticalBattery8, FluentIcons.VerticalBattery9, FluentIcons.VerticalBattery10]

    property var chargingBatteryIcon: [FluentIcons.VerticalBatteryCharging0, FluentIcons.VerticalBatteryCharging1, FluentIcons.VerticalBatteryCharging2, FluentIcons.VerticalBatteryCharging3, FluentIcons.VerticalBatteryCharging4, FluentIcons.VerticalBatteryCharging5, FluentIcons.VerticalBatteryCharging6, FluentIcons.VerticalBatteryCharging7, FluentIcons.VerticalBatteryCharging8, FluentIcons.VerticalBatteryCharging9, FluentIcons.VerticalBatteryCharging10]

    function batteryIcon(percentage, charging) {
        // 限制百分比在 0~1 之间
        var pct = Math.max(0, Math.min(1, percentage));
        var index = Math.floor(pct * 10); // 0~10
        return charging ? chargingBatteryIcon[index] : unChargingBatteryIcon[index];
    }

    width: mainLayout.width
    RowLayout {
        id: mainLayout
        height: parent.height
        FluIcon {
            Layout.alignment: Qt.AlignVCenter
            iconSource: {
                switch (BatteryInfo.laptopBatteryState) {
                case UPowerDeviceState.Unknown:
                    return FluentIcons.BatteryUnknown;
                case UPowerDeviceState.Charging:
                case UPowerDeviceState.FullyCharged:
                case UPowerDeviceState.PendingCharge:
                    return batteryIcon(BatteryInfo.laptopBatteryPercentage, true);
                default:
                    return batteryIcon(BatteryInfo.laptopBatteryPercentage, false);
                }
            }
            iconSize: control.iconSize
            iconColor: control.iconColor
        }

        FluText {
            Layout.alignment: Qt.AlignVCenter
            text: qsTr("%1%").arg(BatteryInfo.laptopBatteryPercentage * 100)
            color: control.iconColor
            visible: control.showPercentage
        }
    }

    Component.onCompleted: {
        BatteryInfo.info();
    }
}
