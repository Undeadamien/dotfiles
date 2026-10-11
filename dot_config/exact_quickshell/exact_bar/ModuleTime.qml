import QtQuick
import QtQuick.Controls.Fusion
import Quickshell
import "common"

Label {
    property var date: new Date()

    color: Config.fg
    text: {
        const hours = date.getHours().toString().padStart(2, '0');
        const minutes = date.getMinutes().toString().padStart(2, '0');
        return `${hours}:${minutes}`;
    }

    font {
        bold: true
        family: Config.font.familyPropo
        pixelSize: Config.font.size
    }

    Timer {
        running: true
        repeat: true
        interval: 1000
        onTriggered: date = new Date()
    }
}
