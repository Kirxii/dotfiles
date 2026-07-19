pragma ComponentBehavior: Bound

import QtQuick
import Qt5Compat.GraphicalEffects 

Item {
	id: imageRoot

	property url source: ""
	property real radius: 10
	property int fillMode: Image.PreserveAspectCrop

	width: 22
	height: 22

	Image {
		id: image
		anchors.fill: parent
		source: imageRoot.source
		fillMode: imageRoot.fillMode
		
		layer.enabled: true
		layer.effect: OpacityMask {
			maskSource: mask
		}
	}

	Rectangle {
		id: mask
		anchors.fill: parent
		radius: imageRoot.radius
		visible: false
	}
}
