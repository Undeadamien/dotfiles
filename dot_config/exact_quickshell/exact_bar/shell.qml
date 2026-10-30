//@ pragma UseQApplication
import "common"
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import Quickshell.Wayland

PanelWindow {
    id: root

    readonly property int spacing_: 4

    readonly property bool hasMpd: Mpris.players.values.some(p => p.identity === "Music Player Daemon")
    readonly property bool hasBattery: UPower.devices.values.some(d => d.isLaptopBattery)
    readonly property bool hasTray: SystemTray.items.values.length != 0

    color: Config.bg
    implicitHeight: 26

    WlrLayershell.namespace: "quickshell_bar"

    anchors {
        left: true
        right: true
        top: true
    }

    Rectangle {
        height: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        border.color: Config.border
        border.width: 1
    }

    Rectangle {
        opacity: 0.8
        height: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        border.color: Config.bg
        border.width: 1
    }

    component Sep: Label {
        text: "|"
        color: Config.fg
        font {
            bold: false
            family: Config.font.familyPropo
            pixelSize: Config.font.size
        }
    }

    RowLayout {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: spacing_

        ModuleDate {}
        Sep {}
        ModuleTime {}
        Sep {
            visible: hasMpd
        }
        Loader {
            active: hasMpd
            visible: hasMpd
            sourceComponent: ModuleMpris {}
        }
    }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        ModuleWorkspace {}
    }

    RowLayout {
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: spacing_

        ModuleSystemTray {
            parentwindow: root
        }
        Sep {
            visible: hasTray
        }
        Loader {
            active: hasBattery
            visible: hasBattery
            sourceComponent: ModuleBattery {}
        }
        Sep {
            visible: hasBattery
        }
        ModuleVolume {}
        Sep {}
        ModuleNetwork {}
        Sep {}
        ModuleNotifications {}
    }
}
