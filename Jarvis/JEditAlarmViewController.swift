//
//  JEditAlarmViewController.swift
//  Jarvis
//
//  Created by Frank on 5/26/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//


class JEditAlarmViewController: NSViewController {

    var alarm : JAlarm!
    
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var reminderTextField: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveAlarm(sender: AnyObject) {
        if (alarm == nil) {
            alarm = JAlarm.createEntity() as! JAlarm
        }
        
        alarm.name = nameTextField.stringValue
        alarm.date = datePicker.dateValue
        do {
        try NSManagedObjectContext.contextForCurrentThread().save()
        } catch {}
        
        NSNotificationCenter().postNotificationName("JAlarmsUpdated", object: alarm)
        
        view.window?.windowController?.close()
    }
    
}
