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
    let cityTextField = UITextField()
    let searchCityButton = UIButton()
    var weatherTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
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
                    case .fetchWeatherDidSucceed:
                        print(self?.viewModel?.weathers.count)
                        self?.weatherTableView.reloadData()
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
        setWeatherTableView()
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
    
    private func setWeatherTableView() {
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.separatorStyle = .singleLine
        weatherTableView.separatorColor = UIColor.gray
        weatherTableView.backgroundColor = .clear
        weatherTableView.isScrollEnabled = true
        
        view.addSubview(weatherTableView)
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 10.0),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0)
        ])

    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.weathersWithImage.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weatherTableView.register(WeatherCell.self, forCellReuseIdentifier: "weatherCell")

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell else {
            fatalError("Unable to create weather cell")
        }
        cell.selectionStyle = .none
        cell.weather = viewModel?.weathersWithImage[indexPath.row]        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
