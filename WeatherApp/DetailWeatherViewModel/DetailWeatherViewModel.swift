//
//  DetailWeatherViewModel.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 19/01/2024.
//

import Foundation
import Combine

class DetailWeatherViewModel: ObservableObject {
    
    private var serviceManager = ServiceManager.shared
    
    weak var appCoordinator: CityCoordinator!
    
    private var cancellable = Set<AnyCancellable>()
    
    @Published var weatherData: WeatherData?
    @Published var errorType: NetworkError?
    
    var selectedCity: String?

    init(selectedCity: String) {
        self.selectedCity = selectedCity
    }
    
    func getWeatherInfos() {
        let paramsUrl = String(format: "?q=%@&appid=%@&units=%@", selectedCity ?? "", Constants.Keys.weatherAPIKey, "metric")
        let apiURL = String(format: "%@%@", Constants.dataWeatherURL, paramsUrl)
        
        serviceManager.fetch(from: apiURL)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorType = error
                    debugPrint("Error == ", error)
                }
            } receiveValue: { [unowned self] in
                let weather: WeatherData = $0
                                
                self.weatherData = weather
            }
            .store(in: &self.cancellable)
    }
    
    func numberOfDays() -> Int {
        return 6
    }
    
    func popVC() {
        appCoordinator.goToBack()
    }
    
}


