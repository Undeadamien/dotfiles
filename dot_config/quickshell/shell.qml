import Qt.labs.folderlistmodel
import QtMultimedia
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import Quickshell.Wayland

PanelWindow {
    id: window

    function setWallpaper(url) {
        var path = url.toString().replace("file://", "");
        var current = root.config.homeDir + "/.config/hypr/wallpaper_current";
        Quickshell.execDetached(["bash", "-c", "ln -sf \"" + path + "\" \"" + current + "\" && " + "awww img \"" + current + "\" --transition-duration 8 --transition-type fade --transition-fps 60"]);
    }

    function playSound() {
        player.stop();
        player.play();
    }

    color: "#00000000"
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace: "quickshell_wallpaper"

    anchors {
        bottom: true
        left: true
        right: true
        top: true
    }

    MediaPlayer {
        id: player

        source: "file://" + root.config.homeDir + "/.config/quickshell/button_press.mp3"

        audioOutput: AudioOutput {
            volume: 1
        }

    }

    Item {
        id: root

        readonly property QtObject
        config: Config {
        }

        property var allUrls: []
        property int currentIndex: 0
        readonly property int visibleCount: 5
        readonly property real cardWidth: Screen.width * (2 / 3) / visibleCount
        readonly property real cardHeight: Screen.height / 3
        readonly property real skewAngle: -16
        readonly property real skewTan: Math.tan(skewAngle * Math.PI / 180)
        readonly property real extraWidth: Math.abs(skewTan) * cardHeight

        function navigate(dir) {
            var total = root.allUrls.length;
            if (total === 0)
                return ;

            for (var i = 0; i < root.visibleCount; i++) {
                var card = cardRepeater.itemAt(i);
                if (card)
                    card.captureOld();

            }
            root.currentIndex = ((root.currentIndex + dir) % total + total) % total;
            for (var i = 0; i < root.visibleCount; i++) {
                var card = cardRepeater.itemAt(i);
                if (card)
                    card.startSlide(dir);

            }
            playSound();
        }

        function confirmWallpaper() {
            var total = root.allUrls.length;
            if (total === 0)
                return ;

            var middleUrl = root.allUrls[(root.currentIndex + 2) % total];
            if (middleUrl)
                window.setWallpaper(middleUrl);

        }

        activeFocusOnTab: true
        focus: true
        anchors.fill: parent
        Component.onCompleted: forceActiveFocus()
        Keys.onPressed: (event) => {
            switch (event.key) {
            case Qt.Key_H:
            case Qt.Key_K:
            case Qt.Key_Left:
                root.navigate(-1);
                break;
            case Qt.Key_J:
            case Qt.Key_L:
            case Qt.Key_Right:
                root.navigate(1);
                break;
            case Qt.Key_Return:
            case Qt.Key_Enter:
                root.confirmWallpaper();
                Qt.quit();
                break;
            case Qt.Key_Escape:
                Qt.quit();
                break;
            }
        }

        FolderListModel {
            id: folderModel

            folder: "file://" + root.config.homeDir + "/.config/hypr/wallpaper/"
            showDirs: false
            showDotAndDotDot: false
            nameFilters: ["*"]
            onCountChanged: {
                if (count === 0)
                    return ;

                var indices = Array.from({
                    "length": count
                }, (_, i) => {
                    return i;
                });
                for (var i = indices.length - 1; i > 0; i--) {
                    var j = Math.floor(Math.random() * (i + 1));
                    [indices[i], indices[j]] = [indices[j], indices[i]];
                }
                var urls = [];
                for (var i = 0; i < count; i++) urls.push(folderModel.get(indices[i], "fileUrl"))
                root.allUrls = urls;
            }
        }

        Row {
            id: cardRow

            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -root.skewTan * Screen.height / 6
            spacing: root.config.gaps * 2

            Repeater {
                id: cardRepeater

                model: root.visibleCount

                delegate: Item {
                    id: card

                    function captureOld() {
                        if (bg.status === Image.Ready)
                            fg.source = bg.source;

                    }

                    function startSlide(dir) {
                        if (fg.source === "")
                            return ;

                        fgSlide.x = 0;
                        fg.opacity = 1;
                        fgSlideAnim.to = -dir * root.cardWidth;
                        fgSlideAnim.start();
                        fgFadeAnim.start();
                    }

                    width: root.cardWidth
                    height: root.cardHeight
                    antialiasing: true

                    Item {
                        id: clipItem

                        anchors.fill: parent
                        clip: true
                        antialiasing: true

                        Rectangle {
                            anchors.fill: parent
                            color: "black"
                        }

                        Image {
                            id: bg

                            x: -root.extraWidth
                            y: 0
                            width: parent.width + 2 * root.extraWidth
                            height: parent.height
                            source: root.allUrls.length > 0 ? root.allUrls[(root.currentIndex + index) % root.allUrls.length] : ""
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            smooth: true
                            opacity: bg.status === Image.Ready ? 1 : 0

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 300
                                    easing.type: Easing.OutCubic
                                }

                            }

                            transform: Matrix4x4 {
                                matrix: Qt.matrix4x4(1, -root.skewTan, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                            }

                        }

                        Image {
                            id: fg

                            x: -root.extraWidth
                            y: 0
                            width: parent.width + 2 * root.extraWidth
                            height: parent.height
                            source: ""
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            smooth: true
                            opacity: 0
                            transform: [
                                Matrix4x4 {
                                    matrix: Qt.matrix4x4(1, -root.skewTan, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                                },
                                Translate {
                                    id: fgSlide

                                    x: 0
                                }
                            ]

                            NumberAnimation {
                                id: fgSlideAnim

                                target: fgSlide
                                property: "x"
                                duration: 150
                                easing.type: Easing.OutCubic
                            }

                            NumberAnimation {
                                id: fgFadeAnim

                                target: fg
                                property: "opacity"
                                to: 0
                                duration: 150
                                easing.type: Easing.OutCubic
                                onRunningChanged: {
                                    if (!running)
                                        fg.source = "";

                                }
                            }

                        }

                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.color: root.config.borderColor
                            border.width: 1
                        }

                    }

                    Rectangle {
                        anchors.fill: clipItem
                        anchors.margins: -1
                        border.color: "black"
                        border.width: 1
                        color: "transparent"
                        opacity: 0.5
                    }

                    transform: Matrix4x4 {
                        matrix: Qt.matrix4x4(1, root.skewTan, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                    }

                }

            }

        }

    }

}
