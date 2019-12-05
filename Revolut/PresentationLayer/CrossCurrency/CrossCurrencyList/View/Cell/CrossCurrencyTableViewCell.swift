//
//  CrossCurrencyTableViewCell.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 13.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

class CrossCurrencyTableViewCell: UITableViewCell {

	// MARK: - Outlets

	@IBOutlet weak var numeratorLabel: UILabel!
	@IBOutlet weak var numeratorNameLabel: UILabel!

	@IBOutlet weak var rateLabel: UILabel!
	@IBOutlet weak var denominatorLabel: UILabel!
}

extension CrossCurrencyTableViewCell: ConfigurableCell {
	typealias CellData = CrossCurrencyViewModel

	func configure(with currency: CrossCurrencyViewModel) {
		numeratorLabel.text = currency.numerator
		numeratorNameLabel.text = currency.numeratorName
		rateLabel.attributedText = currency.rate
		denominatorLabel.text = currency.denominatorName
	}
}
