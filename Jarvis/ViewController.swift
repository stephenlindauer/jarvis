//
//  ViewController.swift
//  Jarvis
//
//  Created by Frank on 5/13/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, CLLocationManagerDelegate, NSSpeechRecognizerDelegate {
    
    var locationManager: CLLocationManager!
    var operationQueue: NSOperationQueue!
    var originalSystemVolume: Float!
    var speechRecognizer = NSSpeechRecognizer()
    var isListening = false
    var commands:[String]!
    var lastSpeechCommand : String!
    var lastAttention: NSDate!
    var controllers : [JCommandController] = [JSpotifyController.init()]

    override func viewDidLoad() {
        super.viewDidLoad()

        operationQueue = NSOperationQueue.init()
        operationQueue.maxConcurrentOperationCount = 1
        
        
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
        
//        NSSound.setSystemVolume(originalSystemVolume)

        
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusItem.image = NSImage.init(named: "jarvis-icon")
        
        let d = NSDate.init()
        print ("Now: \(d)")
        
//        let alarmDate = NSDate.init(timeIntervalSinceNow: 5)
//        let alarmDate = NSDate.init(string: "2016-05-21 13:00:00 +0000")!
        let nextAlarm = JAlarm.findAllSortedBy("date", ascending: true)[0]
        let alarmDate = nextAlarm.date!
        
        let timer = NSTimer.init(fireDate: alarmDate!, interval: 0, target: self, selector: #selector(setup), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)

        let hoursFromNow = Double(Int(alarmDate!.timeIntervalSinceNow / 60 / 60 * 10)) / 10.0
        print ("next alarm in \(hoursFromNow) hours")
        if (hoursFromNow < 8 && hoursFromNow > 0) {
            say("Alarm set for \(hoursFromNow) hours from now.")
        }
        
        
//        let alarm = JAlarm.createEntity() as! JAlarm
//        alarm.date = NSDate.init(string: "2016-05-26 13:00:00 +0000")!
//        alarm.name = "Wake Up"
//        do {
//            try NSManagedObjectContext.contextForCurrentThread().save()
//        } catch {
//            print (error)
//        }
        
        
////        let wakeTime = CFAbsoluteTimeGetCurrent() + 60 as! CFDate
//        let wakeTime = CFDateCreate(nil, CFAbsoluteTimeGetCurrent() + 90)
//        
//        let returnCode = IOPMSchedulePowerEvent (wakeTime, nil, "")
//        print ("return : \(returnCode)")
        
        // Setup first commands
        commands = ["hello computer", "weather for today", "weather for tomorrow", "time is it", "stop listening", "go away", "hey computer", "hey navi", "mute volume", "your name", "increase volume", "decrease volume", "say again", "list commands", "test alarm", "open alarms", "facetime terra", "text terra"]
//        commands.appendContentsOf(["alpha", "bravo", "charlie", "delta", "echo", "fox", "golf", "hotel", "india", "juliet", "kilo", "lima", "mike", "november", "ocscar", "papa", "qubec", "romeo", "siera", "tango", "uniform", "victor", "whiskey", "xray", "yankee", "zulu"])
        
        commands.appendContentsOf(["build M4K", "build M 4 K"])
        commands.appendContentsOf(["open trello", "open harvest", "open facebook"])
        
        for controller in controllers {
            commands.appendContentsOf(controller.getCommands())
        }
        
        speechRecognizer?.delegate = self
        speechRecognizer?.commands = commands
        speechRecognizer?.startListening()
        
        
        lastAttention = NSDate.init()
        
        
        for command in commands {
            if (command.componentsSeparatedByString(" ").count == 1) {
                print("<WARN> Command too short: \(command)")
            }
         }
    }
    
    func recycleSpeechRecognizer() {
        speechRecognizer?.stopListening()
        speechRecognizer?.startListening()
    }
    
    private func randomResponse(responses: NSArray) -> String {
        return responses[Int(rand()) % responses.count] as! String
    }
    
    func speechRecognizer(sender: NSSpeechRecognizer, didRecognizeCommand command: String) {
        
        print ("Command: \(command)")
        
        if (lastAttention.timeIntervalSinceNow < -60) {
            isListening = false
            print ("<INFO> Navi fell asleep.")
        }
        
        if (command == "hey computer" || command == "hey navi") {
            sayMessage(randomResponse(["Yes?", "How can I help you?", "What's up?"]))
            isListening = true
            lastAttention = NSDate.init()
            return
        }
        
        // if not listening, no further processing
        if (isListening == false) {
            return
        }
        
        lastAttention = NSDate.init()
        
        for controller in controllers {
            if (controller.respondsToCommand(command)) {
                controller.performCommand(command)
            }
        }
        
        switch command {
        case "weather for today":
            sayMessage("Looking.")
            fetchWeather("now")
        case "weather for tomorrow":
            sayMessage("Looking.")
            fetchWeather("tomorrow")
        case "hello computer":
            sayMessage(randomResponse(["Hello.", "What's up?", "Hey.", "Yo."]))
        case "stop listening", "go away":
            isListening = false
            sayMessage("Ok.")
        case "time is it":
            let time = NSDate().stringWithFormat("h:mm a")
            sayMessage("It is \(time)")
        case "your name":
//            sayMessage("My name is Navi.")
            sayMessage("I don't know my name yet.")
        case "mute volume":
            NSSound.setSystemVolume(0)
        case "increase volume":
            NSSound.setSystemVolume(NSSound.systemVolume() + 0.2)
        case "decrease volume":
            NSSound.setSystemVolume(NSSound.systemVolume() - 0.2)
        case "list commands":
            print ("Listing all commands...")
            for cmd in commands {
                print(cmd)
            }
        case "bitch":
            sayMessage("Whoa. That's harsh.")
        case "say again":
            sayMessage(lastSpeechCommand)
        case "build M4K", "build M 4 K":
            build("M4K")
        case "test alarm":
            setup()
        case "open alarms":
            let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.showAlarmsWindow(self)
        case "facetime terra":
            facetimeTerra()
        case "text terra":
            open("iMessage://4804897948")
        case "open trello":
            open("https://trello.com/b/94tEN5Il/address-book")
        case "open facebook":
            open("https://www.facebook.com")
        case "open harvest":
            open("https://comocoding.harvestapp.com/time")
            
        default:
            print ("No implementation for command '\(command)'")
        }
        
        
    }
    
    func build(project : String) {
        if (project == "M4K") {
            let task = NSTask.init()
            task.launchPath = "/usr/bin/git"
            task.arguments = ["push", "heroku", "master"]
            task.launch()
            task.waitUntilExit()
        }
    }
    
    func open(what: String) {
        let task = NSTask.init()
        task.launchPath = "/usr/bin/open"
        task.arguments = [what]
        task.launch()
        task.waitUntilExit()
    }
    
    func facetimeTerra() {
        open("facetime://4804897948")
    }

    func say(text: String) {
        print("Saying... \(text)")
        lastSpeechCommand = text
        
        let task = NSTask.init()
        task.launchPath = "/usr/bin/say"
        task.arguments = [text]
        task.launch()
        task.waitUntilExit()
    }
    
    func setup() {
        self.originalSystemVolume = NSSound.systemVolume()
        NSSound.setSystemVolume(0.75)
        
        // Create warning
        performSelector(#selector(sayTimeToLeaveMessage), withObject:nil , afterDelay: 60*15)
        
        
        let time = NSDate().stringWithFormat("h:mm a")
        sayMessage("Good morning Stephen. It's \(time).")
        fetchWeather("now")
        
        performSelector(#selector(sayMessage), withObject:"Don't forget to text Chris back." , afterDelay: 5)
    }
    
    func sayMessage(message: String) {
        operationQueue.addOperation(NSBlockOperation.init(block: {
            self.say(message)
            
        }))
    }
    
    func fetchWeather(when: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let location = userDefaults.objectForKey("location")
        let city = location!["city"] as! String
        let state = location!["state"] as! String
        
        JClient.fetchWeather(city, state: state, when:when, completion: { (temp, weather, high, date) in
            self.operationQueue.addOperation(NSBlockOperation.init(block: {
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let location = userDefaults.objectForKey("location")
                let city = location!["city"] as! String
                
                if (when == "now") {
                    self.say("The weather in \(city) is \(temp) degrees. \(date) will be \(weather) with a high of \(high).")
                }
                else {
                    self.say("The weather for \(date) will be \(weather) with a high of \(high).")
                }
                
            }))
        })
    }
    
    func sayTimeToLeaveMessage() {
        let time = NSDate().stringWithFormat("h:mm a")
        sayMessage("It is now \(time). Time to leave for PT.")
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    
    // MARK: - CoreLocationDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        
        locationManager.stopUpdatingLocation()
        
        let location = locations[0] as! CLLocation
        
        // Prepopulate city, state, zip with user's current location
        let ceo = CLGeocoder.init()
        ceo.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if (placemarks?.count > 0) {
                let placemark = placemarks![0]
                
                let locationDict : [String : AnyObject] = [
                    "city":placemark.locality!,
                    "state":placemark.administrativeArea!
                ]
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(locationDict, forKey: "location")
                userDefaults.synchronize()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("error: \(error)")
    }
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        // Update map location
//        let location = locations[0]
//        setMapLocation(location.coordinate)
//        
//        // Prepopulate city, state, zip with user's current location
//        let ceo = CLGeocoder.init()
//        ceo.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
//            let placemark = placemarks![0]
//            self.cityTextField.text = placemark.locality
//            self.stateTextField.text = placemark.administrativeArea
//            self.zipTextField.text = placemark.postalCode
//            print (placemark)
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        showAlertForError(error)
//    }

}

