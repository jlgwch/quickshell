pragma Singleton

import QtQuick
import Quickshell

import "../services"

Singleton {

    function getTrayIcon(modelData): string {

        // console.log("--------------", modelData.id)

        if(modelData.id === "Fcitx" && System.inputMethod === "keyboard") {
            return Qt.resolvedUrl("../assets/images/keyboard.svg")
        }

        let icon = modelData && modelData.icon;
        if (typeof icon === 'string' || icon instanceof String) {
            if (icon === "") {
                return "";
            }
            if (icon.includes("?path=")) {
                const split = icon.split("?path=");
                if (split.length !== 2) {
                    return icon;
                }

                const name = split[0];
                const path = split[1];
                let fileName = name.substring(name.lastIndexOf("/") + 1);
                if (fileName.startsWith("dropboxstatus")) {
                    fileName = `hicolor/16x16/status/${fileName}`;
                }
                return `file://${path}/${fileName}`;
            }
            if (icon.startsWith("/") && !icon.startsWith("file://")) {
                return `file://${icon}`;
            }
            return icon;
        }
        return "";
    }
}
