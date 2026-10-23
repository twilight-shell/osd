import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Twilight.Core
import "parts"

// Volume pop-up near the bottom of the screen, shown for a moment whenever the
// volume or mute state changes.
PanelWindow {
    id: window

    // Name of the output to show on; the first screen when empty or unknown.
    // The compositor is the host's business, so the host sets it.
    property string outputName: ""

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0

    // 0 = hidden below, 1 = shown.
    property real show: 0
    // Pipewire reports the initial state right after startup; don't pop up for it.
    property bool ready: false

    screen: Quickshell.screens.find(s => s.name === window.outputName) ?? Quickshell.screens[0]
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: 360
    // Reaches down to the screen edge so the pill rises from behind it.
    implicitHeight: 180
    // Purely visual: never takes input.
    mask: Region {}

    WlrLayershell.namespace: "twilight-osd"
    WlrLayershell.layer: WlrLayer.Overlay

    anchors.bottom: true

    function poke() {
        if (!ready)
            return;
        hideTimer.restart();
        if (show < 1 && !showAnim.running)
            showAnim.restart();
        bump.restart();
    }

    onVolumeChanged: poke()
    onMutedChanged: poke()

    PwObjectTracker {
        objects: [window.sink]
    }

    Timer {
        interval: 1500
        running: true
        onTriggered: window.ready = true
    }

    Timer {
        id: hideTimer

        interval: 1400
        onTriggered: {
            showAnim.stop();
            hideAnim.restart();
        }
    }

    NumberAnimation {
        id: showAnim

        target: window
        property: "show"
        to: 1
        duration: 520
        easing.type: Easing.OutBack
        easing.overshoot: 1.8
    }

    NumberAnimation {
        id: hideAnim

        target: window
        property: "show"
        to: 0
        duration: 300
        easing.type: Easing.InBack
        easing.overshoot: 1.5
    }

    Item {
        id: pill

        width: 300
        height: 60
        x: (parent.width - width) / 2
        // Resting 60px above the screen edge, hidden just below it.
        y: window.height - height - 60 + (1 - window.show) * (height + 70)

        NumberAnimation {
            id: bump

            target: pill
            property: "scale"
            from: 1.06
            to: 1
            duration: 260
            easing.type: Easing.OutBack
            easing.overshoot: 3
        }

        Sticker {
            anchors.fill: parent
            radius: 30
            lift: 6
            fill: Theme.surface
        }

        Row {
            anchors.centerIn: parent
            spacing: 14

            Sticker {
                anchors.verticalCenter: parent.verticalCenter
                width: 38
                height: 38
                radius: 19
                lift: 3
                fill: window.muted ? Theme.surfaceHigh : Theme.accent

                Text {
                    anchors.centerIn: parent
                    // nf-md-volume_off / volume_low / volume_medium / volume_high
                    text: String.fromCodePoint(window.muted ? 0xf0581
                        : window.volume < 0.34 ? 0xf057f
                        : window.volume < 0.67 ? 0xf0580
                        : 0xf057e)
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: 18
                    style: Text.Outline
                    styleColor: Theme.ink
                }
            }

            Meter {
                anchors.verticalCenter: parent.verticalCenter
                volume: window.volume
                muted: window.muted
                active: window.show > 0
            }

            RollText {
                anchors.verticalCenter: parent.verticalCenter
                width: 34
                text: window.muted ? "off" : Math.round(window.volume * 100)
                color: window.muted ? Theme.muted : Theme.text
                pixelSize: 15
                bold: true
                duration: 260
            }
        }
    }
}
