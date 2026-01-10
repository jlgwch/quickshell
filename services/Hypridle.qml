pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    property bool caffeine: !(detectCaffeine.pid > 0)

    function caffeine_on() {
        caffeineon.running = true;
        caffeine = true;
    }

    function caffeine_off() {
        caffeineoff.running = true;
        caffeine = false;
    }

    Process {
        id: detectCaffeine
        property int pid: 0
        running: true
        command: ["pgrep", "hypridle"]
        stdout: StdioCollector {
            onStreamFinished: {
                var text = `${this.text}`;
                detectCaffeine.pid = Number(text);
            }
        }
    }

    Process {
        id: caffeineon
        running: false
        command: ["killall", "hypridle"]
    }

    Process {
        id: caffeineoff
        running: false
        command: ["hyprctl", "dispatch", "exec", "hypridle"]
    }
}
