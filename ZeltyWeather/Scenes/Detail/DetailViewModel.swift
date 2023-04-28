//
//  DetailViewModel.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation

final class DetailViewModel {
    var selectedWeatherWithImage: WeatherWithImage
    var popToHomeViewController: () -> Void = {}
    
    init(selectedWeatherWithImage: WeatherWithImage) {
        self.selectedWeatherWithImage = selectedWeatherWithImage
    }
}
