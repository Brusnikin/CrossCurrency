//
//  UIView.swift
//  Revolut
//
//  Created by George Blashkin on 02.01.2020.
//  Copyright © 2020 Blashkin Georgiy. All rights reserved.
//

import UIKit

public extension UIView {
	var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

	var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

	var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
}
