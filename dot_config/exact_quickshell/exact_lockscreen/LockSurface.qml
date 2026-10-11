import QtMultimedia
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import "common"

Rectangle {
    id: root

    required property LockContext context
    property var lockFrame

    color: palette.window

    Connections {
        function onUnlocked() {
            root.grabToImage(result => {
                root.lockFrame = result;
                root.context.lockFrameCaptured(result.url);
            });
        }

        target: root.context
    }

    Image {
        source: Config.wallpaperCurrent
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: '#1a000000'
    }

    Rectangle {
        anchors.fill: parent

        gradient: Gradient {
            GradientStop {
                position: 0
                color: '#8c000000'
            }

            GradientStop {
                position: 0.4
                color: "transparent"
            }

            GradientStop {
                position: 0.6
                color: "transparent"
            }

            GradientStop {
                position: 1
                color: '#8c000000'
            }
        }
    }

    ColumnLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.height * (1 / 8)
        }

        Label {
            id: clock

            property var date: new Date()

            color: Config.fg
            text: {
                const hours = this.date.getHours().toString().padStart(2, '0');
                const minutes = this.date.getMinutes().toString().padStart(2, '0');
                return `${hours}-${minutes}`;
            }
            Layout.alignment: Qt.AlignHCenter

            font {
                bold: true
                pointSize: Math.max(1, Math.min(root.width / 20, 80))
                family: Config.font.family
            }

            Timer {
                running: true
                repeat: true
                interval: 1000
                onTriggered: clock.date = new Date()
            }
        }

        Label {
            color: Config.fg
            text: Qt.locale().toString(clock.date, "dddd, MMMM d")
            Layout.alignment: Qt.AlignHCenter

            font {
                bold: true
                pointSize: Math.max(1, Math.min(root.width / 60, 24))
                family: Config.font.family
            }
        }
    }

    ColumnLayout {
        spacing: 16

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: parent.height * (1 / 10)
        }

        Label {
            color: Config.fg
            text: Quickshell.env("USER") ?? "User"
            Layout.alignment: Qt.AlignHCenter

            font {
                pointSize: 16
                family: Config.font.family
                bold: true
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
            padding: 6
            color: Config.fg
            onTextChanged: {
                root.context.currentText = this.text;
                player.play();
            }
            onAccepted: {
                root.context.tryUnlock();
                player.play();
            }
            onCursorPositionChanged: {
                if (cursorPosition !== text.length)
                    cursorPosition = text.length;
            }
            cursorVisible: false
            Layout.alignment: Qt.AlignHCenter

            SoundEffect {
                id: player

                source: Config.clickSound
            }

            palette {
                text: Config.fg
                windowText: Config.fg
                buttonText: Config.fg
            }

            font {
                bold: true
                letterSpacing: 6
                pointSize: 12
            }

            Connections {
                function onCurrentTextChanged() {
                    passwordBox.text = root.context.currentText;
                }

                target: root.context
            }

            cursorDelegate: Item {}

            background: Rectangle {
                id: underline

                property bool failureFaded: false
                readonly property bool showingFailure: root.context.showFailure && !failureFaded

                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: showingFailure ? Config.failure : Config.fg

                Timer {
                    id: failureTimer

                    interval: 200
                    onTriggered: underline.failureFaded = true
                }

                Connections {
                    function onShowFailureChanged() {
                        underline.failureFaded = false;
                        if (root.context.showFailure)
                            failureTimer.restart();
                    }

                    target: root.context
                }

                Behavior on color {
                    enabled: underline.failureFaded

                    ColorAnimation {
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
