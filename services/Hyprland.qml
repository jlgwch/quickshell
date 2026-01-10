pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

Singleton {

    readonly property string focusedAppId: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.appId : ""
    readonly property var focusedEntry: focusedAppId ? DesktopEntries.applications.values.find(item => item.id === focusedAppId) : null
    readonly property string focusedAppName: focusedEntry ? focusedEntry.name : ""
    readonly property string focusedAppTitle: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : ""
    readonly property string focusedMonitorName: Hyprland.focusedMonitor ? Hyprland.focusedMonitor.name : ""

    function jump(id) {
        Hyprland.dispatch(`workspace ${id}`);
    }

    function workspaceModel(screen) {
        return Hyprland.workspaces.values.filter(ws => ws.id > 0).filter(ws => ws.monitor?.name == screen.name);
    }
}
