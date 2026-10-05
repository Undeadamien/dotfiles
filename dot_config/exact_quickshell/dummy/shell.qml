import QtQuick
import QtQuick.Window
import Quickshell

Window {
    visible: true
    color: 'transparent'
    onClosing: {
        Qt.quit();
    }
    title: "quickshell_dummy"
}
