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

    Rectangle {
        anchors.fill: parent
        color: "#60000000"
    }

    ColumnLayout {
        spacing: 4

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.height * 0.12
        }

        Label {
            id: clock

            property var date: new Date()

            color: "white"
            renderType: Text.NativeRendering
            text: {
                const hours = this.date.getHours().toString().padStart(2, '0');
                const minutes = this.date.getMinutes().toString().padStart(2, '0');
                return `${hours}-${minutes}`;
            }
            Layout.alignment: Qt.AlignHCenter
            font.pointSize: Math.min(root.width / 20, 80)
            font.weight: Font.DemiBold

            Timer {
                running: true
                repeat: true
                interval: 1000
                onTriggered: clock.date = new Date()
            }

        }

        Label {
            color: "white"
            opacity: 0.85
            renderType: Text.NativeRendering
            font.pointSize: Math.min(root.width / 60, 24)
            text: Qt.locale().toString(clock.date, "dddd, MMMM d")
            Layout.alignment: Qt.AlignHCenter
        }

    }

    ColumnLayout {
        spacing: 24

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: parent.height * 0.08
        }

        Label {
            color: 'white'
            renderType: Text.NativeRendering
            text: Quickshell.env("USER") ?? "User"
            Layout.alignment: Qt.AlignHCenter
            opacity: 0.95
            font.pointSize: 13
        }

        TextField {
            id: passwordBox

            implicitWidth: Math.min(260, root.width * 0.16)
            focus: true
            enabled: !root.context.unlockInProgress
            echoMode: TextInput.Password
            passwordCharacter: "━"
            inputMethodHints: Qt.ImhSensitiveData
            horizontalAlignment: TextInput.AlignHCenter
            padding: 4
            color: "white"
            palette.text: "white"
            palette.placeholderText: "#80ffffff"
            onTextChanged: root.context.currentText = this.text
            onAccepted: root.context.tryUnlock()
            cursorVisible: false
            cursorDelegate: Item {}
            Layout.alignment: Qt.AlignHCenter

            font {
                letterSpacing: 6
                pointSize: 12
            }

            Connections {
                function onCurrentTextChanged() {
                    passwordBox.text = root.context.currentText;
                }

                target: root.context
            }

            background: Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: root.context.showFailure ? "#ff5c5c" : (passwordBox.activeFocus ? "white" : "#e6ffffff")
            }

        }

    }

}
