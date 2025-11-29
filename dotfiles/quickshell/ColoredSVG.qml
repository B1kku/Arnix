import QtQuick
import QtQuick.VectorImage
import QtQuick.Effects

Item {
  id: root
  property alias source: svg.source
  property alias eff: effect
  property alias color: effect.colorizationColor
  VectorImage {
    id: svg
    anchors.fill: root
    source: "assets/svg/power_off.svg"
    preferredRendererType: VectorImage.CurveRenderer
    // visible: false
  }

  MultiEffect {
    id: effect
    anchors.fill: svg
    anchors.centerIn: svg
    source: svg
    colorization: 1
    colorizationColor: "white"
  }

}
