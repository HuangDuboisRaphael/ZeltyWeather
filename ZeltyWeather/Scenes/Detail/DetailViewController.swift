//
//  DetailViewController.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel?
    
    let backButton = UIButton(type: .custom)
    let mainVerticalStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    @objc func backButtonPressed() {
        viewModel?.popToHomeViewController()
    }
}

extension DetailViewController {
    
    func setUpUI() {
        setbackButton()
        setUpMainVerticalStackView()
        setUpTopVerticalStackView()
        setUpBottomVerticalStackView()
        setDateLabel()
    }
    
    private func setbackButton() {
        /// Remove default back button, insert new one in white and resized. Use of coordinators to remove any navigation methods from the view controller to respect the single responsibility principle.
        let image = UIImage(systemName: "chevron.left")?.resize(to: CGSize(width: 26, height: 26)).withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func setUpMainVerticalStackView() {
        /// Implement mainVerticalStackView.
        mainVerticalStackView.axis = .vertical
        mainVerticalStackView.spacing = 70
        mainVerticalStackView.alignment = .center
        view.addSubview(mainVerticalStackView)
        mainVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        mainVerticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainVerticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setUpTopVerticalStackView() {
        /// Implement topVerticalStackView.
        let topVerticalStackView: UIStackView
        topVerticalStackView = UIStackView()
        topVerticalStackView.axis = .vertical
        topVerticalStackView.alignment = .center
        topVerticalStackView.spacing = 0
        mainVerticalStackView.addArrangedSubview(topVerticalStackView)
        
        /// Implement horizontalSatckView.
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 15
        topVerticalStackView.addArrangedSubview(horizontalStackView)
        
        // Implement cityLabel.
        let cityLabel = UILabel()
        cityLabel.textColor = .white
        cityLabel.font = UIFont(name: "Arial-BoldMT", size: 35)
        cityLabel.text = viewModel?.selectedWeatherWithImage.city.name
        horizontalStackView.addArrangedSubview(cityLabel)
        
        // Implement hyphenLabel.
        let hyphenLabel = UILabel()
        hyphenLabel.textColor = .white
        hyphenLabel.font = UIFont(name: "Arial-BoldMT", size: 35)
        hyphenLabel.text = ":"
        horizontalStackView.addArrangedSubview(hyphenLabel)
        
        // Implement temperatureLabel.
        let temperatureLabel = UILabel()
        temperatureLabel.textColor = .white
        temperatureLabel.font = UIFont(name: "Arial-BoldMT", size: 35)
        temperatureLabel.text = viewModel?.selectedWeatherWithImage.temperature
        horizontalStackView.addArrangedSubview(temperatureLabel)
        
        // Implement weatherImage.
        let weatherImage = UIImageView()
        weatherImage.image = viewModel?.selectedWeatherWithImage.image
        topVerticalStackView.addArrangedSubview(weatherImage)
        
        // Implement descriptionLabel.
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont(name: "Arial-BoldMT", size: 25)
        descriptionLabel.text = viewModel?.selectedWeatherWithImage.description
        topVerticalStackView.addArrangedSubview(descriptionLabel)
    }
    
    func setUpBottomVerticalStackView() {
        /// Implement bottomVerticalStackView.
        let bottomVerticalStackView: UIStackView
        bottomVerticalStackView = UIStackView()
        bottomVerticalStackView.axis = .vertical
        bottomVerticalStackView.alignment = .center
        bottomVerticalStackView.spacing = 0
        mainVerticalStackView.addArrangedSubview(bottomVerticalStackView)
        
        /// Implement feelsLikeLabel.
        let feelsLikeLabel = UILabel()
        feelsLikeLabel.textColor = .white
        feelsLikeLabel.font = UIFont(name: "Arial-BoldMT", size: 13)
        feelsLikeLabel.text = "Température ressentie: " + "\(viewModel?.selectedWeatherWithImage.feelsLike ?? "")"
        bottomVerticalStackView.addArrangedSubview(feelsLikeLabel)
        
        /// Implement detailedDescriptionLabel.
        let detailedDescriptionLabel = UILabel()
        detailedDescriptionLabel.textColor = .white
        detailedDescriptionLabel.font = UIFont(name: "Arial-BoldMT", size: 13)
        detailedDescriptionLabel.text = "Météo détaillée: " + "\(viewModel?.selectedWeatherWithImage.detailedDecription ?? "")"
        bottomVerticalStackView.addArrangedSubview(detailedDescriptionLabel)
        
        /// Implement humidityLabel.
        let humidityLabel = UILabel()
        humidityLabel.textColor = .white
        humidityLabel.font = UIFont(name: "Arial-BoldMT", size: 13)
        humidityLabel.text = "Humidité: " + "\(viewModel?.selectedWeatherWithImage.humidity ?? "")"
        bottomVerticalStackView.addArrangedSubview(humidityLabel)
        
        /// Implement cloudLabel.
        let cloudLabel = UILabel()
        cloudLabel.textColor = .white
        cloudLabel.font = UIFont(name: "Arial-BoldMT", size: 13)
        cloudLabel.text = "Nuage: " + "\(viewModel?.selectedWeatherWithImage.cloud ?? "")"
        bottomVerticalStackView.addArrangedSubview(cloudLabel)
        
        /// Implement windLabel.
        let windLabel = UILabel()
        windLabel.textColor = .white
        windLabel.font = UIFont(name: "Arial-BoldMT", size: 13)
        windLabel.text = "Vent: " + "\(viewModel?.selectedWeatherWithImage.wind ?? "")"
        bottomVerticalStackView.addArrangedSubview(windLabel)
        
        /// Implement pressureLabel.
        let pressureLabel = UILabel()
        pressureLabel.textColor = .white
        pressureLabel.font = UIFont(name: "Arial-BoldMT", size: 13)
        pressureLabel.text = "Pression atmosphérique: " + "\(viewModel?.selectedWeatherWithImage.pressure ?? "")"
        bottomVerticalStackView.addArrangedSubview(pressureLabel)
        
        /// Implement sunriseLabel.
        let sunriseLabel = UILabel()
        sunriseLabel.textColor = .white
        sunriseLabel.font = UIFont(name: "Arial-BoldMT", size: 13)
        sunriseLabel.text = "Lever du soleil: " + "\(viewModel?.selectedWeatherWithImage.city.sunrise ?? "")"
        bottomVerticalStackView.addArrangedSubview(sunriseLabel)
        
        /// Implement sunsetLabel.
        let sunsetLabel = UILabel()
        sunsetLabel.textColor = .white
        sunsetLabel.font = UIFont(name: "Arial-BoldMT", size: 13)
        sunsetLabel.text = "Coucher du soleil: " + "\(viewModel?.selectedWeatherWithImage.city.sunset ?? "")"
        bottomVerticalStackView.addArrangedSubview(sunsetLabel)
        
        /// Implement populationLabel.
        let populationLabel = UILabel()
        populationLabel.textColor = .white
        populationLabel.font = UIFont(name: "Arial-BoldMT", size: 13)
        populationLabel.text = "Population: " + "\(viewModel?.selectedWeatherWithImage.city.population ?? "")"
        bottomVerticalStackView.addArrangedSubview(populationLabel)
    }
    
    func setDateLabel() {
        /// Implement dateLabel.
        let dateLabel = UILabel()
        dateLabel.textColor = .gray
        dateLabel.font = UIFont(name: "Arial-BoldMT", size: 30)
        dateLabel.text = viewModel?.selectedWeatherWithImage.date
        mainVerticalStackView.addArrangedSubview(dateLabel)
    }
}
