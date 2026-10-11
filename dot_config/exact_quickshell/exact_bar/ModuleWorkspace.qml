import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Mpris
import "common"

Row {
    id: root

    readonly property var workspaces: Hyprland.workspaces.values
    readonly property real barHeight: Window.window ? Window.window.height : height
    spacing: 4

    Repeater {
        model: 5

        Rectangle {
            required property int index
            readonly property int wsId: index + 1
            readonly property var workspace: root.workspaces.find(w => w.id === wsId)
            readonly property int windowCount: workspace ? workspace.toplevels.values.length : 0

            anchors.verticalCenter: parent.verticalCenter
            border.color: Config.border
            color: workspace && workspace.focused ? Config.border : windowCount > 0 ? Config.bg_alt : Config.bg
            implicitHeight: 16
            implicitWidth: 32

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.Linear
                }
            }

            MouseArea {
                id: mousearea
                anchors.fill: parent
                onClicked: {
                    if (workspace) {
                        workspace.activate();
                    } else {
                        Hyprland.dispatch('hl.dsp.focus({ workspace = "' + wsId + '" })');
                    }
                }
            }
        }
    }
}
