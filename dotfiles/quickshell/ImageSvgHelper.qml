import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

Image {
  id: root

  sourceSize: Qt.size(root.width, root.height)
  fillMode: Image.PreserveAspectFit
  mipmap: true
  smooth: true
  ColorOverlay {
    anchors.fill: root
    source: root
    color: "red"
    antialiasing: true
    smooth: true
  }
}
