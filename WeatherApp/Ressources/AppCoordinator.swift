//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/01/2024.
//

import UIKit


class AppCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        print("App coordinator start !")
        goToCityCoordinator()
    }
    
    
    func goToCityCoordinator() {
        let cityCoordinator = CityCoordinator(navigationController: navigationController)
        cityCoordinator.parentCoordinator = self
        children.append(cityCoordinator)
        
        cityCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in children.enumerated() {
            if coordinator === child {
                children.remove(at: index)
                break
            }
        }
    }
    
}

