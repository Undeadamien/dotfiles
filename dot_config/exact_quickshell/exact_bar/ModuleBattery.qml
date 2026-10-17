import QtQuick
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Services.UPower
import "common"

Label {
    id: root

    readonly property var devices: UPower.devices.values
    readonly property var battery: UPower.devices.values.find(d => d.isLaptopBattery)
    property var lerpedColor: lerpColor(Config.bg_alt, Config.fg, battery.percentage)

    visible: battery !== undefined
    text: battery ? "BAT:" + Math.floor(battery.percentage * 100) : ""
    color: lerpedColor

    font {
        bold: true
        family: Config.font.familyPropo
        pixelSize: Config.font.size
    }

    function lerpColor(c1, c2, f) {
        f = Math.max(0, Math.min(1, f));
        let r = c1.r + (c2.r - c1.r) * f;
        let g = c1.g + (c2.g - c1.g) * f;
        let b = c1.b + (c2.b - c1.b) * f;
        let a = c1.a + (c2.a - c1.a) * f;
        return Qt.rgba(r, g, b, a);
    }

    Connections {
        target: battery

        ignoreUnknownSignals: true
        function onStateChanged() {
            if (battery) {
                console.log(UPowerDeviceState.toString(battery.state));
                if (battery.state === UPowerDeviceState.Charging) {
                    animationCharging.start();
                } else {
                    animationCharging.stop();
                }
            }
        }
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                animationCharging.start();
            }
        }
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {} else if (wheel.angleDelta.y < 0) {}
            wheel.accepted = true;
        }
        onExited: event => {}
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.Linear
        }
    }

    SequentialAnimation on color {
        id: animationCharging
        loops: Animation.Infinite

        ColorAnimation {
            duration: 2000
            to: Config.fg
            easing.type: Easing.Linear
        }
        ColorAnimation {
            duration: 2000
            from: Config.fg
            to: Config.bg_alt
            easing.type: Easing.Linear
        }
    }
}
