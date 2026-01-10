pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {

    readonly property var laptopBattery: UPower.devices.values.find(dev => dev.isLaptopBattery)
    readonly property var laptopBatteryState: laptopBattery ? laptopBattery.state : UPowerDeviceState.Unknown
    readonly property real laptopBatteryPercentage: laptopBattery ? laptopBattery.percentage : 0

    readonly property real laptopTimeToFull: laptopBattery ? laptopBattery.timeToFull : 0
    readonly property real laptopTimeToEmpty: laptopBattery ? laptopBattery.timeToEmpty : 0

    readonly property bool isLowLaptopBattery: laptopBattery ? laptopBattery.percentage <= 0.2 : false

    function info() {
        var devices = UPower.devices.values;
        for (var i = 0; i < devices.length; i++) {
            var dev = devices[i];
            console.log(dev.model);
            console.log("    type:        " + UPowerDeviceType.toString(dev.type));
            console.log("    state:       " + UPowerDeviceState.toString(dev.state));
            console.log("    percentage:  " + dev.percentage);
            console.log("    timeToFull:  " + dev.timeToFull);
            console.log("    timeToEmpty: " + dev.timeToEmpty);
        }
    }

    function batteryInfo() {
    }
}
