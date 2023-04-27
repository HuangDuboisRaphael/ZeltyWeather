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
    private let coreDataServiceType: CoreDataServiceType
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    /// Weather Api data mapped to Weather object and used as data source for the main table view.
    var weathers: [Weather] = []
    /// The weather chosen by user from the main table view. It will be passed down to DetailViewModel.
    var selectedWeather: Weather?
  
    init(weatherServiceType: WeatherServiceType = WeatherService(), coreDataServiceType: CoreDataServiceType = CoreDataService()) {
        self.weatherServiceType = weatherServiceType
        self.coreDataServiceType = coreDataServiceType
    }
  
    // MARK: - Methods
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            if let weakSelf = self {
                switch event {
                case .viewDidLoad:
                    self?.handleGetWeather(city: "Paris")
                case .searchCityWeatherButtonDidTap:
                    print("Bonjour")
                case .forecastWeatherRowDidTap:
                    print("Bonjour")
                }
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
  
    private func handleGetWeather(city: String) {
        /// Launching API call from weatherService.
        weatherServiceType.getWeather(city: city).sink { [weak self] completion in
            /// Receive error publisher which will trigger an event in homeViewController to handle alerts.
            if case .failure(let error) = completion {
                if let error = error as? ApiError {
                    self?.output.send(.fetchWeatherDidFail(error: error))
                }
            }
        } receiveValue: { [weak self] weather in
            /// Receive weatherResponse.
            if let weakSelf = self {
                /// Trigger output event.
                weakSelf.output.send(.fetchWeatherDidSucceed(weather: weather))
                /// Update stored property weathers in view model to communicate with detail view model.
                weakSelf.weathers = weather.mapToWeathersObject()
                
                /// Delete weather entities in database and update with new elements received from api.
                weakSelf.coreDataServiceType.deleteWeatherEntities()
                for weather in weakSelf.weathers {
                    weakSelf.coreDataServiceType.addWeatherEntity(weather: weather)
                }
            }
        }.store(in: &cancellables)
    }
    
    private func populateWeathersWithDatabase() {
        var weather: Weather
        /// Retrieve all stored weather entities from database and map it into Weather object array.
        for entity in coreDataServiceType.retrieveWeatherEntities() {
            weather = entity.mapToWeatherObject()
            self.weathers.append(weather)
        }
    }
}
