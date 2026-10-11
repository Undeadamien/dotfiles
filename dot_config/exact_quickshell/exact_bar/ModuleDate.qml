import QtQuick
import QtQuick.Controls.Fusion
import Quickshell
import "common"

Label {
    property var date: new Date()

    color: Config.fg
    text: Qt.locale().toString(date, "yy-MM-dd ddd")

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
