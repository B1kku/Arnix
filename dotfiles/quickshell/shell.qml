import Quickshell
import qs
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {

  Variants {
    model: Quickshell.screens
    PanelWindow {
      id: bar_root
      required property var modelData
      screen: modelData
      focusable: true
      anchors {
        top: true
        left: true
        right: true
      }
      implicitHeight: 25
      color: Qt.hsla(0, 0, 0.5, 0.5)

      RowLayout {
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.fill: parent

        Item {
          Layout.fillWidth: true
        }
        Text {
          // center the bar in its parent component (the window)
          color: "white"
          text: Qt.formatDateTime(Clock.date, "d MMM hh:mm")
        }
        Item {
          Layout.fillWidth: true
        }
        InputSink {
          Layout.preferredHeight: bar_root.implicitHeight - 5
          Layout.preferredWidth: bar_root.implicitHeight - 5
          radius: 8
        }
        Power {
          Layout.preferredHeight: bar_root.implicitHeight - 5
          Layout.preferredWidth: bar_root.implicitHeight - 5
          // radius: 8
        }
      }
    }
  }
  ReloadPopup {}
}
