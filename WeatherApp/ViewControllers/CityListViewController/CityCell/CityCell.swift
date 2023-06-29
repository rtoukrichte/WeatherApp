//
//  CityCell.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import UIKit

class CityCell: UITableViewCell, ConfigurableCell {
    typealias T = City

    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }

    func configureCell(with item: City) {
        self.cityName.text = item.name
    }
    
}
