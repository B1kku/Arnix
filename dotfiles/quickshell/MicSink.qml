import QtQuick
import QtQuick.Effects
import Quickshell.Services.Pipewire
import qs.utils

Item {
  id: root
  property PwNode node: Pipewire.defaultAudioSource
  
  PwNodeLinkTracker {
    id: linkTracker
    node: root.node
  }
  PwObjectTracker {
    id: tracker
    objects: [Pipewire.defaultAudioSource]
  }
  property real volume_percent: {
    if (node?.audio?.volume) {
      return Math.round(node.audio.volume * 100);
    } else {
      return 0;
    }
  }
  property bool muted: node?.audio?.muted ?? false

  // visible: linkTracker.linkGroups.length > 0
  MouseArea {
    anchors.fill: root
    onWheel: wheel => {
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
      y: fg.height - (fg.height * (root.volume_percent / 100))
      color: root.muted ? "red" : "green"
    }
    Text {
      text: root.volume_percent
      anchors.centerIn: bg
      color: root.muted ? "yellow" : "lightblue"
      font.weight: Font.ExtraBold
    }
  }

  Rectangle {
    id: mask
    anchors.fill: root
    anchors.centerIn: parent
    visible: false
    layer.enabled: true
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
}
