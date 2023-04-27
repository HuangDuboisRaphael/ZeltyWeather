//
//  HomeViewController.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel?
    private let input: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("My Button", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        view.addSubview(button)
        bind()
        input.send(.viewDidLoad)
    }
    
    private func bind() {
        if let viewModel = viewModel {
            let output = viewModel.transform(input: input.eraseToAnyPublisher())
            output
                .receive(on: DispatchQueue.main)
                .sink { [weak self] event in
                    switch event {
                    case .fetchWeatherDidSucceed (let weather):
                        print(weather)
                    case .fetchWeatherDidFail(let error):
                        print(error)
                    }
                }.store(in: &cancellables)
        }
    }
}
