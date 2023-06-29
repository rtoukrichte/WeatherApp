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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        tableView.register(CityCell.nib, forCellReuseIdentifier: CityCell.reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        
        if let newData = Preferences.getCities() {
            Constants.defaultCities = newData
        }
        
        self.searchBar.setShadow()
        customAlert.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func createAlert() -> Void {
        let alert = UIAlertController(title: "City", message: "Add new city to your list", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Ex: Paris"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if (textField?.text)! == "" || Constants.defaultCities.contains(where: {$0.name.lowercased() == (textField?.text?.lowercased())!}){
                return
            }
            else{
                let cityName = (textField?.text!)!.capitalizingFirstLetter()
                Constants.defaultCities.append(City(name: cityName, longitude: 0, latitude: 0))
                self.tableView.reloadData()
                Preferences.updateCities(Constants.defaultCities)
            }
            
        }))
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func addCity(_ sender: Any) {
        //self.createAlert()
        customAlert.modalPresentationStyle = .overFullScreen
        self.present(customAlert, animated: true, completion: nil)
    }
    
    func closeActionDelegateAlertSheet() {
        self.customAlert.dismiss(animated: true)
    }
    
    func validerActionDelegateAlertSheet(name: String) {
        self.customAlert.cityTxtField.text = ""
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

extension CityListViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        
        let detailsVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailsVC.cityName = isSearching() ? (filteredData[indexPath.row]).name : (Constants.defaultCities[indexPath.row]).name
        self.navigationController?.pushViewController(detailsVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            
            if isSearching() {
                Constants.defaultCities.remove(at: Constants.defaultCities.index(where: {$0.name == filteredData[indexPath.row].name})!)
                filteredData.remove(at: indexPath.row)
            }
            else{
                Constants.defaultCities.remove(at: indexPath.row)
            }
            
            self.tableView.reloadData()
            Preferences.updateCities(Constants.defaultCities)
        }
    }
    
}
