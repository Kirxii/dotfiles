import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ShellRoot {
	PanelWindow {
		implicitHeight: 32
		color: "#1e1e2e"
		anchors {
			top: true
			left: true
			right: true
		}

		RowLayout {
			anchors.fill: parent
			anchors.leftMargin: 14
			anchors.rightMargin: 14

			Workspaces {}
			
			Item {
				Layout.fillWidth: true
			}
			
			Music {}
			
			Item {
				Layout.fillWidth: true
			}

			Clock {}
		}
		
		SystemClock {
			id: something
			precision: SystemClock.Seconds
		}
	}
}

