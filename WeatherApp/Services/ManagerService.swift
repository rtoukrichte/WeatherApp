//
//  ManagerService.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import Foundation

final class ManagerService {
    
    // MARK: - singleton instance
    static let shared = ManagerService()
    
    private init() {}
    
    // MARK: - Load Informations From Weather WebService
    func loadInfos(cityName:String, completionHandler:@escaping (Bool, WeatherData?, Error?) -> ()) {
        
        let paramsUrl = String(format: "?q=%@&appid=%@&units=%@", cityName, Constants.Keys.weatherAPIKey, "metric")
        
        guard let apiURL = URL(string: String(format: "%@%@", Constants.dataWeatherURL, paramsUrl))
        else { return }
        
        if Reachability.isConnectedToNetwork() {
            URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
                
                guard let data = data else { return }
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    
                    let newData = NSKeyedArchiver.archivedData(withRootObject: data)
                    UserDefaults.standard.set(newData, forKey: cityName)
                    UserDefaults.standard.synchronize()
                    
                    completionHandler(true, weatherData, nil)
                    
                } catch (let decodingError) {
                    debugPrint(decodingError)
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 500 {
                            completionHandler(false, nil, NSError(domain: "com.server.error", code: 500, userInfo:[NSLocalizedDescriptionKey : "Internal server error !"]))
                        }
                    }
                    completionHandler(false, nil, NSError(domain: "com.unexpected.error", code: 0, userInfo:[NSLocalizedDescriptionKey : "Data not available, please try later"]))
                }
            }.resume()
        }
        else {
            guard let decodedData = UserDefaults.standard.object(forKey: cityName) as? NSData,
                  let loadedWeatherData = NSKeyedUnarchiver.unarchiveObject(with: decodedData as Data) as? Data
            else {
                completionHandler(false, nil, NSError(domain: "com.offline.error", code: -1, userInfo:[NSLocalizedDescriptionKey : "Please check your internet connection and try again"]))
                return
            }
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: loadedWeatherData)
                completionHandler(true, weatherData, nil)
            }
            catch (let decodingError) {
                debugPrint(decodingError)
                completionHandler(false, nil, NSError(domain: "com.offline.error", code: -1, userInfo:[NSLocalizedDescriptionKey : "Please check your internet connection and try again"]))
            }
        }
    }
}
