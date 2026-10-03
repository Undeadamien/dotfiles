import Quickshell
import Quickshell.Wayland

ShellRoot {
    Config {
        id: cfg
    }

    LockContext {
        id: lockContext

        onUnlocked: {
            lock.locked = false;
            Qt.quit();
        }
    }

    WlSessionLock {
        id: lock

        locked: true

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
                config: cfg
            }

        }

    }

}