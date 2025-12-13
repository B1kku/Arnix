import Quickshell
import qs
import QtQuick
import QtQuick.Layouts

Scope {
  // FloatingWindow {
  //   id: board
  //   title: "Drawing Board"
  //   color: "#1d1d20"
  //   Rectangle {
  //     color: "gray"
  //     implicitHeight: 800
  //     implicitWidth: 800
  //
  //     anchors.centerIn: parent
  //     Power {
  //       anchors.centerIn: parent
  //       anchors.fill: parent
  //     }
  //   }
  // }
// PanelWindow {
//   anchors {
//     top: true
//     left: true
//     right: true
//   }
//
//   implicitHeight: 30
//
//   Rectangle {
//     id: test
//     implicitWidth: 20
//     implicitHeight: 20
//     color: "red"
//     anchors.right: parent.right
//     anchors.verticalCenter: parent.verticalCenter
//
//     PopupWindow {
//       anchor.item: test
//       implicitWidth: 100
//       implicitHeight: 100
//       visible: true
//       anchor.edges: Edges.Bottom | Edges.Right
//       anchor.gravity: Edges.Bottom | Edges.Left
//       anchor.adjustment: PopupAdjustment.FlipY
//       color: "blue"
//     }
//   }
// }
  ReloadPopup {}
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
      implicitHeight: 30
      color: Qt.rgba(29 / 255, 29 / 255, 32 / 255, 0.8)

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
          text: Qt.formatDateTime(Clock.date, "ddd d MMM hh:mm")
          font.weight: Font.ExtraBold
          font.pointSize: 10.5
          Layout.alignment: Qt.AlignHCenter
        }
        Item {
          Layout.fillWidth: true
        }
        VolumeSink {
          Layout.preferredHeight: bar_root.implicitHeight - 10
          Layout.preferredWidth: bar_root.implicitHeight + 10 - 6
        }
        MicSink {
          Layout.preferredHeight: bar_root.implicitHeight - 10
          Layout.preferredWidth: bar_root.implicitHeight + 10 - 6
        }
        Power {
          Layout.preferredHeight: bar_root.implicitHeight - 6
          Layout.preferredWidth: bar_root.implicitHeight - 6
          // radius: 8
        }
      }
    }
  }
  ReloadPopup {}
}
