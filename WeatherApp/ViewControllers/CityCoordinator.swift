//
//  CityCoordinator.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 30/01/2024.
//

import UIKit

class CityCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainController = CityListViewController() as CityListViewController
        mainController.appCoordinator = self
        navigationController.setViewControllers([mainController], animated: true)
    }
    
    func goToDetailsCity(cityName: String) {
        let detailsVM = DetailWeatherViewModel(selectedCity: cityName)
        let detailsVC = DetailViewController(vm: detailsVM) as DetailViewController
        detailsVM.appCoordinator = self
        detailsVC.weatherViewModel = detailsVM
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    func present(this vc: UIViewController) {
        vc.modalPresentationStyle = .overFullScreen
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func goToBack() {
        navigationController.popViewController(animated: true)
    }
    
    
}
