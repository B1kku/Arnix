pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire
import Quickshell

Singleton {
  id: root
  property PwNode defaultSink
  property alias tracker: tracker
  Component.onCompleted: {
    var node = Pipewire.defaultAudioSink;
    defaultSink = node;
    tracker.track(node);
  }

  // When the default sink changes, to something non-null
  // register it, then wait for it to be ready, once ready
  // set it as the new default
  Connections {
    target: Pipewire
    function onDefaultAudioSinkChanged() {
      var node = Pipewire["defaultAudioSink"];
      console.log("New node: " + node);
      console.log("Old node: " + root.defaultSink);
      console.log(node);
      if (node == null) {
        return;
      }
      var oldNode = root.defaultSink;
      // Register node
      tracker.track(node);
      // Logic for setting a node
      // Because the node might be ready the same cycle
      // but properties apparently are not, we need to
      // delay it an entire cycle
      var setSink = () => {
        Qt.callLater(() => {
          console.log(node.ready);
          root.defaultSink = node;
          tracker.untrack(oldNode);
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
    function delayBy(delayTime, callback) {
      var timer = Qt.createQmlObject('import QtQuick 2.0; Timer {}', root);
      timer.interval = delayTime;
      timer.repeat = false;
      timer.triggered.connect(function () {
        callback();
        timer.destroy();
      });
      timer.start();
    }
  }
  Item {
    id: tracker
    PwObjectTracker {
      id: nodeTracker
    }
    property var map: new Map()

    function track(node) {
      // console.log("Map, track, " + node);
      // console.log("Objects: ");
      // console.log(nodeTracker.objects);

      var value = map.get(node);
      if (value == null) {
        // Actually insert into the nodeTracker?
        // console.log("Adding " + node);
        map.set(node, 1);
        nodeTracker.objects.push(node);
      } else {
        map.set(node, value + 1);
      }
    // console.log("Map, track, " + node + " current: " + value + 1);
    // console.log("Objects: ");
    // console.log(nodeTracker.objects);
    }

    function untrack(node) {
      // console.log("Map, untrack, " + node);
      // console.log("Objects: ");
      // console.log(nodeTracker.objects);

      var value = map.get(node);
      if (value == null)
      // throw new Error("IPwObjectTracker tried untracking an untracked node: " + node);
      {}
      value = value - 1;
      if (value == 0) {
        // console.log("Kicking " + node);
        map.delete(node);
        clearTracker(node);
      } else if (value < 0)
      // throw new Error("IpwObjectTracker the following node was untracked more than possible: " + node);
      {} else {
        map.set(node, value);
      }
    // console.log("Map, untrack, " + node + " current: " + value);
    // console.log("Objects: ");
    // console.log(nodeTracker.objects);
    }
    // You'd wish this didn't cause issues :)
    // But this re-registers the fucking thing when it's changed, therefore
    // we get fucked as it goes back to being null
    function clearTracker(node) {
      filterInPlace(nodeTracker.objects, (eNode => {
          if (eNode == null) {
            return false;
          }
          if (eNode === node) {
            return false;
          }
          return true;
        }));
    }

    function filterInPlace(a, condition) {
      let i = 0, j = 0;

      while (i < a.length) {
        const val = a[i];
        if (condition(val, i, a))
          a[j++] = val;
        i++;
      }

      a.length = j;
      return a;
    }

    // Run code at interval idk wtf is happening here
  }
}
