//
//  LightTheme.swift
//  Revolut
//
//  Created by George Blashkin on 02.01.2020.
//  Copyright © 2020 Blashkin Georgiy. All rights reserved.
//

import UIKit

struct LightTheme: Theme {
    let tintColor: UIColor = .systemBlue
    let secondaryTintColor: UIColor = .orange

    let backgroundColor: UIColor = .white
    let separatorColor: UIColor = .clear
    let selectionColor: UIColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)

    let labelColor: UIColor = .black
    let titleLabelColor: UIColor = .darkGray
    let subtitleLabelColor: UIColor = .lightGray

    let barStyle: UIBarStyle = .default
	var backgroundEffect: UIBlurEffect = .init(style: .light)
}

extension LightTheme {
    func extend() {
        UIImageView.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).then {
            $0.borderColor = separatorColor
            $0.borderWidth = 1
        }

        UIImageView.appearance(whenContainedInInstancesOf: [UIButton.self, UITableViewCell.self]).then {
            $0.borderWidth = 0
        }
    }
}
