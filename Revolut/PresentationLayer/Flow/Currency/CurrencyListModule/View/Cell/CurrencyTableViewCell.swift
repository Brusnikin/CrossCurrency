//
//  CurrencyTableViewCell.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

final class CurrencyTableViewCell: UITableViewCell {

	// MARK: - Outlets

	@IBOutlet weak var countryFlagImageView: UIImageView! {
		didSet {
			countryFlagImageView.backgroundColor = .lightGray
			countryFlagImageView.layer.cornerRadius = countryFlagImageView.frame.height / 2
		}
	}
	@IBOutlet weak var currencyCodeLabel: RevolutLabel!
	@IBOutlet weak var currencyNameLabel: RevolutLabel!

	// MARK: - Lifecycle

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		countryFlagImageView.backgroundColor = .lightGray
    }

	override func prepareForReuse() {
		super.prepareForReuse()
		currencyCodeLabel.alpha = 1.0
		currencyNameLabel.alpha = 1.0
		isUserInteractionEnabled = true
	}

	func select(currency: PlainCurrency) {
		currencyCodeLabel.alpha = 0.5
		currencyNameLabel.alpha = 0.5
		isUserInteractionEnabled = false
	}
}

extension CurrencyTableViewCell: ConfigurableCell {
	typealias CellData = PlainCurrency

	func configure(with currency: PlainCurrency) {
		currencyCodeLabel?.text = currency.code
		currencyNameLabel?.text = currency.name
	}
}
