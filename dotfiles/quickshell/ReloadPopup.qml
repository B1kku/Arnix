import QtQuick
import QtQuick.Layouts
import Quickshell

Scope {
  id: root
  property bool failed
  property string errorString
  onFailedChanged: {
    notif.visible = true;
    anim.start();
  }
  // Connect to the Quickshell global to listen for the reload signals.
  Connections {
    target: Quickshell

    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup();
      root.failed = false;
    }

    function onReloadFailed(error: string) {
      Quickshell.inhibitReloadPopup();
      root.failed = true;
      root.errorString = error;
    }
  }
  PanelWindow {
    id: notif
    visible: false
    anchors {
      right: true
      top: true
    }
    margins {
      top: 25
      right: 25
    }
    color: root.failed ? "red" : "black"
    Text {
      text: root.errorString
    }
    Rectangle {
      id: bar
      color: "white"
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      height: 5

      PropertyAnimation {
        id: anim
        target: bar
        property: "width"
        from: 100
        to: 0
        duration: root.failed ? 2000 : 10000
      }
    }
  }
}
