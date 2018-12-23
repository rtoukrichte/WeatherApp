//
//  WeatherServiceTest.swift
//  WeatherAppTests
//
//  Created by Rida TOUKRICHTE on 23/12/2018.
//

import XCTest
@testable import WeatherApp

class WeatherServiceTest: XCTestCase {
    
    var weatherService: WeatherService!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        weatherService = nil
        super.tearDown()
    }
    
    func testWeatherService() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        weatherService.loadInfo(cityName: "Rabat") { (b, weather) in
            
        }
        
        
    }
    
  
    
}
