//
//  AppCoordintor.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import UIKit

// Coordinator to use in AppDelegate which would set the UIWindow with HomeCoordinator navigation controller and set HomeViewController as the entry view.
class AppCoordinator: BaseCoordinator {
    
    override func start() {
        let viewController = HomeViewController()
        self.navigationController.pushViewController(viewController, animated: false)
    }
}
