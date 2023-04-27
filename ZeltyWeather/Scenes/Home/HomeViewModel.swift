//
//  HomeViewModel.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation
import Combine

class HomeViewModel {
  
    enum Input {
        case viewDidLoad
        case searchCityWeatherButtonDidTap
        case forecastWeatherRowDidTap
    }
  
    enum Output {
        case fetchWeatherDidSucceed(weather: WeatherResponse)
        case fetchWeatherDidFail(error: ApiError)
    }
  
    private let weatherServiceType: WeatherServiceType
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
  
    init(weatherServiceType: WeatherServiceType = WeatherService()) {
        self.weatherServiceType = weatherServiceType
    }
  
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidLoad:
                self?.handleGetWeather(city: "Paris")
            case .searchCityWeatherButtonDidTap:
                print("Bonjour")
            case .forecastWeatherRowDidTap:
                print("Bonjour")
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
  
    private func handleGetWeather(city: String) {
        weatherServiceType.getWeather(city: city).sink { [weak self] completion in
            if case .failure(let error) = completion {
                if let error = error as? ApiError {
                    self?.output.send(.fetchWeatherDidFail(error: error))
                }
            }
        } receiveValue: { [weak self] weather in
            self?.output.send(.fetchWeatherDidSucceed(weather: weather))
        }.store(in: &cancellables)
    }
}
