//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import UIKit

class CityListViewController: UIViewController, UISearchBarDelegate, CustomAlertViewDelegate {

    @IBOutlet var navBarContainer: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredData = [City]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let customAlert = CustomAlertSheet()
    var blackView = UIView()
    
    weak var appCoordinator: CityCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CityCell.nib, forCellReuseIdentifier: CityCell.reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        
        if let newData = Preferences.getCities() {
            Constants.defaultCities = newData
        }
        
        self.searchBar.setShadow()
        customAlert.delegate = self
    }
    
    // MARK: - SearchBar Delegate method
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if((searchBar.text == nil ) || (searchBar.text == "")){
            view.endEditing(true)
            self.tableView.reloadData()
        }
        else{
            filteredData = Constants.defaultCities.filter({(($0.name.lowercased()).contains(searchBar.text!.lowercased()))})
            debugPrint("filter data --- ", filteredData)
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func isSearching() -> Bool {
        return searchBar.text != ""
    }
        
    @IBAction func addCity(_ sender: Any) {
        addBlackView()
        appCoordinator.present(this: customAlert)
    }
    
    func closeActionDelegateAlertSheet() {
        self.blackView.removeFromSuperview()
        self.customAlert.dismiss(animated: true)
    }
    
    func addBlackView() {
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.addSubview(self.blackView)
        }, completion: nil)
    }
    
    func validerActionDelegateAlertSheet(name: String) {
        self.customAlert.cityTxtField.text = ""
        self.blackView.removeFromSuperview()
        self.customAlert.dismiss(animated: true)
        if name != "" {
            if (name == "" || Constants.defaultCities.contains(where: {$0.name.lowercased() == name.lowercased()})) {
                return
            }
            else{
                let cityName = name.capitalizingFirstLetter()
                Constants.defaultCities.append(City(name: cityName, longitude: 0, latitude: 0))
                self.tableView.reloadData()
                Preferences.updateCities(Constants.defaultCities)
            }
        }
    }
    
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching() ? filteredData.count : Constants.defaultCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.reuseIdentifier) as! CityCell
        cell.tag = indexPath.row
        cell.configureCell(with: isSearching() ? filteredData[indexPath.row] : Constants.defaultCities[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = isSearching() ? (filteredData[indexPath.row]).name : (Constants.defaultCities[indexPath.row]).name
        appCoordinator.goToDetailsCity(cityName: selectedCity)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completion) in
            
            if self.isSearching() {
                Constants.defaultCities.remove(at: Constants.defaultCities.firstIndex(where: {$0.name == self.filteredData[indexPath.row].name})!)
                self.filteredData.remove(at: indexPath.row)
            }
            else {
                Constants.defaultCities.remove(at: indexPath.row)
            }
            
            self.tableView.reloadData()
            Preferences.updateCities(Constants.defaultCities)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
}
