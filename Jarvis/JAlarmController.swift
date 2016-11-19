//
//  JAlarmController.swift
//  Jarvis
//
//  Created by Frank on 5/27/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//



class JAlarmController: JCommandController {

    override func setup() {
        
        queueNextAlarm()
    }
    
    override func getCommands() -> [String] {
        return ["open alarms", "test alarm", "time is it", "when is my next alarm"]
    }
    
    override func performCommand(command: String) {
        switch command {
        case "test alarm":
            testNextAlarm()
        case "open alarms":
            let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.showAlarmsWindow(self)
        case "time is it":
            let time = NSDate().stringWithFormat("h:mm a")
            JJarvis.shared.sayMessage("It is \(time)")
        case "when is my next alarm":
            sayWhenNextAlarm()
        default:
            print ("No spotify implementation")
        }
    }
    
    private func nextAlarm() -> JAlarm? {
        let alarms = JAlarm.findAllSortedBy("date", ascending: true) as NSArray
        if (alarms.count == 0) {
            print("<INFO> No future alarms set.")
//            JJarvis.shared.sayMessage("You have no upcoming alarms set.")
            return nil
        }
        return alarms[0] as? JAlarm
    }
    
    func sayWhenNextAlarm() {
        let alarm = nextAlarm()
        if (alarm != nil) {
            let timeString = alarm!.date!.stringWithFormat("h:mm a")
            JJarvis.shared.sayMessage("Your next alarm is set for \(timeString).")
        }
    }

    func testNextAlarm() {
//        self.originalSystemVolume = NSSound.systemVolume()
                NSSound.setSystemVolume(0.7)
        
        // Create warning
        performSelector(#selector(sayTimeToLeaveMessage), withObject:nil , afterDelay: 60*15)
        
        
        let time = NSDate().stringWithFormat("h:mm a")
        
        let alarm = nextAlarm()
        
        if (alarm!.name == "Wake Up") {
            JJarvis.shared.sayMessage("Good morning Stephen. It's \(time).")
            JWeatherController().fetchWeather("now")
            
            //        performSelector(#selector(sayMessage), withObject:"One day left until you get to see Terra again." , afterDelay: 5)
        }
        else if (alarm!.name == "Leave") {
            JJarvis.shared.sayMessage("Stephen, the time is \(time). Time to go.")
        }
    }


    func queueNextAlarm() {
        
        if (nextAlarm() != nil) {
            let alarmDate = nextAlarm()!.date!
            
            let timer = NSTimer.init(fireDate: alarmDate, interval: 0, target: self, selector: #selector(testNextAlarm), userInfo: nil, repeats: false)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
        else {
            print ("No alarms")
        }
    }
    
    
    func sayTimeToLeaveMessage() {
        let time = NSDate().stringWithFormat("h:mm a")
        JJarvis.shared.sayMessage("It is now \(time).")
    }
}
