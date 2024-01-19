//
//  ServiceManager.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import Foundation
import Combine

enum NetworkError: Error {
    case noConnectionInternet
    case serverError
    case badURL
    case decodingError
    case unknownError
    case requestFailed
}

final class ServiceManager {
    
    // MARK: - singleton instance
    static let shared = ServiceManager()
    
    private init() {}
    
    private var subscriptions = Set<AnyCancellable>()
    
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
                    
                    let newData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
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
            }
            .resume()
        }
        else {
            guard let decodedData = UserDefaults.standard.object(forKey: cityName) as? Data,
                  let loadedWeatherData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSData.self, from: decodedData)
            else {
                completionHandler(false, nil, NSError(domain: "com.offline.error", code: -1, userInfo:[NSLocalizedDescriptionKey : "Please check your internet connection and try again"]))
                return
            }
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: loadedWeatherData as Data)
                completionHandler(true, weatherData, nil)
            }
            catch (let decodingError) {
                debugPrint(decodingError)
                completionHandler(false, nil, NSError(domain: "com.offline.error", code: -1, userInfo:[NSLocalizedDescriptionKey : "Please check your internet connection and try again"]))
            }
        }
    }
    
    
    
    // MARK: - Generic Get method
    func fetch<T: Codable>(from endpoint: String) -> Future<T, NetworkError> {
        
        return Future { [unowned self] promise in
            
            guard let endpointURL = URL(string: endpoint) else {
                return promise(.failure(.badURL))
            }
            
            if Reachability.isConnectedToNetwork() {
                URLSession.shared.dataTaskPublisher(for: endpointURL)
                    .tryMap { (data, response) in
                        guard let httpResponse = response as? HTTPURLResponse
                        else {
                            throw NetworkError.requestFailed
                        }
                        
                        if (200...299 ~= httpResponse.statusCode) {
                            return data
                        }
                        else if (500...599 ~= httpResponse.statusCode) {
                            throw NetworkError.serverError
                        }
                        
                        throw NetworkError.unknownError
                    }
                    .decode(type: T.self, decoder: JSONDecoder())
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        if case let .failure(error) = completion {
                            switch error {
                            case is URLError:
                                promise(.failure(.badURL))
                            case is DecodingError:
                                promise(.failure(.decodingError))
                            default:
                                promise(.failure(.unknownError))
                            }
                        }
                    } receiveValue: {
                        promise(.success($0))
                    }
                    .store(in: &subscriptions)
            }
            else{
                promise(.failure(.noConnectionInternet))
            }
        }
    }
}
