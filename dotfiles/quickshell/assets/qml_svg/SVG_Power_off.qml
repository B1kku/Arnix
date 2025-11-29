// Generated from SVG file ./svg/power_off.svg
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
        Scale { xScale: width / 24; yScale: height / 24 }
    ]
    objectName: "svg1"
    id: _qt_node0
    Shape {
        objectName: "path1"
        id: _qt_node1
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            id: _qt_shapePath_0
            objectName: "svg_stroke_path:path1"
            strokeColor: "#ff000000"
            strokeWidth: 2
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            miterLimit: 4
            fillColor: "transparent"
            fillRule: ShapePath.WindingFill
            pathHints: ShapePath.PathQuadratic
            PathSvg { path: "M 12 3 L 12 12 M 18.3611 5.64001 Q 20.2912 7.5707 20.8234 10.2482 Q 21.3556 12.9258 20.3107 15.4478 Q 19.2659 17.9698 16.9959 19.4864 Q 14.7261 21.0029 11.9961 21.0029 Q 9.26608 21.0029 6.99627 19.4864 Q 4.72643 17.9699 3.68146 15.4478 Q 2.63658 12.9257 3.16882 10.2482 Q 3.70106 7.57068 5.6311 5.64001 " }
        }
    }
    Shape {
        objectName: "path2"
        id: _qt_node2
        transform: TransformGroup {
            id: _qt_node2_transform_base_group
            Matrix4x4 { matrix: PlanarTransform.fromAffineMatrix(0.03, 0, 0, 0.03, 0, 0)}
        }
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            id: _qt_shapePath_1
            objectName: "svg_path:path2"
            strokeColor: "transparent"
            fillColor: "#ffffffff"
            fillRule: ShapePath.WindingFill
            pathHints: ShapePath.PathQuadratic | ShapePath.PathNonIntersecting | ShapePath.PathNonOverlappingControlPointTriangles
            PathSvg { path: "M 387.324 732.706 Q 280.158 728.037 193.897 661.402 Q 164.224 638.481 139.99 607.981 Q 81.7056 534.625 69.4255 440.183 Q 65.2459 408.039 67.9982 375.117 Q 77.2396 264.58 148.934 181.69 Q 162.76 165.706 170.353 160.579 Q 177.946 155.452 187.793 155.452 Q 192.397 155.452 194.883 155.93 Q 197.368 156.409 200.634 157.924 Q 211.705 163.059 216.962 173.433 Q 218.817 177.095 219.268 179.442 Q 219.718 181.789 219.718 187.793 Q 219.718 196.902 217.117 202.115 Q 214.516 207.327 204.723 217.84 Q 177.247 247.337 159.548 284.038 Q 134.756 335.446 133.181 393.427 Q 130.47 493.256 193.708 569.949 Q 256.947 646.642 355.775 663.381 Q 442.817 678.123 521.059 638.066 Q 557.961 619.173 588.292 588.789 Q 618.235 558.792 636.017 524.874 Q 676.083 448.451 664.4 363.593 Q 652.716 278.735 593.501 216.07 Q 586.675 208.847 584.214 205.059 Q 581.753 201.271 580.279 195.721 Q 577.318 184.57 582.653 173.871 Q 587.988 163.172 599.061 158.055 Q 602.548 156.444 605.056 155.943 Q 607.565 155.442 612.226 155.426 Q 622.45 155.39 630.329 161.059 Q 638.207 166.729 654.201 185.633 Q 717.416 260.348 729.888 357.855 Q 742.359 455.362 699.966 543.429 Q 614.275 721.437 416.901 732.362 Q 400 733.297 396.714 733.134 L 392.6 732.941 L 387.324 732.706 " }
        }
    }
    Shape {
        objectName: "path3"
        id: _qt_node3
        transform: TransformGroup {
            id: _qt_node3_transform_base_group
            Matrix4x4 { matrix: PlanarTransform.fromAffineMatrix(0.03, 0, 0, 0.03, 0, 0)}
        }
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            id: _qt_shapePath_2
            objectName: "svg_path:path3"
            strokeColor: "transparent"
            fillColor: "#ffffffff"
            fillRule: ShapePath.WindingFill
            pathHints: ShapePath.PathQuadratic | ShapePath.PathNonIntersecting | ShapePath.PathNonOverlappingControlPointTriangles
            PathSvg { path: "M 392.378 432.033 Q 385.084 430.143 378.651 424.415 Q 372.218 418.687 369.315 411.499 L 367.136 406.103 L 367.136 250.235 Q 367.136 94.3661 368.924 89.6714 Q 377.401 67.4172 400.205 67.4965 Q 416.746 67.5541 426.315 80.594 Q 426.825 81.2896 427.731 82.3899 Q 432.9 88.6725 432.869 215.497 L 432.864 250.235 L 432.864 406.103 L 430.685 411.499 Q 428.515 416.874 423.709 422.065 Q 418.904 427.257 413.915 429.617 Q 409.696 431.613 403.088 432.354 Q 396.48 433.095 392.378 432.033 " }
        }
    }
}
