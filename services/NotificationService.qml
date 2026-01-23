pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: singleton
    signal closed(var id, var reason)
    signal notify(var notify)

    property list<Notification> notifyList

    function dismiss(id) {
        const notification = removeNotify(id)
        if(notification) {
            notification.dismiss()
        }
    }

    function triggerNotificationAction(id, identifier, text) {
        const notification = removeNotify(id)
        if(notification) {
            var actions = notification.actions

            for(var i = 0; i < actions.length; i++) {
                if(actions[i].identifier === identifier && actions[i].text === text) {
                    actions[i].invoke()
                    break
                }
            }

        }
    }

    function removeNotify(id) {
        for(var i = 0; i < notifyList.length; i++) {
            if(notifyList[i].id === id) {
                var removed = notifyList.splice(i, 1)
                return removed[0]
            }
        }

        return null
    }

    component NotifyWrapper: QtObject {
        id: notifyWrapper
        required property Notification notification

        readonly property Timer timer: Timer {
            interval: notification?.expireTimeout > 0 ? notification?.expireTimeout : 3000
            repeat: false
            running: (notification?.urgency === NotificationUrgency.Critical || notification?.actions.length > 0) ? false : true

            onTriggered: {
                notification?.expire()
                singleton.closed(notification?.id, NotificationCloseReason.toString(NotificationCloseReason.Expired))
                removeNotify(notification?.id)
                notifyWrapper.destroy()
            }
        }
        
        readonly property Connections conn: Connections {
            target: notification
            function onClosed(reason) {
                console.log("notification closed:", notification.id, NotificationCloseReason.toString(reason))
                singleton.closed(notification.id, NotificationCloseReason.toString(reason))
                removeNotify(notification?.id)
                notifyWrapper.destroy()
            }
        }
    }

    Component {
        id: notifyComponent
        NotifyWrapper {
            id: root
            
            Component.onCompleted: {
                var actions = []
                notification.actions.forEach(action => {
                                                 console.log(action.identifier, action.text)
                                                 const item = {
                                                     "identifier": action.identifier,
                                                     "text": action.text
                                                 }
                                                 actions.push(item)
                                             })
                const notify = {
                    "id": notification.id,
                    "appName": notification.appName.toUpperCase(),
                    "appIcon": notification.appIcon,
                    "image": notification.image,
                    "summary": notification.summary,
                    "body": notification.body,
                    "actions": actions
                }
                singleton.notify(notify)
            }
        }
    }

    NotificationServer {
        id: server

        keepOnReload: false
        actionsSupported: true
        actionIconsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        inlineReplySupported: true
        persistenceSupported: true

    }

    Connections {
        target: server
        function onNotification(notification) {
            notification.tracked = true
            notifyList.push(notification)
            notifyComponent.createObject(null, {
                notification: notification
            })
        }
    }

}