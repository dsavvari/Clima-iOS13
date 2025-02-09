//
//  WeatherManager.swift
//  Clima
//
//  Created by Dimitris on 17/03/2023.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=<YourKEY>&units=metric"
   
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        //If the cityName has multiple words seperated by spaces, it will require to convert those spaces to '+', otherwise the url conversion will fail during performRequest
        let urlString = "\(weatherURL)&q=\(cityName.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil))"
        print(urlString)
        performRequest(urlString)
    }

    func fetchWeather(lat: String,  lon: String) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        print(urlString)
        performRequest(urlString)
    }

    func performRequest(_ urlString: String) {
        if let url =  URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task  = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("\(self): Error no weather data")
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safedata = data {
                    if let weather = parseJSON(data: safedata) {
                        self.delegate?.didUpdateWeather(self, weather)
                    } else {
                        print("\(self): Error failed to parseJson")
                        //self.delegate?.didFailWithError(error!)
                    }
                } else {
                    print("\(self): Error failed to retrieve weathermap data")
                    self.delegate?.didFailWithError(error!)
                }
            }
            task.resume()
        } else {
            print("\(self): Error in URL conversion")
        }
    }
    
    func parseJSON(data:Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let feels_like = decodedData.main.feels_like
            let name = decodedData.name
            return WeatherModel(conditionId: id, cityName: name, temperature: temp, feelsLike: feels_like)
        
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    

}
