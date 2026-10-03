import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell.Wayland

Rectangle {
    id: root

    required property LockContext context
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

    color: colors.window

    Button {
        text: "Its not working, let me out"
        onClicked: context.unlocked()
    }

    Label {
        id: clock

        property var date: new Date()

        renderType: Text.NativeRendering
        font.pointSize: 80
        text: {
            const hours = this.date.getHours().toString().padStart(2, '0');
            const minutes = this.date.getMinutes().toString().padStart(2, '0');
            return `${hours}:${minutes}`;
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 100
        }

        Timer {
            running: true
            repeat: true
            interval: 1000
            onTriggered: clock.date = new Date()
        }

    }

    ColumnLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
        }

        ColumnLayout {
            TextField {
                id: passwordBox

                implicitWidth: 400
                padding: 10
                focus: true
                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                onTextChanged: root.context.currentText = this.text
                onAccepted: root.context.tryUnlock()

                Connections {
                    function onCurrentTextChanged() {
                        passwordBox.text = root.context.currentText;
                    }

                    target: root.context
                }

            }

            Button {
                text: "Unlock"
                padding: 10
                focusPolicy: Qt.NoFocus
                enabled: !root.context.unlockInProgress && root.context.currentText !== ""
                onClicked: root.context.tryUnlock()
            }

        }

        Label {
            visible: root.context.showFailure
            text: "Incorrect password"
        }

    }

}
