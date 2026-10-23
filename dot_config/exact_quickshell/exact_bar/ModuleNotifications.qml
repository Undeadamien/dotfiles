import "common"
import QtQuick
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Services.Notifications

Label {
    property bool dnd: false

    text: {
        return "NOT"; // really?
    }

    color: {
        Config.fg;
    }

    font {
        bold: true
        family: Config.font.familyPropo
        pixelSize: Config.font.size
        strikeout: dnd
    }

    NotificationServer {
        id: server

        property var notifications: trackedNotifications.values

        onNotification: notification => {
            notification.tracked = true;
            console.log(notification.summary, notification.body);
        }
    }

    Timer {
        running: true
        repeat: true
        interval: 1000

        onTriggered: {
            if (!server.notifications)
                return;
            for (var i = 0; i < server.notifications.length; i++) {
                console.log(server.notifications[i]);
            }
        }
    }

    MouseArea {
        id: mousearea

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                //
            } else if (event.button === Qt.RightButton) {
                dnd = !dnd;
            }
        }
    }
}
