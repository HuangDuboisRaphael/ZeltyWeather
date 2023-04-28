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
    
    var horizontalStackView = UIStackView()
    var cityTextField = UITextField()
    var searchCityButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("My Button", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        view.addSubview(button)
        setUpUI()
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
                        print("")
                    case .fetchWeatherDidFail(let error):
                        print(error)
                    }
                }.store(in: &cancellables)
        }
    }
}

extension HomeViewController {
    
    func setUpUI() {
        setHorizontalStackView()
    }
    
    private func setHorizontalStackView() {
        /// Use of frame to not restrict cityTextField height.
        horizontalStackView = UIStackView(frame: CGRect(x: view.frame.size.width * 0.04, y: self.view.frame.size.height * 0.07, width: view.frame.size.width * 0.9, height: self.view.frame.size.height * 0.04))
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 30
        
        /// CityTextField properties.
        cityTextField.layer.cornerRadius = 7.0
        cityTextField.layer.borderWidth = 1.0
        cityTextField.layer.borderColor = UIColor.gray.cgColor
        cityTextField.backgroundColor = UIColor.clear
        cityTextField.textColor = UIColor.white
        cityTextField.attributedPlaceholder = NSAttributedString(string: "Paris", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.2)])
        
        /// Add left padding.
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: cityTextField.frame.height))
        cityTextField.leftView = paddingView
        cityTextField.leftViewMode = .always

        /// Set button image with white color for normal and disabled state.
        let originalImage = UIImage(systemName: "magnifyingglass")
        let largerImage = originalImage?.resize(to: CGSize(width: 31, height: 30))
        let tintedDefaultImage = largerImage?.withTintColor(UIColor.white)
        let tintedDisabledImage = largerImage?.withTintColor(UIColor.white.withAlphaComponent(0.2))
        searchCityButton.setImage(tintedDefaultImage, for: .normal)
        searchCityButton.setImage(tintedDisabledImage, for: .disabled)
        
        /// Add subviews to horizontalStackView.
        horizontalStackView.addArrangedSubview(cityTextField)
        horizontalStackView.addArrangedSubview(searchCityButton)
    
        /// Add horizontalStackView to parent view.
        view.addSubview(horizontalStackView)
    }
}
