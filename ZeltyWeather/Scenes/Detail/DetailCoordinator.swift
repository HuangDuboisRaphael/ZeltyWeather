//
//  DetailCoordinator.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import UIKit

final class DetailCoordinator: BaseCoordinator {
    private let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    /// Start method to push HomeViewController as first entry of the navigation stack.
    override func start() {
        let viewController = DetailViewController()
        viewController.viewModel = viewModel
        viewModel.popToHomeViewController = removeDetailCoordinator
        
        parentCoordinator?.navigationController.pushViewController(viewController, animated: false)
    }
    
    private func removeDetailCoordinator() {
        didFinish(coordinator: self)
        parentCoordinator?.navigationController.popViewController(animated: false)
    }
}
