import QtQuick
import QtQuick.Effects
import qs.utils

Item {
  id: root
  property var node: PipewireManager.defaultSink
  property real volume_percent: {
    if (node?.audio?.volume) {
      return Math.round(node.audio.volume * 100);
    } else {
      return 0;
    }
  }

  Timer {
    id: delayTimer
    interval: 1000
    repeat: true
    // running: true
    onTriggered: {
      console.log("Timer");
      console.log(root.node?.audio?.volume);
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
}
