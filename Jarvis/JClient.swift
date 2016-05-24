//
//  JClient.swift
//  Jarvis
//
//  Created by Frank on 5/13/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//



class JClient: NSObject {
    
    
    class func fetchWeather(city: String, state: String, when: String, completion: (temp: String, weather: String, high: String, date: String) ->()) {
        
        let manager = AFHTTPSessionManager.init()
        manager.requestSerializer = AFJSONRequestSerializer.init()
    
        let url = "https://api.wunderground.com/api/0351249b685724dc/conditions/q/\(state)/\(city).json"
        manager.GET(url, parameters: nil, progress: nil, success: { (session, responseObject) in
            
            let currentTemp = Int(responseObject!["current_observation"]!!["temp_f"] as! NSNumber)

            // Fetch forecast
            let url = "https://api.wunderground.com/api/0351249b685724dc/forecast/q/\(state)/\(city).json"
            manager.GET(url, parameters: nil, progress: nil, success: { (session, responseObject) in
                
                let index : NSInteger
                if (when == "tomorrow") {
                    index = 1
                }
                else {
                    index = 0
                }
                
                let forecast = (responseObject!["forecast"]!!["simpleforecast"]!!["forecastday"] as! NSArray)[index]
                let high = forecast["high"]!!["fahrenheit"] as! String
                let conditions = forecast["conditions"] as! String
                let date = forecast["date"]!!["weekday"] as! String
                
                completion(temp: "\(currentTemp)", weather: conditions, high: high, date:date )
                
                }) { (session, error) in
            }
            
            
            
            }) { (session, error) in
                
        }
    }

}
