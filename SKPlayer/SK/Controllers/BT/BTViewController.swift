//
//  BTViewController.swift
//  SKPlayer
//
//  Created by sk on 2018/9/13.
//  Copyright © 2018 sk. All rights reserved.
//

import Cocoa

class BTViewController: NSViewController {
    @IBOutlet weak var btTableView: NSTableView!
    
    var session: NSApplication.ModalSession?
    var bts:[BT]?{
        didSet{
            self.btTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.btTableView.target = self
        self.btTableView.doubleAction = #selector(doubleClickTbaleView(_:))
    }
    override func viewDidAppear() {
        assert(session == nil, "在CloudPlayerViewController中对session进行赋值")
        super.viewDidAppear()
    }
    override func viewDidDisappear() {
        super.viewDidDisappear()
       finish()
    }
    
    func finish() -> Void {
        if let session = session {
            NSApp.endModalSession(session)
            self.session = nil
            self.view.window?.performClose(self)
        }
    }
    
}
extension BTViewController{
    @objc  func doubleClickTbaleView( _ tableView: NSTableView ) -> Void {
        //
    }
}

extension BTViewController: NSTableViewDelegate{
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let bt: BT = bts![row]
        
        let identifier = tableColumn?.identifier
        if let identifier = identifier, identifier.rawValue == "title" {
            
            let cell: NSTableCellView =  tableView.makeView(withIdentifier: identifier, owner: self) as! NSTableCellView
            cell.textField?.stringValue = bt.btTitle
            
            return cell
        }
        if let identifier = identifier, identifier.rawValue == "kind" {
            
            let cell: NSTableCellView =  tableView.makeView(withIdentifier: identifier, owner: self) as! NSTableCellView
            cell.textField?.stringValue = bt.bt
            
            return cell
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        return
        let tableView = notification.object as! NSTableView
        let row = tableView.selectedRow
        let bt: BT = bts![row]
       finish()
    }
}
extension BTViewController: NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView) -> Int {
        if let bts = bts {
            return bts.count
        }
        return 0
    }
    
    
}

extension BTViewController{
    @objc func copyToPasteboard(sender:AnyObject){
        
        let bt: BT = self.bts![self.btTableView.selectedRow]
        let pastedboard: NSPasteboard = NSPasteboard.general
        pastedboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pastedboard.setString(bt.bt, forType: NSPasteboard.PasteboardType.string)
    }
    @objc func queryDownloadMagnet(sender: AnyObject){
        let bt: BT = self.bts![self.btTableView.selectedRow]
        NSWorkspace.shared.open(URL.init(string: bt.bt)!)
        finish()
    }
    @objc func watchBySafariOrChrome(sender: AnyObject){
        queryDownloadMagnet(sender: sender)
    }
  
}

extension BTViewController: ContextMenu{
    @objc func tableView(_ tableView: NSTableView, menuForRows rows:IndexSet)->NSMenu?{
        let bt: BT = self.bts![self.btTableView.selectedRow]
        if bt.isLink {
            
            let menu = NSMenu.init(title: "在线资源")
            let copy: NSMenuItem = NSMenuItem(title: "复制", action: #selector(copyToPasteboard(sender:)), keyEquivalent: "")
            let watchLink: NSMenuItem = NSMenuItem(title: "浏览器打开", action: #selector(watchBySafariOrChrome(sender:)), keyEquivalent: "")
            menu.addItem(copy)
            menu.addItem(watchLink)
            
        }
        
        let menu = NSMenu.init(title: "BT资源")

        var downLoadBT:NSMenuItem? = nil
       
          downLoadBT = NSMenuItem(title: "下载", action: #selector(queryDownloadMagnet(sender:)), keyEquivalent: "")
        let copy: NSMenuItem = NSMenuItem(title: "复制", action: #selector(copyToPasteboard(sender:)), keyEquivalent: "")
      
        
        menu.addItem(copy)
        menu.addItem(downLoadBT!)
        return menu
    }
    @objc func tableView(_ tableView: NSTableView, clickForRow row: Int) -> Void {
        
    }
}

@objc protocol ContextMenu {
    @objc func tableView(_ tableView: NSTableView, menuForRows rows:IndexSet)->NSMenu?
    @objc func tableView(_ tableView: NSTableView, clickForRow row: Int) -> Void
}
extension NSTableView {
    open override func menu(for event: NSEvent) -> NSMenu? {
        let location = self.convert(event.locationInWindow, from: nil)
        let row = self.row(at: location)
        if row >= 0 && event.type == .rightMouseDown {
            
            var selected = self.selectedRowIndexes
            if  false ==  selected.contains(row) {
                selected = IndexSet.init(integer: row)
                self.selectRowIndexes(selected, byExtendingSelection: false)
            }
            if  let dele:ContextMenu = (self.delegate as? ContextMenu)  {
                return   dele.tableView(self, menuForRows: selected)
            }else{
                return super.menu(for: event)
            }
        }
        
        
        return super.menu(for: event)
    }
    open override func mouseDown(with event: NSEvent) {
        let location = self.convert(event.locationInWindow, from: nil)
        let row = self.row(at: location)
        if row >= 0 && event.type == .rightMouseDown {
            
            var selected = self.selectedRowIndexes
            if  false ==  selected.contains(row) {
                selected = IndexSet.init(integer: row)
                self.selectRowIndexes(selected, byExtendingSelection: false)
            }
            if  let dele:ContextMenu = (self.delegate as? ContextMenu)  {
                dele.tableView(self, clickForRow: row)
            }
        }
        return super.mouseDown(with: event)
    }
    
}


