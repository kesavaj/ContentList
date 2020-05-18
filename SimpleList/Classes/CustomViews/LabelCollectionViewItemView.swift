//

import Foundation
import AppKit

class LabelCollectionViewItemView: NSView {

	// MARK: properties
	
	var selected: Bool = false {
		didSet {
			if selected != oldValue {
				needsDisplay = true
			}
		}
	}
    var highlightState: NSCollectionViewItem.HighlightState = .none {
		didSet {
			if highlightState != oldValue {
				needsDisplay = true
			}
		}
	}
	
	// MARK: NSView

	override var wantsUpdateLayer: Bool {
		return true
	}

	override func updateLayer() {
		if selected {
			self.layer?.cornerRadius = 10
            layer!.backgroundColor = NSColor.darkGray.cgColor
		} else {
			self.layer?.cornerRadius = 0
            layer!.backgroundColor = NSColor.lightGray.cgColor
		}
		
	}

	// MARK: init

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		wantsLayer = true
		layer?.masksToBounds = true
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		wantsLayer = true
		layer?.masksToBounds = true
	}
}
