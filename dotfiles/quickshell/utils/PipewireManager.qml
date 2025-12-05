pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire
import Quickshell

Singleton {
  id: root
  property PwNode defaultOutput: output.node
  property PwNode defaultInput: input.node

  PwStableTracker {
    id: output
    trackedNode: Pipewire.defaultAudioSink
  }
  PwStableTracker {
    id: input
    trackedNode: Pipewire.defaultAudioSource
  }

  // The whole idea of this is to solve the issue where if the default sink
  // is changed it might be null, undefined, not ready or wtv for
  // a while, setting our effective volume (and other properties) to
  // undefined, then popping back as the value which is quite ugly.
  //
  // This essentially tracks a property and exposes a node, the node will
  // remain unchanged until the new property is valid and ready, which is
  // not to say it will never be null (such as when no device available)
  // or readying Pipewire
  component PwStableTracker: Item {
    readonly property var node: _node
    required property var trackedNode 
    property var _node: null
    // Things to note about this tracker, a shared/global tracker
    // is a NIGHTMARE, objects can be removed from your list without a sign,
    // duplicates can pile up, so it's best to keep it simple, track only my
    // object when I say so at most keep the old one while the new is not ready.
    PwObjectTracker {
      id: tracker
    }

    Component.onCompleted: {
      _node = trackedNode;
      tracker.objects = [trackedNode];
    }
    // Pair of:
    // - NodeObject
    // - Function
    // Waiting for a ready signal to be fired
    // this is so we can cancel them waiting
    // if a new device is set while the previous
    // is not ready yet (extremely unlikely).
    property var readyCheckers: []

    function nodeSetter(newNode) {
      return () => {
        Qt.callLater(() => {
          _node = newNode;
          // Clear old objects from being tracked
          tracker.objects = [newNode];
        });
      };
    }
    function attachOnReady(newNode, cb) {
      var checkReady = () => {
        if (newNode.ready) {
          cb();
          readyCheckers = [];
          newNode.readyChanged.disconnect(checkReady);
        }
      };
      readyCheckers = [newNode, checkReady];
      newNode.readyChanged.connect(checkReady);
    }

    onTrackedNodeChanged: {
      var newNode = trackedNode;
      if (newNode == null) {
        return;
      }
      // In case someone was already waiting for a ready, disconnect it
      if (readyCheckers.length >= 1) {
        let object = readyCheckers[0];
        let checker = readyCheckers[1];
        object.readyChanged.disconnect(checker);
        readyCheckers = [];
      }
      // It's a proper sink, tell qs to start readying it
      tracker.objects.push(newNode);

      var setNode = nodeSetter(newNode);

      // If it's already ready (probably won't happen), set it as the new sink
      // otherwise, wait for a ready signal, and once it is, attach as the new node
      if (newNode.ready) {
        setNode();
      } else {
        attachOnReady(newNode, setNode);
      }
    }
  }
}
