//
//  StartViewPresenter.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 13.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol StartViewPresenterProtocol: class {
	func checkCrossCurrencyList()
}

protocol StartViewPresenterDelegate: class {
	func shouldShowCrossCurrencyList()
}

final class StartViewPresenter {

	// MARK: - Properties

	private let currencyService: CurrencyServiceProtocol
	private(set) var crossCurrencyList: [PlainCrossCurrency]?

	weak var delegate: StartViewPresenterDelegate?

	// MARK: - Construction

	init(currencyService: CurrencyServiceProtocol) {
		self.currencyService = currencyService
	}
}

extension StartViewPresenter: StartViewPresenterProtocol {
	func checkCrossCurrencyList() {
		currencyService.fetch { [weak self] cached in
			self?.crossCurrencyList = cached
			if !cached.isEmpty {
				self?.delegate?.shouldShowCrossCurrencyList()
			}
		}
	}
}
