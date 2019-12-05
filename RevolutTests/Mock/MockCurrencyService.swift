//
//  MockCurrencyService.swift
//  RevolutTests
//
//  Created by Blashkin Georgiy on 22.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import XCTest
@testable import Revolut

class MockCurrencyService: XCTestCase, CurrencyServiceProtocol {

	var storage: CodableStorageProtocol

	init(storage: CodableStorageProtocol) {
		self.storage = storage
		super.init(invocation: nil)
	}

	func fetch(completion: @escaping (([PlainCrossCurrency]) -> Void)) {
		XCTAssertNotNil(storage)

		let waiter = expectation(description: "Fetching currencies")
		do {
			waiter.fulfill()
			completion(try storage.fetch(for: "test"))

		} catch {
			XCTFail("Error: can't fetch cross currency list")
		}
		waitForExpectations(timeout: 1.0)
	}

	func cache(crossCurrency: PlainCrossCurrency) {
		
	}

	func cache(crossCurrency list: [PlainCrossCurrency]) {

	}

	func removeCrossCurrency(with code: String) {

	}
}
