//
//  HomeViewController.swift
//  ZeltyWeather
//
//  Created by Raphaël Huang-Dubois on 27/04/2023.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    // Related to view model.
    private let input: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    var viewModel: HomeViewModel?
    
    // UI properties.
    var cityTextField = UITextField()
    var searchCityButton = UIButton()
    var weatherTableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var errorAlert = UIAlertController()

    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bind()
        input.send(.viewDidLoad)
    }
    
    // MARK: - Methods
    
    // Bind method which transforms inputs received from view model into UI outputs.
    private func bind() {
        if let viewModel = viewModel {
            let output = viewModel.transform(input: input.eraseToAnyPublisher())
            output
                .receive(on: DispatchQueue.main)
                .sink { [weak self] event in
                    if let weakSelf = self {
                        switch event {
                        case .fetchWeatherDidSucceed:
                            /// Add dispatch queue of one second for the user to notice activity indicator and understand that the call is being made.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                weakSelf.view.endEditing(true)
                                weakSelf.weatherTableView.reloadData()
                                weakSelf.activityIndicator.stopAnimating()
                                weakSelf.weatherTableView.isHidden = false
                            }
                        case .fetchWeatherDidFail(let error):
                            weakSelf.activityIndicator.stopAnimating()
                            weakSelf.weatherTableView.isHidden = false
                            /// Showing personnalized alert controller messages for every error cases.
                            switch error {
                            case .noInternet:
                                weakSelf.presentAlert(message: "Veuillez vérifier votre connexion internet.")
                            case .badRequest:
                                weakSelf.presentAlert(message: "Veuillez vérifier l'orthographe de la ville renseignée.")
                            case .badServerResponse, .invalidResponse:
                                weakSelf.presentAlert(message: "Serveur en cours de maintenance, veuillez essayer ultérieurement.")
                            case .badUrl, .badParsing:
                                weakSelf.presentAlert(message: "Veuillez contacter les administrateurs.")
                            }
                        }
                    }
                }.store(in: &cancellables)
        }
    }

    // Implement the button's action
    @objc func searchCityButtonDidTap() {
        if let text = cityTextField.text {
            weatherTableView.isHidden = true
            activityIndicator.startAnimating()
            input.send(.searchCityWeatherButtonDidTap(city: text))
        }
    }
    
    // To dismiss the keyboard.
    @objc func didTapView() {
        view.endEditing(true)
    }
    
    private func presentAlert(message: String) {
        errorAlert = UIAlertController(title: "Erreur", message: message, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
}

// All UI related.
extension HomeViewController {
    
    func setUpUI() {
        setActivityIndicatorView()
        setHorizontalStackView()
        setWeatherTableView()
    }
    
    private func setActivityIndicatorView() {
        activityIndicator.center = view.center
        activityIndicator.color = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func setHorizontalStackView() {
        /// CityTextField frame and properties.
        cityTextField = UITextField(frame: CGRect(x: 20, y: 80, width: UIScreen.main.bounds.width * 0.75, height: 45))
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
        /// Add to parent view.
        view.addSubview(cityTextField)
        
        /// To dismiss keyboard when user touches the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGesture)
        
        /// SearchCityButton frame properties.
        searchCityButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: 80, width: 30, height: 45))
        searchCityButton.addTarget(self, action: #selector(searchCityButtonDidTap), for: .touchUpInside)
        /// Set button image with white color for normal and disabled state.
        let originalImage = UIImage(systemName: "magnifyingglass")
        let largerImage = originalImage?.resize(to: CGSize(width: 31, height: 30))
        let tintedDefaultImage = largerImage?.withTintColor(UIColor.white)
        let tintedDisabledImage = largerImage?.withTintColor(UIColor.white.withAlphaComponent(0.2))
        searchCityButton.setImage(tintedDefaultImage, for: .normal)
        searchCityButton.setImage(tintedDisabledImage, for: .disabled)
        /// Add to parent view.
        view.addSubview(searchCityButton)
    }
    
    private func setWeatherTableView() {
        /// Set weatherTableView properties.
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.separatorStyle = .singleLine
        weatherTableView.separatorColor = UIColor.gray
        weatherTableView.backgroundColor = .clear
        
        /// Add it to parent view and set auto layout constraints.
        view.addSubview(weatherTableView)
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 30.0),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0)
        ])
    }
}

// Implement data source and delegate methods for weatherTableView.
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// Number of rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.weathersWithImage.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Use of custom WeatherCell.
        weatherTableView.register(WeatherCell.self, forCellReuseIdentifier: "weatherCell")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell else {
            fatalError("Unable to create weather cell")
        }
        cell.selectionStyle = .none
        cell.weather = viewModel?.weathersWithImage[indexPath.row]        
        return cell
    }
    
    /// Height row.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    /// DidSelectRow method.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
