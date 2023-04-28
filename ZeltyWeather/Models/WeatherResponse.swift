//
//  WeatherResponse.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation

// Object received from API and use for parsing.
struct WeatherResponse: Decodable {
    let forecasts: [ForecastResponse]
    let city: CityResponse

    enum CodingKeys: String, CodingKey {
        case forecasts = "list"
        case city
    }
}

struct ForecastResponse: Decodable {
    let date: Int
    let temperature: Temperature
    let weather: [WeatherDescription]
    let clouds: Cloud
    let wind: Wind
    let dateText: String

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "main"
        case weather
        case clouds
        case wind
        case dateText = "dt_txt"
    }
}

struct Temperature: Decodable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
    }
}

struct WeatherDescription: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct Cloud: Decodable {
    let all: Int
}

struct Wind: Decodable {
    let speed: Double
}

struct CityResponse: Decodable {
    let name: String
    let population: Int
    let sunrise: Int
    let sunset: Int
}
