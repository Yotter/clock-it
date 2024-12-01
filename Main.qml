import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Window 2.15

pragma ComponentBehavior: Bound

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("ClockIt")
    Material.theme: Material.Dark
    ScrollView {
        anchors.fill: parent
        Grid {
            id: clockGrid
            anchors.fill: parent
            columns: 2
            Repeater {
                model: 1
                Clock {
                    cppObj: clock1
                    radius: 100
                }
            }
        }
    }
}
