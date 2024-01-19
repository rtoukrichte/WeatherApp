//
//  Constants.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import Foundation

struct Constants {
    
    struct Keys {
        static let weatherAPIKey = "159dfcf892c7316bbac5573d06015e70"
    }
    
    static let baseURL = "https://api.openweathermap.org/"
    static let dataWeatherURL = baseURL + "data/2.5/weather"
    
    static var defaultCities = [ City(name: "Paris", longitude: 2.333333, latitude: 48.866667),
                                 City(name: "Lyon", longitude: 2.333333, latitude: 48.866667),
                                 City(name: "Toulouse", longitude: 2.333333, latitude: 48.866667),
                                 City(name: "Lille", longitude: 2.333333, latitude: 48.866667)
                             ]
    
}
