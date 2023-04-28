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
    case noInternet
    case badUrl
    case badRequest
    case badServerResponse
    case invalidResponse
    case badParsing
}

// WeatherService protocol to conform for better flexibility and modularity since not tightly coupled to a specific type, also for mocking purposes.
protocol WeatherServiceType {
    func getWeather(city: String) -> AnyPublisher<WeatherResponse, Error>
}

final class WeatherService: WeatherServiceType {
  
    /// Api call to openweathermap using reactive programming to react for any stream of data received, either an error or the correct formatted data.
    func getWeather(city: String) -> AnyPublisher<WeatherResponse, Error> {
        /// Retrieve token saved in infolist.
        let token = Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
        /// Url string with specific parameters.
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=" + "\(city)" + "&cnt=40&units=metric&lang=fr&appid=" + "\(token)"
        /// Encode Url to allow space in it, in the case of cities written with several words.
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedUrlString ?? "")
        
        guard let url = url else {
            return Fail(error: ApiError.badUrl).eraseToAnyPublisher()
        }
        
        /// Instnace of URLSession withch returns a publisher.
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError({ _ in
                return ApiError.badUrl
            })
            .tryMap() { element -> WeatherResponse in
                /// Handle all the error cases and throw errors.
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode < 500 else {
                    throw ApiError.badServerResponse
                }
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode < 400 else {
                    throw ApiError.badRequest
                }
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw ApiError.invalidResponse
                }
                /// Do the parsing and return a publisher of type WeatherResponse.
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
