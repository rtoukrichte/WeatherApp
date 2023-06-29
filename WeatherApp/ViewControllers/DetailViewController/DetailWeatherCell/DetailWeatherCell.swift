//
//  DetailWeatherCell.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import UIKit

class DetailWeatherCell: UITableViewCell, ConfigurableCell {
    typealias T = WeatherData.MainData
    
    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.cornerRadius = 12
    }

    func configureCell(with item: WeatherData.MainData) {
        //self.lblDate.text = formattedDay(date: (item.date)!)
        //self.lblDate.text = formattedDay(date: DateFormatter().string(from: Date()))
        self.lblMin.text = String(format: "%.0f °C", item.minTemp!)
        self.lblMax.text = String(format: "%.0f °C", item.maxTemp!)
    }
    
    func formattedDay(date: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let output_date = formatter.date(from: date) {
            formatter.dateFormat = "EEEE"
            formatter.locale = Locale(identifier: "en_US")

            return "\(formatter.string(from: output_date))"
        }
        
        return ""
    }
}
