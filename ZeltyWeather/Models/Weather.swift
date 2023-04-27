//
//  Weather.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation

struct Weather {
    var date: String
    var hour: String
    var temperature: String
    var feelsLike: String
    var pressure: String
    var humidity: String
    var description: String
    var detailedDecription: String
    var image: String
    var cloud: String
    var wind: String
    var city: City
}

struct City {
    var name: String
    var population: String
    var sunrise: String
    var sunset: String
}
