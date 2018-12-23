//
//  Weather.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 21/12/2018.
//

import Foundation

class Weather {

    var weatherForecast: [WeatherForecast]
    var currentCondition: [CurrentCondition]
    
    var request: [Request]

    required init(weatherForecast: [WeatherForecast], currentCondition: [CurrentCondition], request: [Request]) {
        self.weatherForecast = weatherForecast
        self.currentCondition = currentCondition
        self.request = request

    }

}

struct CurrentCondition {
    var cloudcover: String
    var FeelsLikeC: String
    var FeelsLikeF: String
    var humidity: String
    var observation_time: String
    var precipMM: String
    var pressure: String
    var temp_C: String
    var temp_F: String
    var visibility: String
    var weatherCode: String
    var weatherDesc: [WeatherDesc]
    var weatherIconUrl: [WeatherIcon]
    var winddir16Point: String
    var winddirDegree: String
    var windspeedKmph: String
    var windspeedMiles: String
}

struct WeatherIcon {
    var urlIcon : String

}

struct WeatherDesc {
    var value : String
    
}

struct Request {
    var type : String
    var query : String
}

struct Astronomy {
    var sunrise : String
    var sunset : String
    var moonrise : String
    var moonset : String
    var moonPhase : String
    var moonIllumination : String
}

struct WeatherForecast {
    var astronomy: [Astronomy]
    var dateWeather : String
    var maxTempC : String
    var minTempC : String
    var maxTempF : String
    var minTempF : String
    var uvIndex : String
    var sunHour : String
    var totalSnow : String
}


