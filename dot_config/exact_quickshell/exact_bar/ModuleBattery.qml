import QtQuick
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Services.UPower
import "common"

Label {
    readonly property var devices: UPower.devices.values
    readonly property var battery: UPower.devices.values.find(d => d.isLaptopBattery)

    visible: battery !== undefined
    text: battery ? "BAT:" + Math.floor(battery.percentage * 100) : ""
    color: Config.fg

    font {
        bold: true
        family: Config.font.familyPropo
        pixelSize: Config.font.size
    }
    Component.onCompleted: {
        //console.log(battery);
    }
    //todo: add hover
    //https://quickshell.org/docs/v0.1.0/types/Quickshell.Services.UPower/UPowerDeviceState/
}
