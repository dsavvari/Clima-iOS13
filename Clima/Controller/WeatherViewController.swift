//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var feelsLike: UILabel!
    
    var weatherManager: WeatherManager = WeatherManager()
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        //print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate
extension WeatherViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city=searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
       searchTextField.text=""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            if textField.text != "" {
                textField.placeholder = "Location Search"
                return true
            }
            else {
                textField.placeholder = "Type Something"
                return false
            }
        }
        else {
            print("not our textfield")
            return true
        }
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
        //print(weather.temperatureS)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureS
            self.feelsLike.text = weather.feelsLikeS
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            print("location lat: \(location.coordinate.latitude) lon: \(location.coordinate.longitude)")
            weatherManager.fetchWeather(lat: String(location.coordinate.latitude), lon: String(location.coordinate.longitude))
        }
        else {
            print("Error in location")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(self) returned with error: \(error)")
    }
}


