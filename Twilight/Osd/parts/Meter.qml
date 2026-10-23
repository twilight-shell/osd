import QtQuick
import Twilight.Core

// The volume bar with a star riding its tip.
Item {
    id: root

    property real volume: 0
    property bool muted: false
    // Whether the pop-up is drawn, so idle motion stops.
    property bool active: false

    width: 160
    height: 14

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: Theme.bg
        border.color: Theme.ink
        border.width: 2
    }

    Rectangle {
        id: fill

        x: 2
        y: 2
        height: parent.height - 4
        width: Math.max(height, (parent.width - 4) * root.volume)
        radius: height / 2
        visible: root.volume > 0
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0; color: root.muted ? Theme.muted : Theme.secondary }
            GradientStop { position: 1; color: root.muted ? Theme.muted : Theme.star }
        }

        Behavior on width {
            NumberAnimation { duration: 260; easing.type: Easing.OutBack; easing.overshoot: 1.6 }
        }

        // Gloss
        Rectangle {
            x: 3
            y: 1
            width: Math.max(0, parent.width - 6)
            height: 3
            radius: 1.5
            color: Qt.rgba(1, 1, 1, 0.35)
        }
    }

    // Star riding the tip of the meter.
    Text {
        x: fill.x + fill.width - width / 2
        anchors.verticalCenter: parent.verticalCenter
        text: "★"
        color: root.muted ? Theme.muted : Theme.text
        font.pixelSize: 18
        style: Text.Outline
        styleColor: Theme.ink

        RotationAnimation on rotation {
            running: root.active
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: 2400
        }
    }
}
