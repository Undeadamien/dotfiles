import "common"
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

Label {
    id: root

    property bool dnd: false
    property var popups: []
    property double lastClosed: 0
    readonly property int count: server.trackedNotifications.values.length

    text: root.count > 0 ? "<!>" : "<->"
    color: root.dnd ? Config.border : Config.fg

    font {
        bold: Config.font.bold
        family: Config.font.familyPropo
        pixelSize: Config.font.size
    }

    function removePopup(n) {
        popups = popups.filter(p => p !== n);
    }

    function openHistory() {
        const p = root.QsWindow.window.contentItem.mapFromItem(root, 0, 0);
        history.anchorX = p.x + root.width / 2;
        history.visible = true;
    }

    function closeHistory() {
        history.visible = false;
        root.lastClosed = Date.now();
    }

    NotificationServer {
        id: server

        keepOnReload: false
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: false

        onNotification: notification => {
            notification.tracked = true;
            notification.closed.connect(() => root.removePopup(notification));

            const critical = notification.urgency === NotificationUrgency.Critical;
            if (history.visible)
                return;
            if (!root.dnd || critical)
                root.popups = [...root.popups, notification];
        }
    }

    Component {
        id: cardDelegate

        Rectangle {
            id: card

            required property var modelData
            readonly property bool toast: ListView.view.toast
            readonly property bool critical: modelData.urgency === NotificationUrgency.Critical

            width: ListView.view.width
            implicitHeight: col.implicitHeight + Config.gaps * 2
            color: Config.bg
            border.width: 1
            border.color: critical ? Config.failure : Config.border

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                onClicked: event => {
                    if (event.button === Qt.MiddleButton && card.toast)
                        root.removePopup(card.modelData);
                    else
                        card.modelData.dismiss();
                }
            }

            Timer {
                running: card.toast && !card.critical
                interval: card.modelData.expireTimeout > 0 ? card.modelData.expireTimeout * 1000 : 5000
                onTriggered: root.removePopup(card.modelData)
            }

            ColumnLayout {
                id: col

                anchors.fill: parent
                anchors.margins: Config.gaps
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        Layout.fillWidth: true
                        text: card.modelData.summary
                        color: Config.fg
                        elide: Text.ElideRight
                        font {
                            bold: true
                            family: Config.font.familyPropo
                            pixelSize: Config.font.size
                        }
                    }

                    Label {
                        text: card.modelData.appName
                        color: Config.border
                        visible: text !== ""
                        font {
                            family: Config.font.familyPropo
                            pixelSize: Config.font.size - 2
                        }
                    }
                }

                Label {
                    Layout.fillWidth: true
                    visible: text !== ""
                    text: card.modelData.body
                    textFormat: Text.StyledText
                    wrapMode: Text.Wrap
                    maximumLineCount: 6
                    elide: Text.ElideRight
                    color: Config.fg
                    font {
                        family: Config.font.familyPropo
                        pixelSize: Config.font.size - 1
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    visible: card.modelData.actions.length > 0
                    spacing: 4

                    Repeater {
                        model: card.modelData.actions

                        Rectangle {
                            required property var modelData

                            implicitWidth: actionLabel.implicitWidth + 12
                            implicitHeight: actionLabel.implicitHeight + 6
                            color: actionArea.containsMouse ? Config.bg_alt : Config.bg
                            border.color: Config.border
                            border.width: 1

                            Label {
                                id: actionLabel
                                anchors.centerIn: parent
                                text: parent.modelData.text
                                color: Config.fg
                                font {
                                    family: Config.font.familyPropo
                                    pixelSize: Config.font.size - 1
                                }
                            }

                            MouseArea {
                                id: actionArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    parent.modelData.invoke();
                                    root.removePopup(card.modelData);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    PanelWindow {
        visible: root.popups.length > 0
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        implicitWidth: 320
        implicitHeight: 600
        mask: Region {
            item: toastList
        }

        WlrLayershell.namespace: "quickshell_notifications"
        WlrLayershell.layer: WlrLayer.Overlay

        anchors {
            top: true
            right: true
        }

        margins {
            top: 34
            right: Config.gaps
        }

        ListView {
            id: toastList

            property bool toast: true

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: contentHeight
            interactive: false
            spacing: Config.gaps
            model: ScriptModel {
                values: root.popups
            }
            delegate: cardDelegate

            add: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 120
                }
            }
            displaced: Transition {
                NumberAnimation {
                    property: "y"
                    duration: 120
                }
            }
        }
    }

    PanelWindow {
        id: history

        property real anchorX: 0

        visible: false
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        screen: root.QsWindow.window.screen

        WlrLayershell.namespace: "quickshell_notifications_history"
        WlrLayershell.layer: WlrLayer.Overlay

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        onVisibleChanged: {
            root.popups = [];
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onPressed: root.closeHistory()
        }

        Rectangle {
            id: box

            readonly property real margin: Config.gaps

            width: 320
            height: Math.min(header.height + Config.gaps * 3 + Math.max(list.contentHeight, 24), 480)
            x: Math.max(margin, Math.min(history.anchorX - width / 2, history.width - width - margin))
            y: root.QsWindow.window.height + Config.gaps
            color: Config.bg
            border.color: Config.border
            border.width: 1

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                onPressed: event => event.accepted = true
            }

            RowLayout {
                id: header

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: Config.gaps
                }

                Label {
                    Layout.fillWidth: true
                    text: root.dnd ? "Do not disturb" : "Notifications"
                    color: Config.fg
                    font {
                        bold: true
                        family: Config.font.familyPropo
                        pixelSize: Config.font.size
                    }
                }

                Label {
                    text: "Clear all"
                    color: clearArea.containsMouse ? Config.fg : Config.border
                    visible: root.count > 0
                    font {
                        family: Config.font.familyPropo
                        pixelSize: Config.font.size - 1
                    }

                    MouseArea {
                        id: clearArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            const all = [...server.trackedNotifications.values];
                            all.forEach(n => n.dismiss());
                        }
                    }
                }
            }

            ListView {
                id: list

                property bool toast: false

                anchors {
                    top: header.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    margins: Config.gaps
                }

                clip: true
                spacing: Config.gaps
                verticalLayoutDirection: ListView.BottomToTop
                model: server.trackedNotifications
                delegate: cardDelegate

                displaced: Transition {
                    NumberAnimation {
                        property: "y"
                        duration: 120
                    }
                }

                Label {
                    anchors.centerIn: parent
                    visible: root.count === 0
                    text: "Nothing here"
                    color: Config.border
                    font {
                        family: Config.font.familyPropo
                        pixelSize: Config.font.size
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                if (history.visible)
                    root.closeHistory();
                else if (Date.now() - root.lastClosed > 250)
                    root.openHistory();
            } else if (event.button === Qt.RightButton) {
                root.dnd = !root.dnd;
            }
        }
    }
}
