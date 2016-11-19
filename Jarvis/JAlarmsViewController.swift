//
//  JAlarmsViewController.swift
//  Jarvis
//
//  Created by Frank on 5/22/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//


class JAlarmsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSMenuDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    var alarms : NSArray!
    
    override func viewDidLoad() {
        
        alarms = JAlarm.findAllSortedBy("date", ascending: true)
        
        NSNotificationCenter().addObserver(self, selector: #selector(refreshAlarms), name: "JAlarmsUpdated", object: nil)
    }
    
    func refreshAlarms() {
        alarms = JAlarm.findAllSortedBy("date", ascending: true)
        self.tableView.reloadData()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return alarms.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        
        if tableColumn == tableView.tableColumns[0] {
            let cell = tableView.makeViewWithIdentifier("AlarmNameCell", owner: nil) as? NSTableCellView
            let alarm = alarms[row]
            cell!.textField?.stringValue = alarm.name
            
            return cell
        }
        
        if tableColumn == tableView.tableColumns[1] {
            let cell = tableView.makeViewWithIdentifier("AlarmDateCell", owner: nil) as? NSTableCellView
            let alarm = alarms[row] as! JAlarm
            cell!.textField?.stringValue = (alarm.date?.string())!
            
            return cell
        }
        
        
        return nil
    }
    
    func menuNeedsUpdate(menu: NSMenu) {
        menu.removeAllItems()
        
        menu.addItemWithTitle("Edit", action: #selector(editAlarm), keyEquivalent: "")
        menu.addItemWithTitle("Delete", action: #selector(deleteAlarm(_:)), keyEquivalent: "")
        
        

    }
    
    func editAlarm() {
        
    }
    
    func deleteAlarm(sender: NSMenuItem) {
        let alarm = alarms[tableView.clickedRow] as! JAlarm
        print ("Alarm: \(alarm.name)")
        alarm.deleteEntity()
        
        do {
        try NSManagedObjectContext.contextForCurrentThread().save()
        } catch {}
        
        refreshAlarms()
    }
}
