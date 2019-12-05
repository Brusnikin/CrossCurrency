//
//  MockCrossCurrencyServiceDelegate.swift
//  RevolutTests
//
//  Created by Blashkin Georgiy on 14.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

@testable import Revolut

class MockCrossCurrencyServiceDelegate: CrossCurrencyServiceDelegate {

	private(set) var crossCurrencyList: [PlainCrossCurrency]?

	func update(crossCurrency list: [PlainCrossCurrency], shouldCache: Bool) {
		crossCurrencyList = list
	}
}
