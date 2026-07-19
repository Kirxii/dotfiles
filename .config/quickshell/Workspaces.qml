import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
	spacing: 12

	Repeater {
		model: 9

		Rectangle {
			// Variables for the component 
			id: workspaceButton
			required property int index

			property var workspace: Hyprland.workspaces.values.find(w => w.id === index + 1)
			property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

			implicitWidth: label.implicitWidth + 14
			implicitHeight: 22
			radius: 6

			// NOTE: Hex color code is in #AARRGGBB
			color: isActive ? "#44a6e3a1" : (workspace ? "#313244" : "transparent")

			Behavior on color {
				ColorAnimation { duration: 150 }
			}

			// Component specs
			Text {
				id: label
				anchors.centerIn: parent
				text: workspaceButton.index + 1
				color: workspaceButton.isActive ? "#a6e3a1" :
					(workspaceButton.workspace ? "#cdd6f4" : "white")

				font {
					family: "JetBrainsMono Nerd Font"
					pixelSize: 12
					weight: 600
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${parent.index + 1} })`)
			}
		}
	}
}
