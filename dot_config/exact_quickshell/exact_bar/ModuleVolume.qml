import QtQuick
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Services.Pipewire
import "common"

Label {
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real step: 0.05

    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    color: Config.fg
    text: (muted ? "MUT:" : "VOL:") + String(Math.round(volume * 100)).padStart(2, '0')

    PwObjectTracker {
        objects: [sink]
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                sink.audio.muted = !sink.audio.muted;
            } else if (event.button === Qt.RightButton) {
                //todo: add a menu
            }
        }
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                sink.audio.volume = Math.round(Math.min(1, sink.audio.volume + step) * 100) / 100;
            } else if (wheel.angleDelta.y < 0) {
                sink.audio.volume = Math.round(Math.max(0, sink.audio.volume - step) * 100) / 100;
            }
            wheel.accepted = true;
        }
    }

    font {
        bold: true
        family: Config.font.familyPropo
        pixelSize: Config.font.size
    }
}
