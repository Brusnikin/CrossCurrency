//
//  MockCodableStorage.swift
//  RevolutTests
//
//  Created by Blashkin Georgiy on 14.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation
@testable import Revolut

class MockCodableStorage: CodableStorageProtocol {

	private var crossCurrencyList = [PlainCrossCurrency]()

    func fetch<T: Decodable>(for key: String) throws -> T {
		return crossCurrencyList as! T
    }

    func save<T: Encodable>(_ value: T, for key: String) throws {

    }

    func save<T: Encodable>(_ value: T, for key: String, handler: @escaping Handler<Data>) throws {

    }

	func addCrossCurrency(with code: String) {
		let currency = PlainCurrency(flag: nil, code: code, name: code)
		let crossCurrency = PlainCrossCurrency(code: code, pair: [currency])
		crossCurrencyList.append(crossCurrency)
	}

	func addCrossCurrency(with code: String, rate: Double) {
		let currency = PlainCurrency(flag: nil, code: code, name: code)
		var crossCurrency = PlainCrossCurrency(code: code, pair: [currency])
		crossCurrency.rate = rate
		crossCurrencyList.append(crossCurrency)
	}
}
