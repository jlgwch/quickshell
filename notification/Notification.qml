import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "../common"
import "../style"
import "../services"


FluPanelWindow {
    id: window

    anchors {
        top: true
        right: true
        bottom: true
    }

    implicitWidth: 380
    // implicitHeight: mainLayout.height

    // screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitorName)

    WlrLayershell.layer: WlrLayer.Overlay
    exclusiveZone: 0

    color: "#00000000"
    backgroundColor: "#00000000"
    radius: 0
    visible: notifyModel.count > 0

    property Component notifyDelegate: NotificationDelegate {}
    property list<NotificationDelegate> notifyDelegateList

    function onNotifyDelegateClose(id) {
        for (var i = 0; i < notifyModel.count; i++) {
            var item = notifyModel.get(i)

            if(item.id === id) {
                notifyModel.remove(i, 1)
                break
            }
        }
    }

    function createNotification(notify) {
        for(var i = 0; i < notifyDelegateList.length; i++) {
            const temp = notifyDelegateList[i].notify

            if(temp.appName === notify.appName && temp.summary === notify.summary) {
                notifyDelegateList[i].notify = notify
                break
            }
        }

        for (var i = 0; i < notifyModel.count; i++) {
            var item = notifyModel.get(i)
            if(item.appName === notify.appName && item.summary === notify.summary) {
                notifyModel.set(i, notify)
                break
            }
        }

        notifyModel.append(notify)
        const delegate = notifyDelegate.createObject(mainLayout, {
            notify: notify
        });
        delegate.close.connect(onNotifyDelegateClose)
        notifyDelegateList.push(delegate)
    }

    Connections {
        target: NotificationService
        function onNotify(notify) {
            for (var i = 0; i < notifyModel.count; i++) {
                var item = notifyModel.get(i)
                if(item.appName === notify.appName && item.summary === notify.summary) {
                    notifyModel.set(i, notify)
                    return
                }
            }
            notifyModel.append(notify)
        }

        function onClosed(id, reason) {
            onNotifyDelegateClose(id)
        }
    }

    ListModel {
        id: notifyModel
    }

    Column {
        id: mainLayout
        width: parent.width

        Repeater {
            model: notifyModel
            delegate: NotificationDelegate {
                required property var modelData
                notify: modelData

                Component.onCompleted: {
                    close.connect(onNotifyDelegateClose)
                }
            }
        }
    }
}