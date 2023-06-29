//
//  NibLoadable.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import UIKit

protocol NibLoadable: AnyObject {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String.init(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.nibName, bundle: Bundle(for: self))
    }
}
