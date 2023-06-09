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
        case searchCityWeatherButtonDidTap(city: String)
        case forecastWeatherRowDidTap
    }
  
    /// Output events following input events.
    enum Output {
        case fetchWeatherDidSucceed
        case fetchWeatherDidFail(error: ApiError)
    }
    
    // MARK: - Properties and initialization
  
    /// Abstraction of type, use of protocol for mocking purposes.
    private let weatherServiceType: WeatherServiceType
    private let coreDataServiceType: CoreDataServiceType
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    /// Navigation method initialized in home coordinator.
    var pushToDetailViewController: () -> Void = {}
    /// Weather Api data mapped to WeatherResponse object and saved in database.
    private var weathers: [Weather] = []
    /// WeatherWithImage mapped with Weather object  and used as data source for the main table view. The difference is that weather has string url whereas weatherWithImage images are already downloaded.
    var weathersWithImage: [WeatherWithImage] = []
    /// The weather chosen by user from the main table view. It will be passed down to DetailViewModel.
    var selectedWeatherWithImage: WeatherWithImage?
  
    init(weatherServiceType: WeatherServiceType = WeatherService(), coreDataServiceType: CoreDataServiceType = CoreDataService()) {
        self.weatherServiceType = weatherServiceType
        self.coreDataServiceType = coreDataServiceType
    }
  
    // MARK: - Methods
    
    // Bind method which transforms UX inputs received from view controller into concrete data.
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            if let weakSelf = self {
                switch event {
                case .viewDidLoad:
                    self?.populateWeathers(city: "Paris")
                case .searchCityWeatherButtonDidTap(let city):
                    if NetworkUtils.isConnectedToInternet() {
                        weakSelf.handleGetWeather(city: city)
                    } else {
                        self?.output.send(.fetchWeatherDidFail(error: ApiError.noInternet))
                    }
                case .forecastWeatherRowDidTap:
                    weakSelf.pushToDetailViewController()
                }
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    // Check internet connection and populate accordingly weather array.
    private func populateWeathers(city: String) {
        if NetworkUtils.isConnectedToInternet() {
            self.handleGetWeather(city: city)
        } else {
            self.populateWeathersWithDatabase()
        }
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
                /// Remove all arrays element if user makes several calls.
                weakSelf.weathers.removeAll()
                weakSelf.weathersWithImage.removeAll()
                
                /// Update stored property weathers in view model to communicate with detail view model.
                weakSelf.weathers = weather.mapToWeathersObject()
                
                /// Delete weather entities in database and update with new elements received from api.
                weakSelf.coreDataServiceType.deleteWeatherEntities()
                for weather in weakSelf.weathers {
                    weakSelf.coreDataServiceType.addWeatherEntity(weather: weather)
                }
                
                /// Create array of weathersWithImage.
                let group = DispatchGroup()
                for weather in weakSelf.weathers {
                    group.enter()
                    weather.mapToWeatherWithImageObject { weatherImage in
                        weakSelf.weathersWithImage.append(weatherImage)
                        group.leave()
                    }
                }
                /// Once created, trigger output event.
                group.notify(queue: .main) {
                    weakSelf.output.send(.fetchWeatherDidSucceed)
                }    
            }
        }.store(in: &cancellables)
    }
    
    private func populateWeathersWithDatabase() {
        var weather: Weather
        
        /// Check for entities presence in database.
        if coreDataServiceType.retrieveWeatherEntities().count > 0 {
            /// Retrieve all stored weather entities from database and map it into WeatherImage object array.
            let group = DispatchGroup()
            for entity in coreDataServiceType.retrieveWeatherEntities() {
                group.enter()
                weather = entity.mapToWeatherObject()
                weather.mapToWeatherWithImageObject { weatherImage in
                    self.weathersWithImage.append(weatherImage)
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.output.send(.fetchWeatherDidSucceed)
            }
        } else {
            /// If no entity and no connection internet, send output did fail.
            self.output.send(.fetchWeatherDidFail(error: .noInternet))
        }
    }
}
