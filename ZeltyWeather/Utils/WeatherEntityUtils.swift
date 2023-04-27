//
//  WeatherEntityUtils.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation

extension WeatherEntity {
    
    func mapToWeatherObject() -> Weather {
        var weather: Weather = Weather(date: "", hour: "", temperature: "", feelsLike: "", pressure: "", humidity: "", description: "", detailedDecription: "", image: "", cloud: "", wind: "", city: City(name: "", population: "", sunrise: "", sunset: ""))
  
        weather.date = self.date ?? ""
        weather.hour = self.hour ?? ""
        weather.temperature = self.temperature ?? ""
        weather.feelsLike = self.feelsLike ?? ""
        weather.pressure = self.pressure ?? ""
        weather.humidity = self.humidity ?? ""
        weather.description = self.weatherDescription ?? ""
        weather.detailedDecription = self.detailedWeatherDescription ?? ""
        weather.image = self.image ?? ""
        weather.cloud = self.cloud ?? ""
        weather.wind = self.wind ?? ""
        weather.city.name = self.name ?? ""
        weather.city.population = self.population ?? ""
        weather.city.sunrise = self.sunrise ?? ""
        weather.city.sunset = self.sunset ?? ""

        return weather
    }
}
