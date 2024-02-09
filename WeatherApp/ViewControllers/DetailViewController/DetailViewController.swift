//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import UIKit
import Combine

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
    
    var weatherData: WeatherData?
    
    var weatherViewModel: DetailWeatherViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private let refreshControl = UIRefreshControl()
    
    init(vm: DetailWeatherViewModel) {
        super.init(nibName: "DetailViewController", bundle: nil)
        self.weatherViewModel = vm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewNow.layer.masksToBounds = false
        self.viewNow.backgroundColor = .red
        self.viewNow.layer.cornerRadius = self.viewNow.frame.height / 2
        
        tableView.register(DetailWeatherCell.nib, forCellReuseIdentifier: DetailWeatherCell.reuseIdentifier)
        
        self.tableView.tableHeaderView = viewHeader
        
        self.tableView.isHidden = true
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        loadWeatherInfos()
        setupBinding()
    }

    
    private func setupBinding() {
        weatherViewModel?.$weatherData.sink { [weak self] _ in
            self?.updateViews()
        }.store(in: &cancellables)
        
        weatherViewModel?.$errorType.sink { [weak self] error in
            guard let error = error else { return }
            debugPrint(error.localizedDescription)
            self?.setupViewWhenError(with: error)
        }.store(in: &cancellables)
    }
    
    private func setupViewWhenError(with error: Error) {
        DispatchQueue.main.async {
            self.lblError.isHidden = false
            self.loader.stopAnimating()
            self.tableView.isHidden = true
            self.lblError.text = error.localizedDescription
        }
    }
    
    private func updateViews() {
        DispatchQueue.main.async { [self] in
            self.weatherData = weatherViewModel?.weatherData
            if let cityName = self.weatherData?.name, let countryCode = self.weatherData?.sys?.country {
                self.lblDetail.text = "\(cityName), \(countryCode)"
            }
            self.tableView.isHidden = false
            self.lblError.isHidden = true
            self.loader.stopAnimating()
            self.tableView.reloadData()
            
            self.updateCurrentConditions()
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Load Infos From API weather
    private func loadWeatherInfos() {
        self.loader.startAnimating()
        weatherViewModel?.getWeatherInfos()
    }
    
    private func updateCurrentConditions() {
        if let temp = self.weatherData?.main?.temp {
            self.lblTemp.text = String(format: "%.0f °C", temp)
        }
        
        if let description = self.weatherData?.weather?[0].description, let feelsTemp = self.weatherData?.main?.feelsLikeTemp {
            self.lblFeelsLike.text = String(format: "Feels like %.0f °C, %@", feelsTemp, description.uppercased())
        }
        
        if let speed = self.weatherData?.wind?.speed {
            self.lblWind.text = String(format: "%.1f m/s", speed)
        }
        
        if let cloud = (self.weatherData?.clouds?.all) {
            self.lblCloud.text = String(format: "%.0f %@", cloud, "%")
        }
        //+ (weathers?.current_condition?[0].winddir16Point)!
        
        if let humidity = self.weatherData?.main?.humidity {
            self.lblHumidity.text = String(format: "%.0f %@", humidity, "%")
        }
        
        if let pressure = self.weatherData?.main?.pressure {
            self.lblPressure.text = String(format: "%.0f hPa", pressure)
        }
        
        if let visibility = self.weatherData?.visibility {
            self.lblVisibility.text = String(format: "%.0f m", visibility)
        }
        
        if let imgIcon = self.weatherData?.weather?[0].icon {
            self.weatherIcon.image = UIImage(named: imgIcon)
        }
        
        if let rain = self.weatherData?.rain {
            self.lblRainy.isHidden = false
            self.titleRain.isHidden = false
            self.iconRain.isHidden = false
            let str1H = (rain.rain1H != nil) ? String(format: "%.2f mm/last hour.", rain.rain1H!) : ""
            let str3H = (rain.rain3H != nil) ? String(format: "%.2f mm/last 3 hours", rain.rain1H!) : ""
            self.lblRainy.text = String(format: "%@%@", str1H, str3H)
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
        self.loadWeatherInfos()
    }
        
    // MARK: - UIButton Actions
    @IBAction func goBack(_ sender: Any) {
        weatherViewModel?.popVC()
    }
        
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel?.numberOfDays() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailWeatherCell.reuseIdentifier) as! DetailWeatherCell
        
        cell.tag = indexPath.row
        if let weatherForcast = weatherData?.main {
            let modifiedDate = Calendar.current.date(byAdding: .day, value: (indexPath.row+1), to: Date())!
            cell.configureCell(with: weatherForcast)
            cell.currentDate = modifiedDate
        }

        return cell
    }
}
