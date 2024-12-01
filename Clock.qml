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


    Column {
        id: textElements
        anchors.centerIn: parent

        // Clock title
        Text {
            id: clockTitle
            anchors.horizontalCenter: parent.horizontalCenter
            text: clockItem.cppObj.name
            font.pixelSize: clockItem.radius * 0.4
        }

        // Time left
        Text {
            id: timeLeft
            anchors.horizontalCenter: parent.horizontalCenter
            text: formatTime(clockItem.cppObj.timeLeftSeconds)
            font.pixelSize: clockItem.radius * 0.2
        }
    }


    // Convert a number of seconds into a string like "5 months", "1 year", "17 seconds", etc.
    function formatTime(seconds) {
        function helpMe(number, word) {
            let rounded = Math.floor(number).toString();
            return rounded + " " + word + (rounded > 1 ? "s" : "");
        }

        let minutes = seconds / 60;
        let hours = minutes / 60;
        let days = hours / 24;
        let weeks = days / 7;
        let months = days / 30;
        let years = days / 365;

        if (years > 1) {
            return helpMe(years, "year");
        }
        if (months > 1) {
            return helpMe(months, "month");
        }
        if (days > 1) {
            return helpMe(days, "day");
        }
        if (hours > 1) {
            return helpMe(hours, "hour");
        }
        if (minutes > 1) {
            return helpMe(minutes, "minute");
        }
        return helpMe(seconds, "second");
    }
}
