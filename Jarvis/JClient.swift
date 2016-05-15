//
//  JClient.swift
//  Jarvis
//
//  Created by Frank on 5/13/16.
//  Copyright © 2016 Lindauer, LLC. All rights reserved.
//



class JClient: NSObject {
    
    
    class func fetchWeather(city: String, state: String, completion: (temp: String, weather: String, high: String) ->()) {
        
        let manager = AFHTTPSessionManager.init()
        manager.requestSerializer = AFJSONRequestSerializer.init()
    
        let url = "https://api.wunderground.com/api/0351249b685724dc/conditions/q/\(state)/\(city).json"
        manager.GET(url, parameters: nil, progress: nil, success: { (session, responseObject) in
            
            let currentTemp = Int(responseObject!["current_observation"]!!["temp_f"] as! NSNumber)

            // Fetch forecast
            let url = "https://api.wunderground.com/api/0351249b685724dc/forecast/q/\(state)/\(city).json"
            manager.GET(url, parameters: nil, progress: nil, success: { (session, responseObject) in
                
                let forecast = (responseObject!["forecast"]!!["simpleforecast"]!!["forecastday"] as! NSArray)[0]
                let high = forecast["high"]!!["fahrenheit"] as! String
                let conditions = forecast["conditions"] as! String
                
                completion(temp: "\(currentTemp)", weather: conditions, high: high)
                
                }) { (session, error) in
            }
            
            
            
            }) { (session, error) in
                
        }
    }

}
