//
//  WeatherModel.swift
//  Clima
//
//  Created by Dimitris on 20/03/2023.
//

import Foundation

struct WeatherModel {
    let conditionId : Int
    let cityName: String
    let temperature: Double
    let feelsLike: Double

    var temperatureS: String {
        return String(format: "%.1f",temperature)
    }
    var feelsLikeS: String {
        return String(format: "%.1f",feelsLike)
    }
    var conditionName: String {
        //see https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...802:
            return "cloud.sun"
        case 803...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}
