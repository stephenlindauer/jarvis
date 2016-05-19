//
//  ViewController.swift
//  Jarvis
//
//  Created by Frank on 5/13/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var operationQueue: NSOperationQueue!
    var originalSystemVolume: Float!

    override func viewDidLoad() {
        super.viewDidLoad()

        operationQueue = NSOperationQueue.init()
        operationQueue.maxConcurrentOperationCount = 1
        
        
        
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
//        NSSound.setSystemVolume(originalSystemVolume)

        
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusItem.image = NSImage.init(named: "jarvis-icon")
        
        let d = NSDate.init()
        print ("Now: \(d)")
        
//        let alarmDate = NSDate.init(timeIntervalSinceNow: 5)
        let alarmDate = NSDate.init(string: "2016-05-19 12:20:00 +0000")!
        
        let timer = NSTimer.init(fireDate: alarmDate, interval: 0, target: self, selector: #selector(setup), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)

        let hoursFromNow = Double(Int(alarmDate.timeIntervalSinceNow / 60 / 60 * 10)) / 10.0
        say("Alarm set for \(hoursFromNow) hours from now.")
        
        
////        let wakeTime = CFAbsoluteTimeGetCurrent() + 60 as! CFDate
//        let wakeTime = CFDateCreate(nil, CFAbsoluteTimeGetCurrent() + 90)
//        
//        let returnCode = IOPMSchedulePowerEvent (wakeTime, nil, "")
//        print ("return : \(returnCode)")
        
        
        
    }
    

    func say(text: String) {
        print("Saying... \(text)")
        let task = NSTask.init()
        task.launchPath = "/usr/bin/say"
        task.arguments = [text]
        task.launch()
        task.waitUntilExit()
    }
    
    func setup() {
        print ("Setup!")
        self.originalSystemVolume = NSSound.systemVolume()
        NSSound.setSystemVolume(0.7)
        let now = NSDate()
        print ("Now: \(now)")
        
        let time = now.stringWithFormat("h:mm a")
        sayMessage("Good morning Stephen. It's \(time).")
        fetchWeather()

        performSelector(#selector(sayMessage), withObject: "Also, don't forget. Today is swim P T.", afterDelay: 5)
    }
    
    func sayMessage(message: String) {
        operationQueue.addOperation(NSBlockOperation.init(block: {
            self.say(message)
            
        }))
    }
    
    // good morning. it's 7am. the weather in Tacoma is 72 degrees with scattered clouds.

    func fetchWeather() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let location = userDefaults.objectForKey("location")
        let city = location!["city"] as! String
        let state = location!["state"] as! String
        
        JClient.fetchWeather(city, state: state, completion: { (temp, weather, high) in
            self.sayWeather(temp, weather: weather, high: high)
        })
    }
    func sayWeather(temp: String, weather: String, high: String) {
        self.operationQueue.addOperation(NSBlockOperation.init(block: { 

            let userDefaults = NSUserDefaults.standardUserDefaults()
            let location = userDefaults.objectForKey("location")
            let city = location!["city"] as! String
            
            self.say("The weather in \(city) is \(temp) degrees. Today will be \(weather) with a high of \(high).")

        }))
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

