import QtQuick
import QtQuick.Effects
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import "common"

//todo: consider multiple Label for more control
Label {
    id: root
    readonly property var mpdPlayer: Mpris.players.values.find(p => p.identity === "Music Player Daemon")
    readonly property real step: 0.05
    readonly property string volume: mpdPlayer ? String(Math.round(mpdPlayer.volume * 100)).padStart(2, '0') : ""
    readonly property real barHeight: Window.window ? Window.window.height : height

    visible: mpdPlayer ?? false

    text: {
        if (!mpdPlayer || !mpdPlayer.trackTitle)
            return "MPD:STP";
        else if (mpdPlayer.isPlaying)
            return "MPD:PLY";
        else
            return "MPD:PSD";
    }

    color: Config.fg
    font {
        bold: true
        family: Config.font.familyPropo
        pixelSize: Config.font.size
    }

    PopupWindow {
        id: popupwindow

        visible: false
        anchor.item: root
        anchor.margins {
            bottom: 3
            left: 3
            right: 3
            top: 3
        }
        implicitWidth: column.implicitWidth
        implicitHeight: column.implicitHeight
        color: Config.bg

        anchor.rect.x: root.implicitWidth / 2 - implicitWidth / 2
        anchor.rect.y: (root.barHeight + root.height) / 2

        Column {
            id: column
            Label {
                text: "Volume: " + volume
                color: Config.fg
                padding: 6
                font {
                    bold: true
                    family: Config.font.familyPropo
                    pixelSize: Config.font.size
                }
            }
        }

        //TODO: add a shadow
        Rectangle {
            anchors.fill: parent
            border.color: Config.border
            border.width: 1
            color: "transparent"
        }
    }

    Process {
        id: rmpcAddAll
        running: false
        command: ["sh", "-c", "mpc clear; mpc add \/; mpc play"]
    }

    Process {
        id: rmpcOpener
        running: false
        command: ["sh", "-c", "kitty -e rmpc"]
        environment: ({
                //prevents half-block on the album art
                TMUX: null,
                TMUX_PANE: null
            })
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                if (!mpdPlayer.trackTitle) {
                    rmpcAddAll.running = true;
                } else
                    mpdPlayer.togglePlaying();
            } else if (event.button === Qt.RightButton) {
                //todo: replace with a menu
                rmpcOpener.startDetached();
            }
        }
        onWheel: wheel => {
            popupwindow.visible = true;
            if (wheel.angleDelta.y > 0) {
                mpdPlayer.volume = Math.round(Math.min(1, mpdPlayer.volume + step) * 100) / 100;
            } else if (wheel.angleDelta.y < 0) {
                mpdPlayer.volume = Math.round(Math.max(0, mpdPlayer.volume - step) * 100) / 100;
            }
            wheel.accepted = true;
        }
        onExited: event => {
            popupwindow.visible = false;
        }
    }

    //DEBUG
    onMpdPlayerChanged: {
        if (!mpdPlayer) {
            return;
        }
    }
}
