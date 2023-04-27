//
//  WeatherResponse.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation

struct WeatherResponse: Decodable {
    let forecasts: [ForecastResponse]
    let city: CityResponse

    enum CodingKeys: String, CodingKey {
        case forecasts = "list"
        case city
    }
}

struct ForecastResponse: Decodable {
    let temperature: Temperature
    let weather: [WeatherDescription]
    let clouds: Cloud
    let wind: Wind

    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case weather
        case clouds
        case wind
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
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
