//
//  ConfigurableCell.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 13.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype CellData

    static var reuseIdentifier: String { get }

    func configure(with _: CellData)
}

extension ConfigurableCell where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
