import Quickshell

import "./bar"
import "./lock"
import "./wallpaper"

Scope {

    ReloadPopup {}
    Lock {}

    Variants {
        model: Quickshell.screens
        Wallpaper {
            required property var modelData
            screen: modelData
        }
    }
    Variants {
        // Create the panel once on each monitor.
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }
}
