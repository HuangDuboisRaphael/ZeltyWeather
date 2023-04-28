//
//  WeatherCell.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 28/04/2023.
//

import UIKit

final class WeatherCell: UITableViewCell {
    
    var weather: WeatherWithImage? {
        didSet {
            guard let weather = weather else { return }
            cityLabel.text = weather.city.name
            temperatureLabel.text = weather.temperature
            weatherImage.image = weather.image
            descriptionLabel.text = weather.description
        }
    }
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        return stackView
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Arial-BoldMT", size: 35)
        return label
    }()
    
    var hyphenLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Arial-BoldMT", size: 35)
        label.text = ":"
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Arial-BoldMT", size: 35)
        return label
    }()
    
    var weatherImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Arial-BoldMT", size: 25)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        backgroundColor = .black
        horizontalStackView.addArrangedSubview(cityLabel)
        horizontalStackView.addArrangedSubview(hyphenLabel)
        horizontalStackView.addArrangedSubview(temperatureLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(weatherImage)
        verticalStackView.addArrangedSubview(descriptionLabel)
        addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
