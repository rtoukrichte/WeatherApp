//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import XCTest

final class WeatherAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testAddCity() throws {
        let app = XCUIApplication()
        app.launch()
    }
    
    func testShowDetailWeather() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        let parisStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Paris"]/*[[".cells.staticTexts[\"Paris\"]",".staticTexts[\"Paris\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        parisStaticText.tap()
        
        let backIconButton = app.buttons["back icon"]
        backIconButton.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Lyon"]/*[[".cells.staticTexts[\"Lyon\"]",".staticTexts[\"Lyon\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backIconButton.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Lille"]/*[[".cells.staticTexts[\"Lille\"]",".staticTexts[\"Lille\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        backIconButton.tap()
        
        let searchCitySearchField = app.searchFields["Search city"]
        searchCitySearchField.tap()
        parisStaticText.tap()
        backIconButton.tap()
        searchCitySearchField.tap()
    }
}
