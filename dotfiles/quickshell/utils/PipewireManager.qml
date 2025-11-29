pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire
import Quickshell

Singleton {
  id: root
  property PwNode defaultSink
  PwObjectTracker {
    id: sinkTracker
  }

  Component.onCompleted: {
    var node = Pipewire.defaultAudioSink;
    defaultSink = node;
    sinkTracker.objects = [node];
    console.log(typeof Map);
  }

  // When the default sink changes, to something non-null
  // register it, then wait for it to be ready, once ready
  // set it as the new default
  Connections {
    target: Pipewire
    function onDefaultAudioSinkChanged() {
      var node = Pipewire["defaultAudioSink"];
      if (node == null) {
        return;
      }
      // Register node
      sinkTracker.objects.push(node);
      // Logic for setting a node
      // Because the node might be ready the same cycle
      // but properties apparently are not, we need to
      // delay it an entire cycle
      var setSink = () => {
        Qt.callLater(() => {
          root.defaultSink = node;
          sinkTracker.objects = [node];
        });
      };

      var checkReady = () => {
        if (node.ready) {
          setSink();
          node.readyChanged.disconnect(checkReady);
        }
      };
      // Change the our sink when the node is ready
      if (node.ready) {
        setSink();
      } else {
        node.readyChanged.connect(checkReady);
      }
    }
  }
  Item {
    id: tracker

    property var map: new Map()
  }
}
