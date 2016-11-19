//
//  JWeatherController.swift
//  Jarvis
//
//  Created by Frank on 5/27/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//


class JWeatherController: JCommandController {

    override func getCommands() -> [String] {
        return ["weather for today", "weather for tomorrow"]
    }
    
    override func performCommand(command: String) {
        switch command {
        case "weather for today":
            JJarvis.shared.sayMessage("Looking.")
            fetchWeather("now")
        case "weather for tomorrow":
            JJarvis.shared.sayMessage("Looking.")
            fetchWeather("tomorrow")
        default:
            print ("No weather implementation")
        }

    }
    
    
    func fetchWeather(when: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let location = userDefaults.objectForKey("location")
        let city = location!["city"] as! String
        let state = location!["state"] as! String
        
        JClient.fetchWeather(city, state: state, when:when, completion: { (temp, weather, high, date) in
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let location = userDefaults.objectForKey("location")
            let city = location!["city"] as! String
            let dateString = date == "now" ? "today" : date
            
            if (when == "now") {
                JJarvis.shared.sayMessage("The weather in \(city) is \(temp) degrees. \(dateString) will be \(weather) with a high of \(high).")
            }
            else {
                JJarvis.shared.sayMessage("The weather for \(dateString) will be \(weather) with a high of \(high).")
            }
            
        })
    }
}
