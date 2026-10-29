import "common"
import QtQuick
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Services.UPower

Label {
    id: root
    readonly property var devices: UPower.devices.values
    readonly property var battery: UPower.devices.values.find(d => d.isLaptopBattery)
    property var lerpedColor: lerpColor(Config.bg_alt, Config.fg, battery.percentage)

    visible: battery !== undefined
    text: battery ? "BAT:" + String(Math.floor(battery.percentage * 100)).padStart(2, '0') : ""
    color: battery ? lerpedColor : Config.fg

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

    function isCharging() {
        if (!battery)
            return false;
        //todo: consider `FullyCharged` with `battery.percentage!==1` ?
        return battery.state === UPowerDeviceState.Charging;
    }

    Connections {
        target: battery

        ignoreUnknownSignals: true
        function onStateChanged() {
            if (!battery)
                return;
            //console.log(UPowerDeviceState.toString(battery.state));
            if (isCharging()) {
                animationCharging.start();
            } else {
                animationCharging.stop();
                root.color = lerpedColor;//todo: check if needed
            }
            //console.log(animationCharging.running);
        }
    }

    PopupWindow {
        id: popupwindow

        visible: false
        anchor.item: root
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        anchor.adjustment: PopupAdjustment.All

        implicitWidth: column.implicitWidth
        implicitHeight: column.implicitHeight
        color: Config.bg

        Column {
            id: column
            Label {
                text: {
                    var totalSeconds;
                    if (battery.timeToFull)
                        totalSeconds = battery.timeToFull;
                    else if (battery.timeToEmpty)
                        totalSeconds = battery.timeToEmpty;
                    else
                        return `${UPowerDeviceState.toString(battery.state)}: --:--:--`;
                    const hours = Math.floor(totalSeconds / 3600);
                    const minutes = Math.floor((totalSeconds % 3600) / 60);
                    const seconds = totalSeconds % 60;
                    var timeString = [hours, minutes, seconds].map(val => String(val).padStart(2, '0')).join(':');
                    return `${UPowerDeviceState.toString(battery.state)}: ${timeString}`;
                }

                color: Config.fg
                padding: 6
                font {
                    bold: true
                    family: Config.font.familyPropo
                    pixelSize: Config.font.size
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            border.color: Config.border
            border.width: 1
            color: "transparent"
        }
    }

    //todo: add a window an hover to show times and states
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
        onEntered: event => {
            popupwindow.visible = true;
        }
        onExited: event => {
            popupwindow.visible = false;
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.Linear
        }
    }

    SequentialAnimation on color {
        id: animationCharging
        running: isCharging()
        loops: Animation.Infinite

        ColorAnimation {
            duration: 2000
            to: Config.fg
            easing.type: Easing.Linear
        }
        ColorAnimation {
            duration: 2000
            from: Config.fg
            to: Config.border
            easing.type: Easing.Linear
        }
    }
}
