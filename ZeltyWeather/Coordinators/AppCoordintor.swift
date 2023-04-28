//
//  AppCoordintor.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import UIKit

// Coordinator to use in AppDelegate which would set the UIWindow with AppCoordinator navigation controller and delegate the flow to HomeCoordinator.
final class AppCoordinator: BaseCoordinator {
    
    override func start() {
        removeChildCoordinators()
        
        let coordinator = HomeCoordinator(viewModel: HomeViewModel())
        coordinator.navigationController = self.navigationController
        coordinator.start()
    }
}
