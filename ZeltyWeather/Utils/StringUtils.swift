//
//  StringUtils.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation
import UIKit

// Convert weather description from API to french (not supported directly by the API).
enum MainWeatherDescription: String {
    case clear = "Clair"
    case clouds = "Nuageux"
    case drizzle = "Bruine"
    case dust = "Poussiereux"
    case fog = "Brouillard"
    case haze = "Brumeux"
    case rain = "Pluie"
    case sand = "Sable"
    case smoke = "Fumee"
    case snow = "Neige"
    case thunderstorm = "Orageux"
}

extension String {
    func translateWeatherDescription() -> String {
        if self == "Clear" {
            return MainWeatherDescription.clear.rawValue
        } else if self == "Clouds" {
            return MainWeatherDescription.clouds.rawValue
        } else if self == "Drizzle" {
            return MainWeatherDescription.drizzle.rawValue
        } else if self == "Dust" {
            return MainWeatherDescription.dust.rawValue
        } else if self == "Fog" {
            return MainWeatherDescription.fog.rawValue
        } else if self == "Haze" || self == "Mist" {
            return MainWeatherDescription.haze.rawValue
        } else if self == "Rain" {
            return MainWeatherDescription.rain.rawValue
        } else if self == "Sand" {
            return MainWeatherDescription.sand.rawValue
        } else if self == "Smoke" {
            return MainWeatherDescription.smoke.rawValue
        } else if self == "Snow" {
            return MainWeatherDescription.snow.rawValue
        } else {
            return MainWeatherDescription.thunderstorm.rawValue
        }
    }
}
