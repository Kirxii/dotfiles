import QtQuick

Text {
	text: Qt.formatDateTime(something.date, "hh:mm:ss")
	color: "white"

	font {
		family: "JetBrainsMono Nerd Font"
		weight: 800
		pixelSize: 14
		letterSpacing: -1
	}
}
