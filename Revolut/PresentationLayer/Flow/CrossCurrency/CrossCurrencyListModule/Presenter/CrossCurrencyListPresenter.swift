//
//  CrossCurrencyListPresenter.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit
import Foundation

protocol CrossCurrencyListPresenterProtocol: class {
	func obtainCrossCurrencyRates()
	func suspendUpdates()
	func remove(crossCurrency: CrossCurrencyViewModel)
}

protocol CrossCurrencyListPresenterDelegate: class {
	func update(viewModelList: [CrossCurrencyViewModel])
	func hideCurrencyListView()
}

final class CrossCurrencyListPresenter {

	// MARK: - Properties

	weak var delegate: CrossCurrencyListPresenterDelegate?

	private let currencyService: CurrencyServiceProtocol
	private let crossCurrencyService: CrossCurrencyServiceProtocol
	private let timeInterval: TimeInterval = 1.0
	private(set) lazy var crossCurrencyList = [PlainCrossCurrency]()
	private var timer: Timer?

	// MARK: - Construction

	init(crossCurrencyService: CrossCurrencyServiceProtocol,
		 currencyService: CurrencyServiceProtocol) {
		self.crossCurrencyService = crossCurrencyService
		self.currencyService = currencyService
	}

	deinit {
		print("CrossCurrencyListPresenter")
	}

	// MARK: - Function

	private func createTimer() {
		if timer == nil {
			let timer = Timer(timeInterval: timeInterval,
			target: self,
			selector: #selector(updateCurrencyListRate),
			userInfo: nil,
			repeats: true)
			RunLoop.current.add(timer, forMode: .common)
			self.timer = timer
		}
	}

	private func cancelTimer() {
	  timer?.invalidate()
	  timer = nil
	}

	/// Designed for demonstration purposes only. Supports the format of 1.1234.
	private func format(rate: Double) -> NSAttributedString {
		let behaviourRoundDown = NSDecimalNumberHandler(roundingMode: .down,
														scale: 2,
														raiseOnExactness: false,
														raiseOnOverflow: false,
														raiseOnUnderflow: false,
														raiseOnDivideByZero: false)

		let roundRate = NSDecimalNumber(value: rate).rounding(accordingToBehavior: behaviourRoundDown)
		let suffixRate = Int(round((rate - roundRate.doubleValue) * 10000))
		return container(prefix: "\(roundRate)", suffix: "\(suffixRate)")
	}

	private func container(prefix: String, suffix: String) -> NSAttributedString {
		let container = NSMutableAttributedString(string: prefix, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)])
		container.append(NSAttributedString(string: suffix, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
		return container
	}
	
	private func createViewModel(crossCurrency: PlainCrossCurrency) -> CrossCurrencyViewModel? {
		guard let numerator = crossCurrency.pair.first,
			let denominator = crossCurrency.pair.last else {
				return nil
		}

		let rate = format(rate: crossCurrency.rate)
		let denominatorName = "\(denominator.name) ∙ \(denominator.code)"
		return CrossCurrencyViewModel(
			code: crossCurrency.code,
			rate: rate,
			numerator: "1 \(numerator.code)",
			numeratorName: numerator.name,
			denominatorName: denominatorName)
	}

	private func createViewModels(crossCurrencyList: [PlainCrossCurrency]) -> [CrossCurrencyViewModel] {
		var viewModels = [CrossCurrencyViewModel]()
		for currency in crossCurrencyList {
			guard let viewModel = createViewModel(crossCurrency: currency) else { break }
			viewModels.append(viewModel)
		}
		return viewModels
	}

	@objc private func updateCurrencyListRate() {
		crossCurrencyService.request(crossCurrency: crossCurrencyList)
	}
}

extension CrossCurrencyListPresenter: CrossCurrencyListPresenterProtocol {
	func suspendUpdates() {
		cancelTimer()
	}

	func remove(crossCurrency: CrossCurrencyViewModel) {
		crossCurrencyList = crossCurrencyList.filter { $0.code != crossCurrency.code }
		currencyService.removeCrossCurrency(with: crossCurrency.code)
		if crossCurrencyList.isEmpty {
			delegate?.hideCurrencyListView()
		} else {
			createTimer()
		}
	}

	func obtainCrossCurrencyRates() {
		currencyService.fetch { [weak self] cachedCurrencyList in
			self?.crossCurrencyList = cachedCurrencyList
			self?.update(crossCurrency: cachedCurrencyList, shouldCache: false)
			self?.createTimer()
		}
	}
}

extension CrossCurrencyListPresenter: CrossCurrencyServiceDelegate {
	func update(crossCurrency list: [PlainCrossCurrency], shouldCache: Bool) {
		let viewModels = createViewModels(crossCurrencyList: list)
		delegate?.update(viewModelList: viewModels)

		if shouldCache {
			currencyService.cache(crossCurrency: list)
		}
	}
}
