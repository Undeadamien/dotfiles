import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    Config {
        id: cfg
    }

    LockContext {
        id: lockContext

        onLockFrameCaptured: (frame) => {
            snapshot.source = frame;
            releaseTimer.start();
        }
    }

    PanelWindow {
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Image {
            id: snapshot

            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
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

    Timer {
        id: releaseTimer

        interval: 48
        onTriggered: {
            lock.locked = false;
            fadeOut.start();
        }
    }

    NumberAnimation {
        id: fadeOut

        target: snapshot
        property: "opacity"
        to: 0
        duration: 500
        easing.type: Easing.InOutQuad
        onFinished: Qt.quit()
    }

}
