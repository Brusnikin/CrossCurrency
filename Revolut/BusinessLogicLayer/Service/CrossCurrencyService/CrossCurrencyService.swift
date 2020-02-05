//
//  CrossCurrencyService.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 13.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol CrossCurrencyServiceProtocol: class {
	func request(crossCurrency list: [PlainCrossCurrency])
}

protocol CrossCurrencyServiceDelegate: class {
	func update(crossCurrency list: [PlainCrossCurrency], shouldCache: Bool)
}

class CrossCurrencyService {

	// MARK: - Properties

	weak var delegate: CrossCurrencyServiceDelegate?

	private let networkClient: NetworkClientProtocol

	// MARK: - Construction

	init(networkClient: NetworkClientProtocol) {
		self.networkClient = networkClient
	}

	deinit {
		print("CrossCurrencyService")
	}
}

extension CrossCurrencyService: CrossCurrencyServiceProtocol {
	func request(crossCurrency list: [PlainCrossCurrency]) {
		if list.isEmpty { return }

		networkClient.request(crossCurrency: list, onSuccess: { [weak self] data in
			guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Double] else {
				fatalError("JSON could not be serialized.")
			}
			
			var crossCurrencyList = [PlainCrossCurrency]()
			for currency in list {
				if let rate = json[currency.code] {
					let crossCurrency = PlainCrossCurrency(code: currency.code, rate: rate, pair: currency.pair)
					crossCurrencyList.append(crossCurrency)
				}
			}

			DispatchQueue.main.async {
				self?.delegate?.update(crossCurrency: crossCurrencyList, shouldCache: true)
			}

		}) { error in
			let message = error.localizedDescription
			print(message)
		}
	}
}
