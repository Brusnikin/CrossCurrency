//
//  DarkTheme.swift
//  Revolut
//
//  Created by George Blashkin on 02.01.2020.
//  Copyright © 2020 Blashkin Georgiy. All rights reserved.
//

import UIKit

struct DarkTheme: Theme {
    let tintColor: UIColor = .systemBlue
    let secondaryTintColor: UIColor = .green

    let backgroundColor: UIColor = .black
    let separatorColor: UIColor = .clear
    let selectionColor: UIColor = .init(red: 38/255, green: 38/255, blue: 40/255, alpha: 1)

    let labelColor: UIColor = .white
    let titleLabelColor: UIColor = .lightGray
    let subtitleLabelColor: UIColor = .darkGray

    let barStyle: UIBarStyle = .black
	var backgroundEffect: UIBlurEffect = .init(style: .dark)
}
