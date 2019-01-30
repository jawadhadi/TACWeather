//
//  WeatherAPI.swift
//  TACWeather
//
//  Created by Hadi on 31/01/2019.
//  Copyright © 2019 Hadi. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherAPI{
    
    let apiKey = "372dd407d3361000d0ad2d4eb6a5a5da" //API Key for OpenWeatherMamp
    let baseWeatherAPIURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(for location: CLLocation, completionHandler: @escaping (Weather?, Error?) -> Void) {
        
        let url = URL(string: baseWeatherAPIURL + "?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error as NSError?{
                
                completionHandler(nil, error)
                
                return
                
            }
            
            guard let data = data else{
                
                fatalError("Data was nil")
                
            }
            
            let decoder = JSONDecoder()
            
            guard let weather = try? decoder.decode(Weather.self, from: data) else {
                
                fatalError("Decoding failed")
                
            }
            
            completionHandler(weather, nil)
            
        }
        
        task.resume()
        
    }
    
}
