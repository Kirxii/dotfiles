pragma ComponentBehavior: Bound

import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import "./components"

Item {
	id: root

	// type Array<QObjectList | null>
	readonly property var players: Mpris.players.values
	
	// type QObjectList | null
	readonly property var activePlayer: {
		// Filtering any web players, comment this if you want to play music from the web
		const webPlayers = ["chromium", "firefox", "brave"]
		return players.find(player => !webPlayers.includes(player.name)
			&& player.playbackState !== MprisPlaybackState.Stopped) || null;
	}

	Timer { // Player pause timer, check if the player hadn't played within a timeframe
		id: pauseTimer
		interval: 5 * 60 * 60 * 1000
		repeat: false
		onTriggered: {
			root.hasPlayerTimedOut = true
			// TODO: Widget popup close callback
		}
	}
	
	property bool hasPlayerTimedOut: false
	readonly property int playbackState: activePlayer
		? activePlayer.playbackState
		: MprisPlaybackState.Stopped
	onPlaybackStateChanged: {
		// All three possible states within the MprisPlaybackState
		const { Playing, Paused, Stopped } = MprisPlaybackState

		switch (playbackState) {
		case Playing:
			root.hasPlayerTimedOut = false;
			pauseTimer.stop();
			break;
		case Paused:
			pauseTimer.start();
			break;
		case Stopped:
			root.hasPlayerTimedOut = true;
			pauseTimer.stop();
			break;
		default:
			// Idk, maybe add some error display
		}
	}
	
	component MusicInfoText : Text {
		color: "#cdd6f4" // Default color if not specified
		font.family: "Iosevka Custom" // TODO: Make this inherit the parent later
		font.pixelSize: 11
		font.weight: Font.ExtraBold
		textFormat: Text.RichText
		height: parent.height
		verticalAlignment: Text.AlignVCenter
	}

	width: 250
	height: parent ? parent.height - 6 : 40
	visible: !hasPlayerTimedOut

	function backgroundColorSwitch(color: color) {
		if (background.color !== color) {
			background.color = color;
			return;
		}
		background.color = "#313244"; // Default color
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		
		onClicked: (mouse) => {
			switch (mouse.button) {
			case Qt.LeftButton:
				root.backgroundColorSwitch("red");
				break;
			case Qt.RightButton:
				root.backgroundColorSwitch("blue");
				break;
			}
		}
	}
	
	Rectangle {
		id: background
		anchors.fill: parent
		color: "transparent"
		radius: 6
	}

	RowLayout {
		id: contentLayout
		anchors.fill: parent
		anchors.margins: 2
		anchors.leftMargin: 8
		anchors.rightMargin: 8
		spacing: 5
		
		RoundedImage {
			id: coverImage
			source: root.activePlayer?.trackArtUrl
			radius: width / 2
			
			Layout.preferredWidth: 22
			Layout.preferredHeight: 22
			Layout.fillHeight: false
			Layout.alignment: Qt.AlignVCenter
		}

		ColumnLayout {
			id: dataLayout
			
			Layout.preferredWidth: 150
			Layout.fillHeight: true

			Item {
				id: marqueeContainer
				clip: true
				
				Layout.alignment: Qt.AlignLeft
				Layout.fillWidth: true
				Layout.fillHeight: true

				property bool isScrolling: false
				property bool shouldScroll: secondaryText.implicitWidth > width
				property string musicInfo: root.activePlayer
					? `<font color="#89b4fa">${root.activePlayer?.trackTitle}</font> • \
						<font color="#a6e3a1">${root.activePlayer?.trackArtist}</font>`
					: ""

				onMusicInfoChanged: {
					isScrolling = false;
					textContent.x = 0;

					Qt.callLater(() => {
						if (marqueeContainer.shouldScroll) {
							isScrolling = true;
						}
					});
				}

				Item {
					id: textContent
					width: primaryText.implicitWidth
					height: parent.height
					x: 0
					
					MusicInfoText {
						id: primaryText
						text: marqueeContainer.musicInfo + (marqueeContainer.shouldScroll ? "&nbsp;".repeat(20) : "")
						anchors.left: parent.left
						anchors.verticalCenter: parent.verticalCenter
					}

					MusicInfoText {
						id: secondaryText
						text: marqueeContainer.musicInfo
						anchors.left: primaryText.right
						anchors.verticalCenter: parent.verticalCenter
						visible: marqueeContainer.shouldScroll
					}

					NumberAnimation{
						id: scrollAnimation
						target: textContent
						property: "x"
						running: marqueeContainer.isScrolling
						loops: Animation.Infinite
						from: 0
						to: -primaryText.implicitWidth

						duration: primaryText.implicitWidth > 0 ? (primaryText.implicitWidth / 50) * 1000 : 0
					}
				}
			}
		}
	}
	
	// component MusicDisplay : Item {
	// 	id: displayRoot
	// 	height: parent.height
	//
	// 	property var player: null
	//
	// 	property string styledSegment: player
	// 		? `<font color="#89b4fa">${player?.trackTitle}</font> • <font color="#a6e3a1">${player?.trackArtist}</font>`
	// 		: ""
	// 	property string fullText: styledSegment !== "" ? `${styledSegment}        ` : ""
	//
	// 	property bool shouldScroll: scrollText1.width > displayRoot.width
	//
	// 	MusicText {
	// 		id: scrollText1
	// 		text: displayRoot.fullText
	// 		// x: displayRoot.shouldScroll ? loopTimeline.currentX : (displayRoot.width - width)
	// 	}
	//
	// 	MusicText {
	// 		id: scrollText2
	// 		text: displayRoot.fullText
	// 		x: scrollText1.x + width
	// 		visible: displayRoot.shouldScroll
	// 	}
	// }
	// property bool shouldShow: activePlayer !== null && !pausedTimeoutReached
	//
	// height: parent ? parent.height : 40
	// 
	// width: shouldShow ? 100 : 0
	// Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.InOutCubic } }
	// 	
	// MouseArea {
	// 	id: musicBarWrapper
	// 	anchors.centerIn: parent
	// 	width: 100
	// 	height: parent.height
	// 	
	// 	enabled: musicBarRoot.shouldShow
	// 	opacity: musicBarRoot.shouldShow ? 1.0 : 0.0
	// 	transform: Scale {
	// 		id: barScale
	// 		origin.x: musicBarWrapper.width / 2
	// 		origin.y: musicBarWrapper.height / 2
	// 		xScale: musicBarRoot.shouldShow ? 1.0 : 0.0
	// 		yScale: musicBarRoot.shouldShow ? 1.0 : 0.0
	// 	}
	//
	// 	Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutCubic } }
	// 	Behavior on transform {
	// 		ParallelAnimation {
	// 			NumberAnimation { property: "xScale"; duration: 250; easing.type: Easing.InOutCubic }
	// 			NumberAnimation { property: "yScale"; duration: 250; easing.type: Easing.InOutCubic }
	// 		}
	// 	}
	//
	// 	onClicked: {
	// 		// TODO: Open the music widget window
	// 	}
	//
	// 	RowLayout {
	// 		id: row
	// 		anchors.centerIn: parent
	// 		// width: parent.width - 2 * spacing
	// 		// spacing: 8
	//
	// 		property var player: musicBarRoot.activePlayer
	// 		property real textMaxWidth: parent.width - spacing - coverImage.width
	// 		
	// 		RoundedImage {
	// 			id: coverImage
	// 			source: row.player?.trackArtUrl
	// 			radius: width / 2
	// 			Layout.preferredWidth: 22
	// 			Layout.preferredHeight: 22
	// 		}
	//
	// 		ColumnLayout {
	// 			id: column
	// 			spacing: -3
	// 			Layout.preferredWidth: row.textMaxWidth
	// 			
	// 			MusicDisplay {
	// 				Layout.fillWidth: true
	// 				player: musicBarRoot.activePlayer
	// 				visible: musicBarRoot.activePlayer ? true : false
	// 			}
	// 		}
	// 	}
	//
	// 	Rectangle {
	// 		anchors.fill: parent
	// 		color: "transparent"
	// 		border.color: "red"
	// 		border.width: 2
	// 		radius: 4
	// 	}
	// }
}
