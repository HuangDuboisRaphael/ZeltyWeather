//
//  HomeCoordinator.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import UIKit

// HomeCoodinator with viewModel initialization, neither the view model nor the view controller know the coordinator for better abstraction.
final class HomeCoordinator: BaseCoordinator {
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    /// Start method to push HomeViewController as first entry of the navigation stack.
    override func start() {
        let viewController = HomeViewController()
        viewController.viewModel = viewModel
        viewModel.pushToDetailViewController = pushToDetailCoordinator
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func pushToDetailCoordinator() {
        if let selectedWeather = self.viewModel.selectedWeatherWithImage {
            self.start(coordinator: DetailCoordinator(viewModel: DetailViewModel(selectedWeatherWithImage: selectedWeather)))
        }
    }
}
