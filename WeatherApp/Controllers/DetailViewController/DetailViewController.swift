//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 21/12/2018.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var lblDetail: UILabel!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var cityName: String = ""
    
    @IBOutlet weak var localTime: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblVisibility: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblCloud: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblRainy: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    
    var weathers: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.tableView.tableHeaderView = viewHeader
        
        self.lblDetail.text = cityName + " weather report"
        self.tableView.isHidden = true
        self.loader.startAnimating()
        
        self.loadDataWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Load Informations From WebService weather
    func loadDataWeather() {
        
        if WeatherService.sharedInstance.isNetworkReachable() {
            WeatherService.sharedInstance.loadInfo(cityName: cityName) { success, weather in
                guard success else {
                    return
                }

                if weather != nil {
                    self.weathers = weather
                    self.loader.stopAnimating()
                    self.updateCurrentConditions(self.weathers)
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        }
        else {
            
            if weathers != nil {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func updateCurrentConditions(_ weather: Weather?) -> Void {
        
        let currentDate = Date()
        
        let formatter = DateFormatter()

        formatter.dateFormat = "EEEE dd MMM HH:mm"
        let myStringafd = formatter.string(from: currentDate)
        
        self.localTime.text = myStringafd
        self.lblTemp.text = (weathers?.currentCondition[0].temp_C)! + " °C"
        self.lblWind.text = (weathers?.currentCondition[0].windspeedKmph)! + " Km/h from " + (weathers?.currentCondition[0].winddir16Point)!
        self.lblCloud.text = (weathers?.currentCondition[0].cloudcover)! + " %"
        self.lblRainy.text = (weathers?.currentCondition[0].precipMM)! + " %"
        self.lblHumidity.text = (weathers?.currentCondition[0].humidity)! + " %"
        self.lblPressure.text = (weathers?.currentCondition[0].pressure)! + " mb"
        self.lblVisibility.text = (weathers?.currentCondition[0].visibility)! + " Km"
    }
    
    
    @IBAction func refreshInfos(_ sender: Any) {
        
        self.tableView.isHidden = true
        self.loader.startAnimating()
        
        self.loadDataWeather()
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DetailWeatherCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DetailWeatherCell
        var _: Int = indexPath.row
        if cell == nil {
            let topLevelObjects = Bundle.main.loadNibNamed("DetailWeatherCell", owner: nil, options: nil)
            for currentObject: Any in topLevelObjects! {
                if (currentObject is UITableViewCell) {
                    cell = currentObject as? DetailWeatherCell
                    
                    if self.weathers?.weatherForecast[indexPath.row] != nil {

                        cell?.lblDate.text = (weathers?.weatherForecast[indexPath.row].dateWeather)!
                        cell?.lblMin.text = (weathers?.weatherForecast[indexPath.row].minTempC)! + " °C"
                        cell?.lblMax.text = (weathers?.weatherForecast[indexPath.row].maxTempC)! + " °C"
                        
                        cell?.backgroundColor = UIColor.clear
                        cell?.selectionStyle = .none
                    }
                    
                }
            }
        }
        return cell!
    }
}

