pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects

Image {
  id: nonGif
  sourceSize: Qt.size(nonGif.width, nonGif.height)
  property color color: "red"
  Component {
    id: multiEffectComponent
    MultiEffect {
      brightness: 1.0
      colorization: 1.0
      colorizationColor: nonGif.color
    }
  }
  layer.enabled: true
  layer.effect: multiEffectComponent
  function updateEffect() {
    console.log("asd")
    if (layer.effect) {
      layer.effect.destroy();
    }
    var eff = multiEffectComponent.createObject(nonGif);
    layer.effect = eff;
  }

  onColorChanged: updateEffect
  Component.onCompleted: updateEffect
}
