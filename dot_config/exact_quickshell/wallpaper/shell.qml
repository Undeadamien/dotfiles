import Qt.labs.folderlistmodel
import QtMultimedia
import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: window

    function setWallpaper(url) {
        var path = url.toString().replace("file://", "");
        var current = Quickshell.env("HOME") + "/.config/hypr/wallpaper_current";
        Quickshell.execDetached(["bash", "-c", "ln -sf \"" + path + "\" \"" + current + "\" && " + "awww img \"" + current + "\" --transition-duration 8 --transition-type fade --transition-fps 30"]);
    }

    color: "#80000000"
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace: "quickshell_wallpaper"

    anchors {
        bottom: true
        left: true
        right: true
        top: true
    }

    SoundEffect {
        id: player

        source: "file://" + Quickshell.env("HOME") + "/.config/quickshell/button_press.wav"
    }

    Item {
        id: root

        readonly property QtObject
        config: Config {
        }

        property var allUrls: []
        property var allThumbs: []
        property bool thumbsReady: false
        property int currentIndex: 0
        property int visibleCount: 5
        readonly property int deckSlots: 5
        readonly property int visibleRadius: Math.floor((deckSlots - 1) / 2)
        readonly property real cardWidth: Screen.width * config.deckWidthFraction / deckSlots
        readonly property real cardHeight: cardWidth * 9 / 16
        readonly property real cardSpacing: config.gaps * 2
        readonly property int centerIndex: Math.floor(visibleCount / 2)
        readonly property string thumbDir: (Quickshell.env("XDG_CACHE_HOME") || Quickshell.env("HOME") + "/.cache") + "/hypr/wallpaper-thumbs"

        function refreshDeck() {
            if (folderModel.count === 0 || !root.thumbsReady)
                return ;

            var indices = Array.from({
                "length": folderModel.count
            }, (_, i) => {
                return i;
            });
            for (var i = indices.length - 1; i > 0; i--) {
                var j = Math.floor(Math.random() * (i + 1));
                [indices[i], indices[j]] = [indices[j], indices[i]];
            }
            var urls = [];
            var thumbs = [];
            for (var i = 0; i < folderModel.count; i++) {
                var url = folderModel.get(indices[i], "fileUrl");
                urls.push(url);
                thumbs.push("file://" + root.thumbDir + "/" + url.toString().split("/").pop());
            }
            root.allUrls = urls;
            root.allThumbs = thumbs;
            root.visibleCount = Math.min(folderModel.count, root.deckSlots);
        }

        function isCardVisible(idx) {
            return Math.abs(idx - root.centerIndex) <= root.visibleRadius;
        }

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
            player.stop();
            player.play();
        }

        function confirmWallpaper() {
            var total = root.allUrls.length;
            if (total === 0)
                return ;

            var middleUrl = root.allUrls[(root.currentIndex + Math.floor(root.visibleCount / 2)) % total];
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
            case Qt.Key_J:
            case Qt.Key_Left:
                root.navigate(-1);
                break;
            case Qt.Key_K:
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

            folder: "file://" + Quickshell.env("HOME") + "/.config/hypr/wallpaper/"
            showDirs: false
            showDotAndDotDot: false
            nameFilters: ["*"]
            onCountChanged: {
                if (count > 0 && !root.thumbsReady)
                    thumbnailer.running = true;
                else
                    root.refreshDeck();
            }
        }

        Process {
            id: thumbnailer

            command: ["bash", Quickshell.env("HOME") + "/.config/quickshell/wallpaper/thumbnails.sh"]
            running: true
            onExited: {
                root.thumbsReady = true;
                root.refreshDeck();
            }
        }

        Row {
            spacing: root.cardSpacing
            anchors.verticalCenter: parent.verticalCenter
            x: (parent.width - root.cardWidth) / 2 - root.centerIndex * (root.cardWidth + root.cardSpacing)

            Repeater {
                id: cardRepeater

                model: root.visibleCount

                delegate: Item {
                    function captureOld() {
                        if (bg.status === Image.Ready)
                            fg.source = bg.source;

                    }

                    function startSlide(dir) {
                        if (fg.source === "")
                            return ;

                        fg.opacity = 1;
                        fgFadeAnim.start();
                    }

                    width: root.cardWidth
                    height: root.cardHeight
                    antialiasing: true
                    opacity: root.isCardVisible(index) ? 1 : 0

                    Item {
                        anchors.fill: parent
                        clip: true
                        antialiasing: true

                        Rectangle {
                            anchors.fill: parent
                            color: "black"
                        }

                        Image {
                            id: bg

                            anchors.fill: parent
                            source: root.allThumbs.length > 0 ? root.allThumbs[(root.currentIndex + index) % root.allThumbs.length] : ""
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            smooth: true
                            cache: true
                            sourceSize.width: root.cardWidth * 2
                            sourceSize.height: root.cardHeight * 2
                            opacity: bg.status === Image.Ready ? 1 : 0

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.OutCubic
                                }

                            }

                        }

                        Image {
                            id: fg

                            anchors.fill: parent
                            source: ""
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                            cache: true
                            sourceSize.width: root.cardWidth * 2
                            sourceSize.height: root.cardHeight * 2
                            opacity: 0

                            NumberAnimation {
                                id: fgFadeAnim

                                target: fg
                                property: "opacity"
                                to: 0
                                duration: 100
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

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }

                    }

                }

            }

        }

    }

}
