import QtQuick
import QtQuick.Controls.Material
import QtQuick.Shapes

Item {
    id: clockItem
    required property QtObject cppObj
    property color clockColor: Material.primary
    property int radius: 250

    width: radius * 2 + shapePath.strokeWidth
    height: radius * 2 + shapePath.strokeWidth

    // Anti-aliasing
    layer.enabled: true
    layer.samples: 4

    // "Private"
    property real percentLeft: (clockItem.cppObj.timeLeftSeconds / clockItem.cppObj.intervalSeconds)

    // Countdown circle
    Shape {
        visible: percentLeft > 0
        anchors {
            fill: parent
            margins: shapePath.strokeWidth / 2
        }
        ShapePath {
            id: shapePath
            strokeColor: "blue"
            strokeWidth: clockItem.radius * 0.1
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            startX: clockItem.radius
            startY: 0
            PathArc {
                property real rads: 2*Math.PI*(1.0 - clockItem.percentLeft) + Math.PI/2;
                x: (Math.cos(rads)+1) * clockItem.radius;
                y: (1-Math.sin(rads)) * clockItem.radius;
                radiusX: clockItem.radius
                radiusY: clockItem.radius
                direction: PathArc.Clockwise
                useLargeArc: clockItem.percentLeft % 1 >= 0.5
            }
        }
    }
    Rectangle {
        id: circleFull
        visible: clockItem.percentLeft >= 1
        anchors.fill: parent
        radius: width + 100 // Makes this rectangle a circle
        border {
            width: shapePath.strokeWidth
            color: "blue"
        }
        color: "transparent"
    }
    Rectangle {
        id: circleEmpty
        visible: clockItem.percentLeft <= 0
        anchors.fill: parent
        radius: width + 100 // Makes this rectangle a circle
        border {
            width: shapePath.strokeWidth
            color: "red"
        }
        color: "transparent"
    }


    // Clock title
    Text {
        id: clockTitle
        text: clockItem.cppObj.name
        anchors.centerIn: parent
        font.pixelSize: 20
    }

    // Time left
    Text {
        text: clockItem.cppObj.timeLeftSeconds + " seconds"
        anchors.top: clockTitle.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 10
    }
}
