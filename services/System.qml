pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: singleton

    property string osName
    property string osPrettyName
    property string osId
    property list<string> osIdLike
    property string osLogo: Qt.resolvedUrl(`${Quickshell.shellDir}/assets/images/archlinux.svg`)
    property bool isDefaultLogo: true

    property string uptime
    readonly property string user: Quickshell.env("USER")
    readonly property string wm: Quickshell.env("XDG_CURRENT_DESKTOP") || Quickshell.env("XDG_SESSION_DESKTOP")
    readonly property string shell: Quickshell.env("SHELL").split("/").pop()

    property int currentBrightness
    property int maxBrightness


    FileView {
        id: osRelease

        path: "/etc/os-release"
        onLoaded: {
            const lines = text().split("\n");

            const fd = key => lines.find(l => l.startsWith(`${key}=`))?.split("=")[1].replace(/"/g, "") ?? "";

            singleton.osName = fd("NAME");
            singleton.osPrettyName = fd("PRETTY_NAME");
            singleton.osId = fd("ID");
            singleton.osIdLike = fd("ID_LIKE").split(" ");

            const logo = Quickshell.iconPath(fd("LOGO"), true);
            if (logo) {
                singleton.osLogo = logo;
                singleton.isDefaultLogo = false;
            }
        }
    }



    FileView {
        id: fileUptime

        path: "/proc/uptime"
        onLoaded: {
            const up = parseInt(text().split(" ")[0] ?? 0);

            const days = Math.floor(up / 86400);
            const hours = Math.floor((up % 86400) / 3600);
            const minutes = Math.floor((up % 3600) / 60);

            let str = "";
            if (days > 0)
            str += `${days} day${days === 1 ? "" : "s"}`;
            if (hours > 0)
            str += `${str ? ", " : ""}${hours} hour${hours === 1 ? "" : "s"}`;
            if (minutes > 0 || !str)
            str += `${str ? ", " : ""}${minutes} minute${minutes === 1 ? "" : "s"}`;
            singleton.uptime = "up " + str;
        }

        
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: fileUptime.reload()
    }

    function setScreenBrightness(value: int) {
        var command = [ "brightnessctl", "set" ]
        command.push(String(value))
        brightnessSetProc.command = command
        brightnessSetProc.running = true
        singleton.currentBrightness = value
    }

    Process {
        command: [ "brightnessctl", "g" ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var value = `${this.text}`
                singleton.currentBrightness = Number(value)
            }
        }
    }

    Process {
        command: [ "brightnessctl", "m" ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var value = `${this.text}`
                singleton.maxBrightness = Number(value)
            }
        }
    }

    Process {
        id: brightnessSetProc
        running: false
    }



    function poweroff() {
        poweroff.running = true;
    }

    function suspend() {
        singleton.lock();
        suspend.running = true;
    }

    function reboot() {
        reboot.running = true;
    }

    function lock() {
        lock.running = true;
    }

    function logout() {
        logout.running = true;
    }

    Process {
        id: poweroff
        running: false
        command: ["poweroff"]
    }

    Process {
        id: suspend
        running: false
        command: ["systemctl", "suspend"]
    }

    Process {
        id: reboot
        running: false
        command: ["reboot"]
    }

    Process {
        id: lock
        running: false
        // command: ["hyprctl", "dispatch", "exec", "hyprlock"]
        command: ["qs", "ipc", "call", "lock", "lock"]
    }

    Process {
        id: logout
        running: false
        command: ["hyprctl", "dispatch", "exit"]
    }
}