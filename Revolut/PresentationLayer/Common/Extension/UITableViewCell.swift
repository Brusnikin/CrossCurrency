//
//  UITableViewCell.swift
//  Revolut
//
//  Created by George Blashkin on 02.01.2020.
//  Copyright © 2020 Blashkin Georgiy. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    @objc dynamic var selectionColor: UIColor? {
        get { return selectedBackgroundView?.backgroundColor }
        set {
            guard selectionStyle != .none else { return }
            selectedBackgroundView = UIView().then {
                $0.backgroundColor = newValue
            }
        }
    }
}
