//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 21/12/2018.
//

import UIKit

class CityListViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredData = [City]()
    var isSearching = false
    
    var weathers: Weather?

    var cities = [City(name: "Rabat", longitude: 37, latitude: -6), City(name: "Casablanca", longitude: 37, latitude: -6),City(name: "Marrakech", longitude: 37, latitude: -6),City(name: "Tangier", longitude: 37, latitude: -6),City(name: "Fes", longitude: 37, latitude: -6)]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        filteredData = cities
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if( (searchBar.text == nil ) || (searchBar.text == "") ){
            isSearching = false
            view.endEditing(true)
            self.tableView.reloadData()
        }
        else{
            isSearching = true
            filteredData = cities.filter({(($0.name.lowercased()).contains(searchBar.text!.lowercased()))})
            print("filter data --- ", filteredData)
            self.tableView.reloadData()
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func createAlert() -> Void {
        let alert = UIAlertController(title: "Ville", message: "Ajouter une ville à votre liste.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Entrer une ville"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            //print("Text field:", (textField?.text)!)
            if (textField?.text)! == "" || self.cities.contains(where: {$0.name == (textField?.text)!}){
                return
            }
            else{
                
                self.cities.append(City(name: (textField?.text!)!, longitude: 0, latitude: 0))
                
                self.tableView.reloadData()
                
            }
            
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func addCity(_ sender: Any) {
        self.createAlert()
    }
    
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isSearching){
            return filteredData.count
        }
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CityCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CityCell
        var _: Int = indexPath.row
        if cell == nil {
            let topLevelObjects = Bundle.main.loadNibNamed("CityCell", owner: nil, options: nil)
            for currentObject: Any in topLevelObjects! {
                if (currentObject is UITableViewCell) {
                    cell = currentObject as? CityCell
                    
                    if(isSearching){
                        cell?.cityName.text = (filteredData[indexPath.row]).name
                        
                    }
                    else{
                        cell?.cityName.text = (cities[indexPath.row]).name
                        
                    }
                    
                    cell?.backgroundColor = UIColor.clear
                    cell?.selectionStyle = .none
                    
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let details = DetailViewController(nibName: "DetailViewController", bundle: nil)
        
        //print("@@@@@@@@@@@ Select ville ===> ", (cities[indexPath.row]).name)
        details.cityName = (cities[indexPath.row]).name

        self.present(details, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            if self.isSearching{
                
                self.cities.remove(at: self.cities.index(where: {$0.name == filteredData[indexPath.row].name})!)
                self.filteredData.remove(at: indexPath.row)
                
                
            }
            else{
                self.cities.remove(at: indexPath.row)
            }
            
            self.tableView.reloadData()
        }
    }
    
}
