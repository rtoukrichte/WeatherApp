//
//  Extensions.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 19/01/2024.
//

import UIKit

extension UIView {
    func setShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 4
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {
    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let strDate = dateFormatter.date(from: self)
        return strDate ?? Date()
    }
}

extension Date {
    func createformattedDate(with customFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = customFormat
        return dateFormatter.string(from: self)
    }
}
