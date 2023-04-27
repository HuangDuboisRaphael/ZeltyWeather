//
//  WeatherResponseUtils.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation

extension WeatherResponse {
    
    func mapToWeathersObject() -> [Weather] {
        /// Weathers array to return
        var weathers: [Weather] = []
        /// Weather property used to populate weathers array.
        var weather: Weather = Weather(date: "", hour: "", temperature: "", feelsLike: "", pressure: "", humidity: "", description: "", detailedDecription: "", image: "", cloud: "", wind: "", city: City(name: "", population: "", sunrise: "", sunset: ""))
        /// Keep in memory the first weather of today if it's later than 12:00.
        var todayWeather: Weather = Weather(date: "", hour: "", temperature: "", feelsLike: "", pressure: "", humidity: "", description: "", detailedDecription: "", image: "", cloud: "", wind: "", city: City(name: "", population: "", sunrise: "", sunset: ""))
        
        /// Use of dispatch group to wait for loop to finish before going to next fragment of code.
        let group = DispatchGroup()
        
        /// Populate weathers array with WeatherResponse data.
        for forecast in self.forecasts {
            group.enter()
            weather.date = String(forecast.date.convertDateToReadableTime(for: self.city.name))
            weather.hour = String(forecast.dateText.suffix(8))
            weather.temperature = String(Int(forecast.temperature.temp.rounded())) + "C"
            weather.feelsLike = String(Int(forecast.temperature.feelsLike.rounded())) + "C"
            weather.pressure = String(forecast.temperature.pressure) + " hPa"
            weather.humidity = String(forecast.temperature.humidity) + "%"
            weather.description = forecast.weather[0].main.translateWeatherDescription()
            weather.detailedDecription = forecast.weather[0].description.capitalized
            weather.image = forecast.weather[0].icon
            weather.cloud = String(forecast.clouds.all) + "%"
            weather.wind = String(forecast.wind.speed) + " m/s"
            weather.city.name = self.city.name
            weather.city.population = String(self.city.population.formattedWithSeparator) + " habitants"
            weather.city.sunrise = String(self.city.sunrise.convertUnixToReadableTime(for: self.city.name))
            weather.city.sunset = String(self.city.sunset.convertUnixToReadableTime(for: self.city.name))
            weathers.append(weather)
            group.leave()
        }
        
        /// Use of semaphore to wait for the completion to finish before returning the value.
        let semaphore = DispatchSemaphore(value: 0)
        
        group.notify(queue: .main) {
            /// Today weather keeping value in memory.
            todayWeather = weathers[0]
            
            /// Keep all the weather object having 12:00:00 as hour and limited as five days.
            let hourToKeep = "12:00:00"
            let result = weathers.filter { $0.hour == hourToKeep }
            weathers.removeAll()
            weathers = Array(result.prefix(5))

            /// Check if the hour is not later than noon, otherwise today won't be counted and need to insert it manually.
            if weathers[0].date != getTodayInString() {
                weathers.insert(todayWeather, at: 0)
                weathers.removeLast()
            }
            semaphore.signal()
        }
        semaphore.wait()
        return weathers
    }

    private func getTodayInString() -> String {
        /// Get today's date to compare with the formatted first weather index hour.
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "fr_FR")

        let today = dateFormatter.string(from: Date())
        
        return today
    }
}
