//
//  Weather.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import Foundation

struct WeatherData: Codable {
    
    let name: String?
    let cod: Int?
    let timezone: Double?
    let id: Double?
    
    let coord: Coord?
    let weather: [Weather]?
    let main: MainData?
    let wind: Wind?
    let clouds: Clouds?
    let sys: Sys?
    
    let dt: Double?
    let visibility: Double?
    let base: String?
    let rain: Rain?
    let snow: Snow?
    
    struct Coord: Codable {
        let longitude : Float?
        let latitude : Float?
        
        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case latitude = "lat"
        }
    }
    
    struct Weather: Codable {
        let id: Double?
        let main: String?
        let description: String?
        let icon: String?
    }
    
    struct MainData: Codable {
        let temp: Double?
        let minTemp: Float?
        let maxTemp: Float?
        let feelsLikeTemp: Float?
        let pressure: Float?
        let humidity: Double?
        let seaLevel: Double?
        let grndLevel: Double?
        
        enum CodingKeys: String, CodingKey {
            case temp, humidity, pressure
            case minTemp = "temp_min"
            case maxTemp = "temp_max"
            case feelsLikeTemp = "feels_like"
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    struct Wind: Codable {
        let speed: Float?
        let deg: Double?
        let gust: Float?
    }
    
    struct Clouds: Codable {
        let all: Double?
    }
    
    struct Sys: Codable {
        let type: Int?
        let id: Double?
        let country: String?
        let sunrise: Double?
        let sunset: Double?
    }
    
    struct Rain: Codable {
        let rain1H: Double?
        let rain3H: Double?
        
        enum CodingKeys: String, CodingKey {
            case rain1H = "1h"
            case rain3H = "3h"
        }
    }
    
    struct Snow: Codable {
        let snow1H: Double?
        let snow3H: Double?
        
        enum CodingKeys: String, CodingKey {
            case snow1H = "1h"
            case snow3H = "3h"
        }
    }
    
}
