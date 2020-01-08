//
//  Theme.swift
//  Revolut
//
//  Created by George Blashkin on 02.01.2020.
//  Copyright © 2020 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol Theme {
    var tintColor: UIColor { get }
    var secondaryTintColor: UIColor { get }

    var backgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var selectionColor: UIColor { get }

    var labelColor: UIColor { get }
    var titleLabelColor: UIColor { get }
    var subtitleLabelColor: UIColor { get }

    var barStyle: UIBarStyle { get }
	var backgroundEffect: UIBlurEffect { get }

    func apply()
    func extend()
}

extension Theme {
	func apply() {
		UIApplication.shared.keyWindow?.tintColor = tintColor

        UITabBar.appearance().then {
            $0.barStyle = barStyle
            $0.tintColor = tintColor
        }

		if #available(iOS 13.0, *) {
			let standard = UINavigationBarAppearance().then {
				$0.backgroundEffect = backgroundEffect
			}
			UINavigationBar.appearance().standardAppearance = standard
		} else {
			UINavigationBar.appearance().then {
				$0.barStyle = barStyle
				$0.tintColor = tintColor
				$0.titleTextAttributes = [.foregroundColor: labelColor]
				if #available(iOS 11.0, *) {
					$0.largeTitleTextAttributes = [.foregroundColor: labelColor]
				}
			}
		}

        UICollectionView.appearance().backgroundColor = backgroundColor

        UITableView.appearance().then {
            $0.backgroundColor = backgroundColor
            $0.separatorColor = separatorColor
        }

        UITableViewCell.appearance().then {
            $0.backgroundColor = .clear
            $0.selectionColor = selectionColor
        }

        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).backgroundColor = selectionColor

        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = titleLabelColor

        RevolutLabel.appearance().textColor = labelColor
        RevolutTitleLabel.appearance().textColor = titleLabelColor
		RevolutSubtitleLabel.appearance().textColor = subtitleLabelColor

        RevolutButton.appearance().then {
            $0.setTitleColor(tintColor, for: .normal)
            $0.borderColor = tintColor
            $0.borderWidth = 1
            $0.cornerRadius = 3
        }

        RevolutSwitch.appearance().then {
            $0.tintColor = tintColor
            $0.onTintColor = tintColor
        }

        RevolutStepper.appearance().tintColor = tintColor
        RevolutSlider.appearance().tintColor = tintColor
        RevolutSegmentedControl.appearance().tintColor = tintColor

        RevolutView.appearance().backgroundColor = backgroundColor
        RevolutSeparator.appearance().then {
            $0.backgroundColor = separatorColor
            $0.alpha = 0.5
        }

        RevolutView.appearance(whenContainedInInstancesOf: [RevolutView.self]).then {
            $0.backgroundColor = selectionColor
            $0.cornerRadius = 10
        }

        // Style differently when inside a special container

		let viewContainer = [RevolutView.self, RevolutView.self]
        RevolutLabel.appearance(whenContainedInInstancesOf: viewContainer).textColor = subtitleLabelColor
        RevolutTitleLabel.appearance(whenContainedInInstancesOf: viewContainer).textColor = titleLabelColor
        RevolutSubtitleLabel.appearance(whenContainedInInstancesOf: viewContainer).textColor = subtitleLabelColor

        RevolutButton.appearance(whenContainedInInstancesOf: viewContainer).then {
            $0.setTitleColor(labelColor, for: .normal)
            $0.borderColor = labelColor
        }

		RevolutSwitch.appearance(whenContainedInInstancesOf: viewContainer).then {
            $0.tintColor = secondaryTintColor
            $0.onTintColor = secondaryTintColor
        }

        extend()

        // Ensure existing views render with new theme
        // https://developer.apple.com/documentation/uikit/uiappearance
		UIApplication.shared.keyWindow?.reload()
	}

    func extend() {
        // Optionally extend theme
    }
}
