import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Pipewire
import qs.utils
import QtQml.Models

Item {
  id: root
  property var node: PipewireManager.defaultOutput
  property real volume_percent: {
    if (node?.audio?.volume) {
      return Math.round(node.audio.volume * 100);
    } else {
      return 0;
    }
  }

  MouseArea {
    anchors.fill: root
    onWheel: wheel => {
      if (root.node == null) {
        return;
      }
      var audio = root.node.audio;
      //UP
      if (wheel.angleDelta.y > 0) {
        if (audio.volume >= 1 - 0.1) {
          audio.volume = 1;
          return;
        }
        audio.volume = audio.volume + 0.1;
      } else {
        audio.volume = audio.volume - 0.1;
      }
    }
    onClicked: {
      popup.visible = !popup.visible;
    }
  }
  Rectangle {
    id: bg
    anchors.centerIn: parent
    anchors.fill: root
    color: "#1c1c1c"
    visible: false
    Rectangle {
      id: fg
      height: bg.height
      width: bg.width
      x: -fg.width + (fg.width * (root.volume_percent / 100))
      color: "purple"
    }
    Text {
      text: root.volume_percent
      anchors.centerIn: bg
      color: "lightblue"
      font.weight: Font.ExtraBold
    }
  }

  Rectangle {
    id: mask
    anchors.fill: root
    anchors.centerIn: parent
    visible: false
    layer.enabled: true
    // layer.smooth: true
    radius: Math.min(width, height) * (75 / 100) / 2
    color: "white"
  }

  MultiEffect {
    anchors.centerIn: parent
    source: bg
    anchors.fill: root
    maskEnabled: true
    maskSource: mask

    maskThresholdMin: 0.5   // Lower alpha bound for masking
    maskThresholdMax: 1.0   // Upper alpha bound for masking
    maskSpreadAtMin: 1.0   // Smoothness near min threshold
    maskSpreadAtMax: 10.0    // Smoothness near max threshold
    antialiasing: true
  }

  PopupWindow {
    id: popup
    anchor.item: root
    anchor.edges: Edges.Bottom | Edges.Right
    // anchor.margins.left: bg.width
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.adjustment: PopupAdjustment.None
    // anchor.rect.y: 5
    // anchor.rect.height: 500
    anchor.margins.top: (parentWindow.height - bg.height) / 2
    implicitWidth: rectPop.width
    implicitHeight: rectPop.height
    color: "transparent"
    visible: false
    Rectangle {
      id: rectPop
      width: col.implicitWidth + 20
      height: col.implicitHeight + 40
      radius: 20
      color: "#1c1c1c"
      ColumnLayout {
        id: col
        spacing: 10
        anchors.topMargin: 20
        anchors.fill: rectPop
        anchors.bottomMargin: 20
        Repeater {
          model: ScriptModel {
            values: Pipewire.nodes.values.filter(node => node.type == 17).sort((nodea, nodeb) => {
              if (nodea.id == Pipewire.defaultAudioSink.id) {
                return 1
              }
              if (nodea.id > nodeb.id) {
                return -1
              } else {
                return 0
              }
            })
          }
          delegate: Rectangle {
            id: rect
            color: "transparent"
            // color: "green"
            required property PwNode modelData
            // anchors.fill: parent
            Layout.fillWidth: true
            Layout.preferredHeight: text.height + 5
            Layout.preferredWidth: text.width
            Text {
              id: text
              color: rect.modelData.id == Pipewire.defaultAudioSink.id ? "gray" : "gray"
              font.pointSize: 10.5
              anchors.centerIn: rect
              text: rect.modelData.nickname + " " + rect.modelData.id
            }
            MouseArea {
              anchors.fill: rect
              onClicked: {
                Pipewire.preferredDefaultAudioSink = rect.modelData;
              }
            }
          }
        }
      }
    }
  }
}
