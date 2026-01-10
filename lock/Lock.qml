pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {

    property alias lock: lock

    IpcHandler {
        id: handler
        target: "lock"

        function lock(): void {
            lock.locked = true;
        }
    }

    LockContext {
        id: lockContext

        onUnlocked: {
            lock.locked = false;
        }
    }

    WlSessionLock {
        id: lock

        // Lock the session immediately when quickshell starts.
        locked: false

        surface: WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                screen: parent.screen
                context: lockContext
            }
        }
    }
}
