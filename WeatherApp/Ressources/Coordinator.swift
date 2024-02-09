//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 30/01/2024.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
