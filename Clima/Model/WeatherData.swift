//
//  WeatherData.swift
//  Clima
//
//  Created by Dimitris on 18/03/2023.
//

import Foundation

// OpenWeatherMap API
// See https://openweathermap.org/current

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String            //TODO: Hex number represenation
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double

}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    
}

struct Clouds: Decodable {
    let all: Int
}

struct Sys: Decodable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct WeatherData: Decodable {
    let coord: Coord
    let weather: [Weather]
    
    let main: Main
    let base: String
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
