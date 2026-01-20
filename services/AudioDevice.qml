pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

import "../utils"

Singleton {
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property real sinkLevel: sink.audio.volume
    readonly property real sourceLevel: source.audio.volume
    readonly property bool sinkMute: sink.audio?.muted
    readonly property bool sourceMute: source.audio?.muted

    PwObjectTracker {
        objects: Pipewire.nodes.values.filter(node => node.audio && !node.isStream)
    }

    readonly property var sinkIcon: {
        if (sink.audio?.muted)
            return FluentIcons.Mute;
        else if (sink.audio.volume >= 0.66)
            return FluentIcons.Volume3;
        else if (sink.audio.volume >= 0.33)
            return FluentIcons.Volume2;
        else if (sink.audio.volume > 0)
            return FluentIcons.Volume1;
        else
            return FluentIcons.Volume0;
    }

    readonly property var sourceIcon: FluentIcons.Microphone

    function setSinkMute() {
        sink.audio.muted = !sink.audio.muted
    }

    function setSinkLevel(value: real) {
        sink.audio.volume = value
        if(value > 0) {
            sink.audio.muted = false
        } else {
            sink.audio.muted = true
        }
    }

    function setSourceMute() {
        source.audio.muted = !source.audio.muted
    }

    function setSourceLevel(value: real) {
        source.audio.volume = value
        if(value > 0) {
            source.audio.muted = false
        } else {
            source.audio.muted = true
        }
    }
}
