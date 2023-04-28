//
//  WeatherWithImage.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 28/04/2023.
//

import Foundation
import UIKit

// WeatherWithImage structure used as datasource of the main table view, UIImage directly downloaded for better performances (to avoid doing it each time the table view reloads).
struct WeatherWithImage {
    var date: String
    var hour: String
    var temperature: String
    var feelsLike: String
    var pressure: String
    var humidity: String
    var description: String
    var detailedDecription: String
    var image: UIImage
    var cloud: String
    var wind: String
    var city: City
}
