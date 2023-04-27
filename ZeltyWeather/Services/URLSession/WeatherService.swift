//
//  WeatherService.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation
import Combine

// Enum of different errors that our api call can throw. This allows to handle each error case differently.
enum ApiError: Error {
    case badUrl
    case badRequest
    case badServerResponse
    case invalidResponse
    case badParsing
}

// WeatherService protocol to conform for better flexibility and modularity since not tightly coupled to a specific type, also for mocking purposes.
protocol WeatherServiceType {
    func getWeather() -> AnyPublisher<WeatherResponse, Error>
}

class WeatherService: WeatherServiceType {
  
    /// Api call to openweathermap using reactive programming to react for any stream of data received, either an error or the correct formatted data.
    func getWeather() -> AnyPublisher<WeatherResponse, Error> {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=Paris&cnt=5&units=metric&lang=fr&appid=04f9398e32383d6ae628d50a946848e2")
        
        guard let url = url else {
            return Fail(error: ApiError.badUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError({ _ in
                return ApiError.badUrl
            })
            .tryMap() { element -> WeatherResponse in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode < 500 else {
                    throw ApiError.badServerResponse
                }
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode < 400 else {
                    throw ApiError.badRequest
                }
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw ApiError.invalidResponse
                }
                do {
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: element.data)
                    return weatherResponse
                } catch {
                    throw ApiError.badParsing
                }
            }
            .eraseToAnyPublisher()
    }
}