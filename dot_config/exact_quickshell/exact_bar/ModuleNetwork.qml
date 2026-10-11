import QtQuick
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Networking
import "common"

Label {
    readonly property var devices: Networking.devices.values
    readonly property var wiredDevice: devices.find(d => d.type === DeviceType.Wired)
    readonly property var wifiDevice: devices.find(d => d.type === DeviceType.Wifi)

    readonly property var wiredNetwork: (wiredDevice?.hasLink ?? false) ? wiredDevice.network : null
    readonly property var wifiNetwork: wifiDevice ? wifiDevice.networks.values.find(n => n.connected) : null

    readonly property int wifiSignal: Math.round((wifiNetwork?.signalStrength ?? 0) * 100)

    color: Config.fg
    text: {
        if (wiredNetwork)
            return "NET:ON";
        if (wifiNetwork)
            return "NET:" + wifiSignal;
        return "NET:--";
    }

    font {
        bold: true
        family: Config.font.familyPropo
        pixelSize: Config.font.size
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onClicked: event => {
            if (event.button === Qt.LeftButton) {} else if (event.button === Qt.RightButton) {}
        }
        onEntered: event => {}
        onExited: event => {}
    }
}
