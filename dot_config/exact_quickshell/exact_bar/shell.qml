//@ pragma UseQApplication
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "common"

PanelWindow {
    id: root

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

    RowLayout {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        ModuleDate {}
        ModuleTime {}
        ModuleMpris {}
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
        spacing: 8

        ModuleSystemTray {}
        ModuleBattery {}
        ModuleVolume {}
        ModuleNetwork {}
    }
}
