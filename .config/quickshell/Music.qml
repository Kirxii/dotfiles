import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import "./components"

MouseArea {
    id: musicBarWrapper
	
	// type Array<QObjectList | null>
	readonly property var players: Mpris.players.values

    readonly property var activePlayer: { // type QObjectList | null
		const webPlayers = ["chromium", "firefox", "brave"]
		return players.find(player => !webPlayers.includes(player.name)) || null;
	}

	property bool pausedTimeoutReached: false
	Timer {
		id: pauseTimer
		interval: 5 * 60 * 1000 // 5 minutes in milliseconds
		repeat: false
		onTriggered: { // Handler for when the timer finishes
			musicBarWrapper.pausedTimeoutReached = true
			// TODO: Put in the handle to close the music widget window
			// if it was still opened
		}
	}

	property int playbackState: activePlayer
		? activePlayer.playbackState
		: MprisPlaybackState.Stopped
	onPlaybackStateChanged: {
		const { Paused, Playing } = MprisPlaybackState

		// TODO: Refactor to switch case
		if (playbackState === Playing) {
			// Reset state immediately if music starts playing again
			pausedTimeoutReached = false;
			pauseTimer.stop();
		}
		else if (playbackState === Paused) {
			// Starts the 5-minute timer when music is paused
			pauseTimer.start();
		}
		else {
			// If music is stopped completely, hide immediately
			pausedTimeoutReached = true;
			pauseTimer.stop();
		}
	}
	
	visible: activePlayer !== null && !pausedTimeoutReached
	
    implicitHeight: parent ? parent.height : 40
	implicitWidth: visible ? 200 : 0

	onClicked: {
		// TODO: Open the music widget window
	}

	RowLayout {
		id: row
		anchors.centerIn: parent

		property var player: musicBarWrapper.activePlayer

		component MusicText : Text {
			color: "white"
			font.family: "Iosevka Custom"
			font.weight: Font.ExtraBold
		}

        RoundedImage {
            source: row.player?.trackArtUrl
            width: 22
            height: 22
            radius: width / 2
        }

		ColumnLayout {
			id: column
            spacing: -3

            MusicText {
                text: row.player?.trackTitle ?? ""
                font.pixelSize: 11
            }

            MusicText {
                text: row.player?.trackArtist ?? ""
                font.pixelSize: 9
                color: "gray"
			}
        }
    }
}
