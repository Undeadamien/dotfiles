import QtQuick
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

//todo: rework the menu to be able to style the entries

Row {
    required property PanelWindow parentwindow

    spacing: 4
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items

        IconImage {
            id: icon

            required property SystemTrayItem modelData
            source: modelData.icon
            implicitSize: 14

            QsMenuAnchor {
                id: menu
                menu: modelData.menu
                anchor.item: icon
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.adjustment: PopupAdjustment.All
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: event => {
                    if (event.button === Qt.LeftButton) {
                        modelData.activate();
                    } else if (event.button === Qt.RightButton) {
                        menu.open();
                    }
                }
            }
        }
    }
}
