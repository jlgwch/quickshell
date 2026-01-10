pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {
    id: root

    // readonly property list<MprisPlayer> playerList: Mpris.players.values
    // // readonly property MprisPlayer currentPlayer: playerList.find(player => player.playbackState === MprisPlaybackState.Playing)
    // readonly property MprisPlayer activePlayer: playerList.find(p => p.isPlaying) ?? playerList.find(p => p.canControl && p.canPlay) ?? null

    readonly property list<MprisPlayer> availablePlayers: Mpris.players.values

    property MprisPlayer activePlayer: availablePlayers.find(p => p.isPlaying) ?? availablePlayers.find(p => p.canControl && p.canPlay) ?? null

    readonly property real length: activePlayer ? activePlayer.length : 0

    onLengthChanged: {}

    onActivePlayerChanged: {}

    // Timer {
    // interval: 100
    // repeat: true
    // onTriggered: {
    // console.log("-------------+++++++++++++", activePlayer.length);
    // }
    // running: true
    // }
}
