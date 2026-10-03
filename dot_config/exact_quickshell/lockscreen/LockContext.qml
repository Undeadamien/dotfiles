import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    signal unlocked()
    signal failed()

    function tryUnlock() {
        if (currentText === "")
            return ;

        root.unlockInProgress = true;
        pam.start();
    }

    onCurrentTextChanged: showFailure = false

    PamContext {
        id: pam

        configDirectory: "pam"
        config: "password.conf"
        onPamMessage: {
            if (this.responseRequired)
                this.respond(root.currentText);

        }
        onCompleted: (result) => {
            if (result == PamResult.Success) {
                root.unlocked();
            } else {
                root.currentText = "";
                root.showFailure = true;
            }
            root.unlockInProgress = false;
        }
    }

}
