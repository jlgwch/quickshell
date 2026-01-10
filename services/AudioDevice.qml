pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

import "../utils"

Singleton {
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property real sinkLevel: sink.audio.volume
    readonly property real sourceLevel: source.audio.volume
    readonly property bool sinkMute: !sink.audio?.muted

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

    function setSinkLevel(value: real) {
        sink.audio.volume = value;
    }

    function setSourceLevel(value: real) {
        source.audio.volume = value;
    }
}
