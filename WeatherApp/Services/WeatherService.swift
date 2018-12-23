//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 21/12/2018.
//

import Foundation
import Alamofire

class WeatherService {
    
    // MARK: - singleton instance
    static let sharedInstance = WeatherService()
    
    static private let weatherAPIKey = "21434342fff44261b28204005182212"
    static let infosBaseUrl = "https://api.worldweatheronline.com"
    
    lazy var manager = NetworkReachabilityManager(host: "api.worldweatheronline.com")
    
    
    
    // https://api.worldweatheronline.com/premium/v1/weather.ashx?key=21434342fff44261b28204005182212&q=Casablanca&format=json&num_of_days=5
    
    // MARK: - Load Informations From Weather WebService
    func loadInfo(cityName:String, completionHandler:@escaping (Bool, Weather?) -> ()) {
        
        let url = WeatherService.infosBaseUrl + "/premium/v1/weather.ashx"
        
        let parameters: Parameters = ["key": WeatherService.weatherAPIKey,
                                      "q": cityName,
                                      "format": "json",
                                      "num_of_days": "5"]
        
        Alamofire.request(url, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseJSON { response in

                switch response.result {
                    
                case let .success(value):
                    
                    print("@@@@@@ case Success")
                    if let result = value as? NSDictionary {
                        
                        let managerWeather = WeatherManager.init(weatherDictionary: result)
                        
                        let weather = managerWeather.serialize()
                        
                        //print("@@@@@@@@@ Result ====> ", result)
                        
                        completionHandler(true, weather)
                        
                    } else {
                        completionHandler(false, nil)
                    }
                    
                case .failure(let error):
                    print("@@@@@@@ Error == ", error.localizedDescription)
                    completionHandler(false, nil)
                }
        }
    }
    
    // MARK: - Network Reachability
    func isNetworkReachable() -> Bool {
        return manager?.isReachable ?? false
    }
}
