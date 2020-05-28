//
//  RevolutWindow.swift
//  Revolut
//
//  Created by George Blashkin on 08.01.2020.
//  Copyright © 2020 Blashkin Georgiy. All rights reserved.
//

import UIKit

final class RevolutWindow: UIWindow {
	override init(frame: CGRect) {
		super.init(frame: frame)

		if #available(iOS 13.0, *) {
			apply(theme: UITraitCollection.current.userInterfaceStyle)
		} else {
			LightTheme().apply()
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		if #available(iOS 13.0, *) {
			if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
				apply(theme: traitCollection.userInterfaceStyle)
			}
		} else {
			LightTheme().apply()
		}
	}

	@available(iOS 12.0, *)
	private func apply(theme style: UIUserInterfaceStyle) {
		if style == .dark {
			DarkTheme().apply()
		} else {
			LightTheme().apply()
		}
	}
}
