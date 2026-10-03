import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: root

    required property LockContext context
    required property QtObject config
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    color: colors.window

    Image {
        source: Quickshell.env("HOME") + "/.config/hypr/wallpaper_current"
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop

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

            color: config.fg
            renderType: Text.NativeRendering
            text: {
                const hours = this.date.getHours().toString().padStart(2, '0');
                const minutes = this.date.getMinutes().toString().padStart(2, '0');
                return `${hours}-${minutes}`;
            }
            Layout.alignment: Qt.AlignHCenter

            font {
                pointSize: Math.max(1, Math.min(root.width / 20, 80))
                weight: Font.DemiBold
                family: "DepartureMono Nerd Font"
            }

            Timer {
                running: true
                repeat: true
                interval: 1000
                onTriggered: clock.date = new Date()
            }

        }

        Label {
            color: config.fg
            opacity: 0.85
            renderType: Text.NativeRendering
            text: Qt.locale().toString(clock.date, "dddd, MMMM d")
            Layout.alignment: Qt.AlignHCenter

            font {
                pointSize: Math.max(1, Math.min(root.width / 60, 24))
                family: "DepartureMono Nerd Font"
            }

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
            color: config.fg
            renderType: Text.NativeRendering
            text: Quickshell.env("USER") ?? "User"
            Layout.alignment: Qt.AlignHCenter
            opacity: 0.95

            font {
                pointSize: 13
                family: "DepartureMono Nerd Font"
            }

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
            color: config.fg
            palette.text: config.fg
            palette.windowText: config.fg
            palette.buttonText: config.fg
            palette.placeholderText: "#80ffffff"
            onTextChanged: root.context.currentText = this.text
            onAccepted: root.context.tryUnlock()
            cursorVisible: false
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

            cursorDelegate: Item {
            }

            background: Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: root.context.showFailure ? "#ff5c5c" : (passwordBox.activeFocus ? config.fg : config.fg)
                opacity: root.context.showFailure ? 1 : (passwordBox.activeFocus ? 1 : 0.9)
            }

        }

    }

}
