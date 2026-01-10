pragma Singleton

import Quickshell
import QtQuick

Singleton {

    readonly property alias segoeFamily: segoe.name

    FontLoader {
        id: segoe
        source: "../assets/fonts/Segoe Fluent Icons.ttf"
    }
}
