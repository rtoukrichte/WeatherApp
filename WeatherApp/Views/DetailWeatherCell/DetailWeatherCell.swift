//
//  DetailWeatherCell.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 21/12/2018.
//

import UIKit

class DetailWeatherCell: UITableViewCell {

    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
