//
//  ReusableCell.swift
//  WeatherApp
//
//  Created by Rida TOUKRICHTE on 29/06/2023.
//

import Foundation

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String.init(describing: self)
    }
}

protocol ConfigurableCell: ReusableCell, NibLoadable {
    associatedtype T
    func configureCell(with item: T)
}
