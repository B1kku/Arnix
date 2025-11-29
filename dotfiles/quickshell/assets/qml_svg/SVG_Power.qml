// Generated from SVG file ./svg/power.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes

Item {
    implicitWidth: 800
    implicitHeight: 800
    component AnimationsInfo : QtObject
    {
        property bool paused: false
        property int loops: 1
        signal restart()
    }
    property AnimationsInfo animations : AnimationsInfo {}
    transform: [
        Scale { xScale: width / 16; yScale: height / 16 }
    ]
    objectName: "svg2"
    id: _qt_node0
    Shape {
        objectName: "path1"
        id: _qt_node1
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            id: _qt_shapePath_0
            objectName: "svg_path:path1"
            strokeColor: "transparent"
            fillColor: "#ff000000"
            fillRule: ShapePath.WindingFill
            pathHints: ShapePath.PathQuadratic | ShapePath.PathNonIntersecting | ShapePath.PathNonOverlappingControlPointTriangles
            PathSvg { path: "M 6.49999 0 L 6.49999 8 L 9.49999 8 L 9.49999 0 L 6.49999 0 " }
        }
    }
    Shape {
        objectName: "path2"
        id: _qt_node2
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            id: _qt_shapePath_1
            objectName: "svg_path:path2"
            strokeColor: "transparent"
            fillColor: "#ff000000"
            fillRule: ShapePath.WindingFill
            pathHints: ShapePath.PathQuadratic | ShapePath.PathNonIntersecting | ShapePath.PathNonOverlappingControlPointTriangles
            PathSvg { path: "M 4.46447 11.5355 Q 3 10.0711 3 8 Q 3 5.92894 4.46447 4.46447 L 2.34315 2.34315 Q 7.5e-07 4.68629 7.5e-07 8.00002 Q 7.5e-07 11.3138 2.34315 13.6569 Q 4.68629 16 8.00002 16 Q 11.3138 16 13.6569 13.6569 Q 16 11.3138 16 8.00002 Q 16 4.68629 13.6569 2.34315 L 11.5355 4.46447 Q 13 5.92894 13 8 Q 13 10.0711 11.5355 11.5355 Q 10.0711 13 8 13 Q 5.92894 13 4.46447 11.5355 " }
        }
    }
    Shape {
        objectName: "path3"
        id: _qt_node3
        transform: TransformGroup {
            id: _qt_node3_transform_base_group
            Matrix4x4 { matrix: PlanarTransform.fromAffineMatrix(0.02, 0, 0, 0.02, 0, 0)}
        }
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            id: _qt_shapePath_2
            objectName: "svg_path:path3"
            strokeColor: "transparent"
            fillColor: "#ffffffff"
            fillRule: ShapePath.WindingFill
            pathHints: ShapePath.PathQuadratic | ShapePath.PathNonIntersecting | ShapePath.PathNonOverlappingControlPointTriangles
            PathSvg { path: "M 382.16 799.006 Q 314.851 796.213 251.643 770.953 Q 70.8478 698.7 16.8772 512.964 Q 7.16935 479.555 2.6583 442.254 Q 1.12606 429.583 0.961831 401.743 Q 0.797605 373.903 2.18195 361.502 Q 17.3931 225.242 109.36 126.036 L 116.93 117.871 L 169.652 170.593 L 222.375 223.316 L 215.079 231.142 Q 169.816 279.686 155.502 345.756 Q 146.501 387.298 151.121 427.23 Q 161.007 512.676 219.105 572.951 Q 250.385 605.403 289.122 624.376 Q 312.675 635.911 335.062 641.789 Q 400 658.841 464.938 641.789 Q 487.325 635.911 510.892 624.368 Q 587.045 587.071 624.616 510.521 Q 662.187 433.971 645.438 350.235 Q 631.66 281.35 584.912 231.143 L 577.627 223.318 L 630.125 170.814 L 667.345 133.733 L 683.111 118.31 Q 683.757 118.31 695.156 131.027 Q 706.555 143.744 711.824 150.344 Q 776.867 231.808 793.806 332.864 Q 798.998 363.833 798.998 400 Q 798.998 436.282 793.854 466.788 Q 781.266 541.446 741.734 606.827 Q 665.249 733.321 524.96 779.5 Q 472.821 796.663 423.697 798.608 L 412.988 799.039 L 404.695 799.384 Q 401.984 799.502 395.364 799.391 L 382.16 799.006 " }
        }
    }
    Shape {
        objectName: "path4"
        id: _qt_node4
        transform: TransformGroup {
            id: _qt_node4_transform_base_group
            Matrix4x4 { matrix: PlanarTransform.fromAffineMatrix(0.02, 0, 0, 0.02, 0, 0)}
        }
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            id: _qt_shapePath_3
            objectName: "svg_path:path4"
            strokeColor: "transparent"
            fillColor: "#ffffffff"
            fillRule: ShapePath.WindingFill
            pathHints: ShapePath.PathQuadratic | ShapePath.PathNonIntersecting | ShapePath.PathNonOverlappingControlPointTriangles
            PathSvg { path: "M 325.352 200 L 325.352 0 L 400 0 L 474.648 0 L 474.648 200 L 474.648 400 L 400 400 L 325.352 400 L 325.352 200 " }
        }
    }
}
