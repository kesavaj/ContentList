//

import Foundation
import AppKit

class LabelCollectionViewItem: NSCollectionViewItem {
	
	// MARK: properties
		
    override var isSelected: Bool {
		didSet {
            (self.view as! LabelCollectionViewItemView).selected = isSelected
		}
	}
    override var highlightState: NSCollectionViewItem.HighlightState {
		didSet {
			(self.view as! LabelCollectionViewItemView).highlightState = highlightState
		}
	}

	// MARK: outlets
	
	@IBOutlet weak var label: NSTextField!

}

//class LabelCollectionViewItem2: NSCollectionViewItem {
//
//	// MARK: properties
//
//	var labelObject:LabelObject? {
//		didSet {
//			label.stringValue = labelObject?.title ?? ""
//		}
//	}
//
//	override var isSelected: Bool {
//		didSet {
//			(self.view as! LabelCollectionViewItemView).selected = isSelected
//		}
//	}
//    override var highlightState: NSCollectionViewItem.HighlightState {
//		didSet {
//			(self.view as! LabelCollectionViewItemView).highlightState = highlightState
//		}
//	}
//
//	// MARK: - 🔴🔴🔴🔴🔴 view properties 🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴
//
//	var label:NSTextField!
//
//	// MARK: - 🔴🔴🔴🔴🔴 NSViewController 🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴
//
//	override func loadView() {
//		self.view = LabelCollectionViewItemView(frame: NSRect(x: 0, y: 0, width: 300, height: 30))
//		self.view.wantsLayer = true
//		self.view.layer?.backgroundColor = NSColor.greenColor().CGColor
//
//		label = {
//			let v = NSTextField()
//			v.selectable = false
//			v.editable = false
//			v.drawsBackground = false
//			v.bezeled = false
//			v.translatesAutoresizingMaskIntoConstraints = false
//			v.alignment = .Center
//			v.font = NSFont.systemFontOfSize(30)
//			return v
//		}()
//
//		self.view.addSubview(label)
//		self.view.pbbPlaceInCenter(label)
//	}
//
//	// MARK: NSResponder
//
//	override func mouseDown(theEvent: NSEvent) {
//		if theEvent.clickCount == 2 {
//			print("Double click \(labelObject!.title)")
//		} else {
//			super.mouseDown(theEvent)
//		}
//
//	}
//
//}

