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
    var locationCity: String!
    var locationState: String!

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
        
        let alarmDate = NSDate.init(string: "2016-05-15 20:55:00 +0000")
        
        let timer = NSTimer.init(fireDate: alarmDate!, interval: 0, target: self, selector: #selector(setup), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)

        
        
        
        
        performSelector(#selector(setup), withObject: nil, afterDelay: 5)
        
        
    }
    
    func say(text: String) {
        let task = NSTask.init()
        task.launchPath = "/usr/bin/say"
        task.arguments = [text]
        task.launch()
        task.waitUntilExit()
    }
    
    func setup() {
//        NSSound.setSystemVolume(1)
        sayHello()
        fetchWeather()
        
    }
    
    func sayHello() {
        operationQueue.addOperation(NSBlockOperation.init(block: {
            
            self.originalSystemVolume = NSSound.systemVolume()
            
            self.say("Good morning Stephen")
            
        }))
    }
    
    func fetchWeather() {
        JClient.fetchWeather(locationCity!, state: locationState!, completion: { (temp, weather, high) in
            self.sayWeather(temp, weather: weather, high: high)
        })
    }
    func sayWeather(temp: String, weather: String, high: String) {
        self.operationQueue.addOperation(NSBlockOperation.init(block: { 
            
            self.say("It is currently \(temp). Today will be \(weather) with a high of \(high) degrees")

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
        print ("Location: \(location)")
        
        // Prepopulate city, state, zip with user's current location
        let ceo = CLGeocoder.init()
        ceo.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            let placemark = placemarks![0]
            
            self.locationCity = placemark.locality
            self.locationState = placemark.administrativeArea
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

