//
//  HomeViewModel.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation
import Combine

final class HomeViewModel {

    // MARK: - Input / Output
    
    /// Input events trigger by users.
    enum Input {
        case viewDidLoad
        case searchCityWeatherButtonDidTap
        case forecastWeatherRowDidTap
    }
  
    /// Output events following input events.
    enum Output {
        case fetchWeatherDidSucceed(weather: WeatherResponse)
        case fetchWeatherDidFail(error: ApiError)
    }
    
    // MARK: - Properties and initialization
  
    /// Abstraction of type, use of protocol for mocking purposes.
    private let weatherServiceType: WeatherServiceType
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    /// Weather Api data mapped to Weather object and used as data source for the main table view.
    var weather: [Weather] = []
    /// The weather chosen by user from the main table view. It will be passed down to DetailViewModel.
    var selectedWeather: Weather?
  
    init(weatherServiceType: WeatherServiceType = WeatherService()) {
        self.weatherServiceType = weatherServiceType
    }
  
    // MARK: - Methods
    
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
            weather.mapToWeathersObject()
        }.store(in: &cancellables)
    }
}
