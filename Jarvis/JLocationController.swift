//
//  JLocationController.swift
//  Jarvis
//
//  Created by Frank on 5/25/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//


class JLocationController: JCommandController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!

    
    override func getCommands() -> [String] {
        return ["update location", "what is my location"]
    }
    
    override func performCommand(command: String) {
        switch command {
        case "what is my location":
            sayLocation()
        case "update location":
            updateLocation()
        default:
            print ("No location implementation")
        }
    }
    
    func sayLocation() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let location = userDefaults.objectForKey("location")
        let city = location!["city"] as! String
        let stateAbbr = location!["state"] as! String
        let state : String
        switch stateAbbr {
        case "WA":
            state = "Washington"
        case "MO":
            state = "Missouri"
        case "HI":
            state = "Hawaii"
        default:
            state = ""
        }
        
        JJarvis.shared.sayMessage("You are currently in \(city) \(state).")
    }
    
    func updateLocation() {
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        JJarvis.shared.sayMessage("Looking.")
    }

    
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
                
                self.sayLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        JJarvis.shared.sayMessage("Location look up failed. Is wifi enabled?")
    }
}
