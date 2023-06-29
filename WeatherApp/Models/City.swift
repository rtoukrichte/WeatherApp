//
//  City.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import Foundation

struct City: Encodable, Decodable {
    let name : String
    let longitude : Float?
    let latitude : Float?
}
