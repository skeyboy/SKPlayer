//
//  QXSearchField.swift
//  SKPlayer
//
//  Created by sk on 2018/9/19.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa
typealias Search = (String)->Void
typealias SearchFocus = ()->Void
class QXSearchField: NSSearchField {
    var search: Search?
    var searchFocus: SearchFocus?
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    override func mouseDown(with event: NSEvent) {
        super.moveDown(event)
        if let searchFocus = self.searchFocus {
            searchFocus()
        }
    }
    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
    }
    override func textShouldEndEditing(_ textObject: NSText) -> Bool {
        if let search = self.search {
            search(textObject.string)
        }
        self.resignFirstResponder()
        return true
    }
    override func controlTextDidEndEditing(_ obj: Notification) {
        super.textDidEndEditing(obj)
     }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.resignFirstResponder()
    }
}
