//
//  WeatherUtils.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 28/04/2023.
//

import Foundation
import UIKit

extension Weather {
    func mapToWeatherWithImageObject(completion: @escaping ((WeatherWithImage) -> Void)) {
        let imageService = ImageService()
        var weatherWithImage: WeatherWithImage = WeatherWithImage(date: "", hour: "", temperature: "", feelsLike: "", pressure: "", humidity: "", description: "", detailedDecription: "", image: UIImage(), cloud: "", wind: "", city: City(name: "", population: "", sunrise: "", sunset: ""))

        weatherWithImage.date = self.date
        weatherWithImage.hour = self.hour
        weatherWithImage.temperature = self.temperature
        weatherWithImage.feelsLike = self.feelsLike
        weatherWithImage.pressure = self.pressure
        weatherWithImage.humidity = self.humidity
        weatherWithImage.description = self.description
        weatherWithImage.detailedDecription = self.detailedDecription
        weatherWithImage.cloud = self.cloud
        weatherWithImage.wind = self.wind
        weatherWithImage.city.name = self.city.name
        weatherWithImage.city.population = self.city.population
        weatherWithImage.city.sunrise = self.city.sunrise
        weatherWithImage.city.sunset = self.city.sunset
        imageService.retrieveImage(url: "https://openweathermap.org/img/wn/" + "\(self.image)" + "@2x.png") { image in
            weatherWithImage.image = image
            completion(weatherWithImage)
        }
    }
}
