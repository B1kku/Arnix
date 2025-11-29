import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
  Shape {
    id: circleShape
    width: 20
    height: 20
    anchors.centerIn: parent

    ShapePath {
      strokeColor: "white"
      strokeWidth: 4
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap

      PathAngleArc {
        // center of the circle relative to the Shape
        centerX: circleShape.width / 2
        centerY: circleShape.height / 2

        // radius
        radiusX: 8
        radiusY: 8

        // full circumference
        startAngle: 0
        sweepAngle: 360
      }
    }
  }
}
