import QtQuick
import QtQuick.Controls.Material
import QtQuick.Shapes

Item {
    id: clock
    // required property real clockId
    property color clockColor: Material.primary
    property int radius: 250

    // Should be over-written for desired size of clock
    width: radius * 2
    height: radius * 2

    // Anti-aliasing
    layer.enabled: true
    layer.samples: 4

    // Countdown circle
    Shape {
        anchors.fill: parent
        ShapePath {
            id: shapePath
            strokeColor: "blue"
            strokeWidth: clock.radius * 0.1
            fillColor: "transparent"

            startX: clock.radius
            startY: shapePath.strokeWidth / 2

            PathArc {
                x: shapePath.strokeWidth / 2
                y: clock.radius
                radiusX: clock.radius - shapePath.strokeWidth / 2
                radiusY: clock.radius - shapePath.strokeWidth / 2
                useLargeArc: true
            }
        }
    }

    // Clock title
    Text {
        id: clockTitle
        text: "Do the dishes"
        anchors.centerIn: parent
        font.pixelSize: 20
    }

    // Time left
    Text {
        text: "2 days"
        anchors.top: clockTitle.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 10
    }
}
