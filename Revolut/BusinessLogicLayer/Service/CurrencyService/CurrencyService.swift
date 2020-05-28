//
//  CurrencyService.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit
import Foundation

protocol CurrencyServiceProtocol: class {
	func fetch(completion: @escaping (([PlainCrossCurrency]) -> Void))
	func cache(crossCurrency: PlainCrossCurrency)
	func cache(crossCurrency list: [PlainCrossCurrency])
	func removeCrossCurrency(with code: String)
}

final class CurrencyService {

	// MARK: - Properies

	private let kCrossCurrencyListKey = "kCrossCurrencyListKey"
	private let storage: CodableStorageProtocol

	// MARK: - Construction

	init(storage: CodableStorageProtocol) {
		self.storage = storage
	}

	deinit {
		print("CurrencyService")
	}
}

extension CurrencyService: CurrencyServiceProtocol {
	func fetch(completion: @escaping (([PlainCrossCurrency]) -> Void)) {
		do {
			completion(try storage.fetch(for: kCrossCurrencyListKey))
		} catch {
			completion([PlainCrossCurrency]())
		}
	}

	func cache(crossCurrency: PlainCrossCurrency) {
		do {
			guard var currencyList: [PlainCrossCurrency] = try? storage.fetch(for: kCrossCurrencyListKey) else {
				try storage.save([crossCurrency], for: kCrossCurrencyListKey)
				return
			}
			currencyList.insert(crossCurrency, at: 0)
			try storage.save(currencyList, for: kCrossCurrencyListKey)

		} catch {
			print("Error: can't cache cross currency list: \(crossCurrency)")
		}
	}

	func cache(crossCurrency list: [PlainCrossCurrency]) {
		do {
			try storage.save(list, for: kCrossCurrencyListKey)
		} catch {
			print("Error: can't cache cross currency list: \(list)")
		}
	}

	func removeCrossCurrency(with code: String) {
		guard let currencyList: [PlainCrossCurrency] = try? storage.fetch(for: kCrossCurrencyListKey) else {
			return
		}
		cache(crossCurrency: currencyList.filter { $0.code != code } )
	}
}
