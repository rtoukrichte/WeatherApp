//
//  Preferences.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import Foundation

final class Preferences: NSObject {
    
    static let cityDataKey = "CityDataKey"
    
    class func initCitiesData(_ cities: [City]) {
        
        let usD = UserDefaults.standard
        guard let jsonData = try? JSONEncoder().encode(cities) else {
            return
        }
        
        usD.setValuesForKeys([cityDataKey: jsonData])
        usD.synchronize()
        
    }

    class func getCities() -> [City]? {
        
        let usD = UserDefaults.standard
        
        if let savedCities = usD.value(forKey: cityDataKey) {
            let decodedData = try? JSONDecoder().decode([City].self, from: savedCities as! Data)
            guard let cities = decodedData else {
                return nil
            }
            return cities
        }
        
        return nil
    }

    class func updateCities(_ newCities: [City]) {

        let usD = UserDefaults.standard
        
        if let savedCities = getCities() {
            if savedCities.count != newCities.count {
                guard let jsonData = try? JSONEncoder().encode(newCities) else {
                    return
                }
                usD.setValuesForKeys([cityDataKey: jsonData])
                usD.synchronize()
            }
        }
        else {
            initCitiesData(newCities)
        }
        
    }

}
