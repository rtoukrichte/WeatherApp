//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import UIKit

class DetailViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var navBarContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet var viewNow: UIView!
    @IBOutlet var weatherIcon: UIImageView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblFeelsLike: UILabel!
    @IBOutlet weak var lblVisibility: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblCloud: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblRainy: UILabel!
    @IBOutlet weak var titleRain: UILabel!
    @IBOutlet weak var iconRain: UIImageView!
    @IBOutlet weak var lblWind: UILabel!
    
    var cityName: String = ""
    var weatherData: WeatherData?
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.viewNow.layer.masksToBounds = false
        self.viewNow.backgroundColor = .red
        self.viewNow.layer.cornerRadius = self.viewNow.frame.height / 2
        
        tableView.register(DetailWeatherCell.nib, forCellReuseIdentifier: DetailWeatherCell.reuseIdentifier)
        
        self.tableView.tableHeaderView = viewHeader
        
        self.lblDetail.text = cityName
        self.tableView.isHidden = true
        tableView.refreshControl = refreshControl
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        loadDataWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Load Infos From API weather
    func loadDataWeather() {
        
        self.loader.startAnimating()
        WeatherService.shared.loadInfos(cityName: cityName) { success, weather, error  in
            guard success else {
                DispatchQueue.main.async {
                    self.lblError.isHidden = false
                    self.loader.stopAnimating()
                    self.tableView.isHidden = true
                    self.lblError.text = error?.localizedDescription
                }
                return
            }
            
            if weather != nil {
                self.weatherData = weather
                DispatchQueue.main.async {
                    self.updateCurrentConditions(self.weatherData)
                    if let cityName = self.weatherData?.name, let countryCode = self.weatherData?.sys?.country {
                        self.lblDetail.text = "\(cityName), \(countryCode)"
                    }
                    self.tableView.isHidden = false
                    self.lblError.isHidden = true
                    self.loader.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    fileprivate func updateCurrentConditions(_ weather: WeatherData?) -> Void {
        
        if let temp = weather?.main?.temp {
            self.lblTemp.text = String(format: "%.0f °C", temp)
        }
        
        if let description = self.weatherData?.weather?[0].description, let feelsTemp = self.weatherData?.main?.feelsLikeTemp {
            self.lblFeelsLike.text = String(format: "Feels like %.0f °C, %@", feelsTemp, description.uppercased())
        }
        
        if let speed = weather?.wind?.speed {
            self.lblWind.text = String(format: "%.1f m/s", speed)
        }
        
        if let cloud = (weather?.clouds?.all) {
            self.lblCloud.text = String(format: "%.0f %@", cloud, "%")
        }
        //+ (weathers?.current_condition?[0].winddir16Point)!
        
        if let humidity = weather?.main?.humidity {
            self.lblHumidity.text = String(format: "%.0f %@", humidity, "%")
        }
        
        if let pressure = weather?.main?.pressure {
            self.lblPressure.text = String(format: "%.0f hPa", pressure)
        }
        
        if let visibility = weather?.visibility {
            self.lblVisibility.text = String(format: "%.0f m", visibility)
        }
        
        if let imgIcon = self.weatherData?.weather?[0].icon {
            self.weatherIcon.image = UIImage(named: imgIcon)
        }
        
        if let rain = self.weatherData?.rain {
            self.lblRainy.isHidden = false
            self.titleRain.isHidden = false
            self.iconRain.isHidden = false
            self.lblRainy.text = String(format: "%.0f mm for the last hour, and %.0f for the last 3 hours", rain.rain1H!, rain.rain3H!)
        }
        else{
            self.lblRainy.isHidden = true
            self.titleRain.isHidden = true
            self.iconRain.isHidden = true
        }
        
    }
    
    // MARK: - Pull To Refresh function
    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.weatherData = nil
        self.loadDataWeather()
    }
        
    // MARK: - UIButton Actions
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailWeatherCell.reuseIdentifier) as! DetailWeatherCell
        
        cell.tag = indexPath.row
        if let weatherForcast = weatherData?.main {
            cell.configureCell(with: weatherForcast)
        }

        return cell
    }
}

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
