import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: root

    required property LockContext context
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    color: colors.window

    Image {
        width: parent.width
        height: parent.height
        source: Quickshell.env("HOME") + "/.config/hypr/wallpaper_current"

        Image {
            source: "white_noise.png"
            width: parent.width
            height: parent.height
            fillMode: Image.Tile
            opacity: 0.1
        }

    }

    Label {
        id: clock

        property var date: new Date()

        color: "white"
        renderType: Text.NativeRendering
        text: {
            const hours = this.date.getHours().toString().padStart(2, '0');
            const minutes = this.date.getMinutes().toString().padStart(2, '0');
            return `${hours}:${minutes}`;
        }

        anchors {
            left: parent.left
            top: parent.top
        }

        font {
            bold: true
            italic: true
            pointSize: 80
        }

        Timer {
            running: true
            repeat: true
            interval: 1000
            onTriggered: clock.date = new Date()
        }

    }

    ColumnLayout {
        width: childrenRect.width
        spacing: 32

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }

        Label {
            color: 'white'
            renderType: Text.NativeRendering
            text: Quickshell.env("USER") ?? "User"

            anchors {
                horizontalCenter: parent.horizontalCenter
            }

        }

        TextField {
            id: passwordBox

            focus: true
            enabled: !root.context.unlockInProgress
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            onTextChanged: root.context.currentText = this.text
            onAccepted: root.context.tryUnlock()

            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            Connections {
                function onCurrentTextChanged() {
                    passwordBox.text = root.context.currentText;
                }

                target: root.context
            }

        }

    }

}
