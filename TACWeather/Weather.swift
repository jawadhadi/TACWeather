//
//  Weather.swift
//  TACWeather
//
//  Created by Hadi on 31/01/2019.
//  Copyright © 2019 Hadi. All rights reserved.
//

import Foundation

struct Weather: Codable{
    
    var main: Main
    
}

struct Main: Codable{
    
    var temp: Double
    
}
