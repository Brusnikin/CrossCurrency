//
//  UIWindow.swift
//  Revolut
//
//  Created by George Blashkin on 02.01.2020.
//  Copyright © 2020 Blashkin Georgiy. All rights reserved.
//

import UIKit

public extension UIWindow {

    /// Unload all views and add back.
    /// Useful for applying `UIAppearance` changes to existing views.
    func reload() {
		for view in subviews {
            view.removeFromSuperview()
            addSubview(view)
		}
    }
}

public extension Array where Element == UIWindow {

    /// Unload all views for each `UIWindow` and add back.
    /// Useful for applying `UIAppearance` changes to existing views.
    func reload() {
        forEach { $0.reload() }
    }
}
