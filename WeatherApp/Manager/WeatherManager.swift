//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 22/12/2018.
//

import Foundation

class WeatherManager {
    
    var weather: Weather? = nil
    var weatherDictionary: NSDictionary
    
    required init(weatherDictionary: NSDictionary) {
        self.weatherDictionary = weatherDictionary
    }
    
    // MARK:- Weather serialize
    func serialize() -> Weather? {
        
        print("@@@@@ start serializing ...")
        print("weather dictionair ==== ", weatherDictionary)
        var condition: [CurrentCondition]? = nil
        var weatherForecast: [WeatherForecast]? = nil
        var request: [Request]? = nil
        
        if let dataDictionary = weatherDictionary["data"] as? NSDictionary {
            
            //Request
            if let value = dataDictionary["request"] as? [NSDictionary] {
                request = value.map { values in
                let type = values["type"] as! String
                let query = values["query"] as! String
                
                return Request(type: type, query: query)
                }
            }
                    
            if let itemDictionary = dataDictionary["current_condition"] as? [NSDictionary] {
                
                //condition
                
                condition = itemDictionary.map { value in
                    //                            let dateFormatter = DateFormatter()
                    //                            dateFormatter.dateFormat = "E, dd MMM yyyy hh:mm a zzz"
                    //                            let weatherIcon = WeatherIcon(urlIcon: value["url"]! as! String)
                    //                            let date = dateFormatter.date(from: value["date"]! as! String)
                    
                    
                    
                    let cloudcover = value["cloudcover"]! as! String
                    let FeelsLikeC = value["FeelsLikeC"]! as! String
                    let FeelsLikeF = value["FeelsLikeF"]! as! String
                    let humidity = value["humidity"]! as! String
                    let observation_time = value["observation_time"]! as! String
                    let precipMM = value["precipMM"]! as! String
                    let pressure = value["pressure"]! as! String
                    let temp_C = value["temp_C"]! as! String
                    let temp_F = value["temp_F"]! as! String
                    let visibility = value["visibility"]! as! String
                    let weatherCode = value["weatherCode"]! as! String
                    
                    let weatherIconDict = value.object(forKey: "WeatherIconUrl") as? [NSDictionary]
                    let weatherDescDict = value.object(forKey: "WeatherDesc") as? [NSDictionary]
                    
                    print("xxxxxx", weatherDescDict)
                    
                    let weatherDesc = WeatherDesc(value: weatherDescDict?.first!.object(forKey: "value") as? String ?? "")
                    let weatherIconUrl = WeatherIcon(urlIcon: weatherIconDict?.first!.object(forKey: "value") as? String ?? "")
                    let winddir16Point = value["winddir16Point"]! as! String
                    let winddirDegree = value["winddirDegree"]! as! String
                    let windspeedKmph = value["windspeedKmph"]! as! String
                    let windspeedMiles = value["windspeedMiles"]! as! String
                    
                    return CurrentCondition(cloudcover: cloudcover, FeelsLikeC: FeelsLikeC, FeelsLikeF: FeelsLikeF, humidity: humidity, observation_time: observation_time, precipMM: precipMM, pressure: pressure, temp_C: temp_C, temp_F: temp_F, visibility: visibility, weatherCode: weatherCode, weatherDesc: [weatherDesc], weatherIconUrl: [weatherIconUrl], winddir16Point: winddir16Point, winddirDegree: winddirDegree, windspeedKmph: windspeedKmph, windspeedMiles: windspeedMiles )
                }
            }
                        
            //Weather Forecast
            if let value = dataDictionary["weather"] as? [NSDictionary] {
                weatherForecast = value.map { forecast in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    //let weatherIcon = WeatherIcon(code: forecast["code"]! as? String ?? "0")
                    //let date = dateFormatter.date(from: forecast["date"]! as? String ?? "none")
                    //                                let day = forecast["day"]! as! String
                    //                                let high = (forecast["high"]! as! String).floatValue
                    //                                let low = (forecast["low"]! as! String).floatValue
                    //                                let text = forecast["text"]! as! String
                    let astronomyDict = forecast["astronomy"] as? [NSDictionary]
                    
                    let astronomy = Astronomy(sunrise: astronomyDict?.first!["sunrise"] as! String, sunset: astronomyDict?.first!["sunset"] as! String, moonrise: astronomyDict?.first!["moonrise"] as! String, moonset: astronomyDict?.first!["moonset"] as! String, moonPhase: astronomyDict?.first!["moon_phase"] as! String, moonIllumination: astronomyDict?.first!["moon_illumination"] as! String)
                    
                    let dateWeather = forecast["date"]! as! String
                    let maxTempC = forecast["maxtempC"]! as! String
                    let minTempC = forecast["mintempC"]! as! String
                    let maxTempF = forecast["maxtempF"]! as! String
                    let minTempF = forecast["mintempF"]! as! String
                    let uvIndex = forecast["uvIndex"]! as! String
                    let sunHour = forecast["sunHour"]! as! String
                    let totalSnow = forecast["totalSnow_cm"]! as! String
                    
                    return WeatherForecast(astronomy: [astronomy], dateWeather: dateWeather, maxTempC: maxTempC, minTempC: minTempC, maxTempF: maxTempF, minTempF: minTempF, uvIndex: uvIndex, sunHour: sunHour, totalSnow: totalSnow)
                }
            }
            
                
        if condition == nil && weatherForecast == nil {
            print("condition or weatherForecast is nil for Weather Dictionary")
            return nil
        } else {
            
            print("@@@@@@@ Finish serializing !!!!!")
            weather = Weather(weatherForecast: weatherForecast!, currentCondition: condition!, request: request!)
        }
                
        
        }
        
        return weather
        
    }// Fin Func
    
}// Fin class
