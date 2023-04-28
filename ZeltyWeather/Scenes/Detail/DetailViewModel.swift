//
//  DetailViewModel.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import Foundation

final class DetailViewModel {
    /// SelectedWeatherImage from table view and communicated through coordinators.
    var selectedWeatherWithImage: WeatherWithImage
    /// Navigation method initialized in DetailCoordinator.
    var popToHomeViewController: () -> Void = {}
    
    init(selectedWeatherWithImage: WeatherWithImage) {
        self.selectedWeatherWithImage = selectedWeatherWithImage
    }
}
