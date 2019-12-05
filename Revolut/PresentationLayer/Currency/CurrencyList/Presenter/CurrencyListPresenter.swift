//
//  CurrencyListPresenter.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol CurrencyListPresenterProtocol: class {
	func prepare(selected currency: PlainCurrency)
	func cache(selected pair: [PlainCurrency])
}

protocol CurrencyListPresenterDelegate: class {
	func update(currencyList selected: [PlainCurrency])
}

class CurrencyListPresenter {

	// MARK: - Properties

	weak var delegate: CurrencyListPresenterDelegate?
	private(set) var cachedCrossCurrencyList: [PlainCrossCurrency]?

	private let currencyService: CurrencyServiceProtocol

	// MARK: - Construction

	init(currencyService: CurrencyServiceProtocol) {
		self.currencyService = currencyService
	}

	deinit {
		print("CurrencyListPresenter")
	}

	// MARK: - Functions

	private func createCrossCurrency(pair: [PlainCurrency]) -> PlainCrossCurrency? {
		guard let numerator = pair.first,
			let denominator = pair.last else {
				return nil
		}
		let code = numerator.code + denominator.code
		return PlainCrossCurrency(code: code, pair: pair)
	}

	private func filter(crossCurrency list: [PlainCrossCurrency], by currency: PlainCurrency) -> [PlainCrossCurrency] {
		return list.filter { crossCurrency -> Bool in
			guard let numerator = crossCurrency.pair.first,
				let denominator = crossCurrency.pair.last else {
					return false
			}
			return numerator.code == currency.code || denominator.code == currency.code
		}
	}
}

extension CurrencyListPresenter: CurrencyListPresenterProtocol {
	func prepare(selected currency: PlainCurrency) {
		currencyService.fetch { [weak self] cached in
			guard let self = self else { return }
			self.cachedCrossCurrencyList = cached
			let filtered = self.filter(crossCurrency: cached, by: currency)

			if filtered.isEmpty {
				self.delegate?.update(currencyList: [currency])
			} else {
				self.delegate?.update(currencyList: filtered.flatMap { $0.pair })
			}
		}
	}

	func cache(selected pair: [PlainCurrency]) {
		if let crossCurrency = createCrossCurrency(pair: pair) {
			currencyService.cache(crossCurrency: crossCurrency)
		}
	}
}
