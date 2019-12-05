//
//  MockCrossCurrencyNetworkClient.swift
//  RevolutTests
//
//  Created by Blashkin Georgiy on 15.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import XCTest
@testable import Revolut

class MockCrossCurrencyNetworkClient: XCTestCase, NetworkClientProtocol {

	private var crossCurrencyList = [String: Double]()

	func request(crossCurrency list: [PlainCrossCurrency], onSuccess: @escaping Success, onFailure: @escaping Failure) {
		let waiter = expectation(description: "Loading currencies")
		guard let data = try? JSONEncoder().encode(crossCurrencyList) else {
			XCTFail("Failed to encode crossCurrencyList data")
			return
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			waiter.fulfill()
		}

		onSuccess(data)

		waitForExpectations(timeout: 3.0)
	}

	func add(crossCurrency: PlainCrossCurrency) {
		crossCurrencyList[crossCurrency.code] = crossCurrency.rate
	}
}
