//
//  RevolutTests.swift
//  RevolutTests
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import XCTest
@testable import Revolut

class RevolutTests: XCTestCase {
    func testCurrencyService() {
		let storage = MockCodableStorage()
		storage.addCrossCurrency(with: "test")
		let currencyService = CurrencyService(storage: storage)

		currencyService.fetch { cachedCurrencyList in
			XCTAssertTrue(cachedCurrencyList.contains { $0.code == "test" })
			XCTAssertNotNil(cachedCurrencyList)
			XCTAssertTrue(!cachedCurrencyList.isEmpty)
		}
    }

    func testCrossCurrencyService() {
		let networkClient = MockCrossCurrencyNetworkClient()
		let crossCurrencyList = [createCrossCurrency(code: "USDRUB"),
								 createCrossCurrency(code: "EURRUB"),
								 createCrossCurrency(code: "GBPRUB")]
		networkClient.add(crossCurrency: crossCurrencyList[0])
		networkClient.add(crossCurrency: crossCurrencyList[1])
		networkClient.add(crossCurrency: crossCurrencyList[2])

		let crossCurrencyServiceDelegate = MockCrossCurrencyServiceDelegate()
		let crossCurrencyService = CrossCurrencyService(networkClient: networkClient)
		crossCurrencyService.delegate = crossCurrencyServiceDelegate
		crossCurrencyService.request(crossCurrency: crossCurrencyList)

		XCTAssertEqual(crossCurrencyList[0].code, crossCurrencyServiceDelegate.crossCurrencyList?[0].code)
		XCTAssertEqual(crossCurrencyList[1].code, crossCurrencyServiceDelegate.crossCurrencyList?[1].code)
		XCTAssertEqual(crossCurrencyList[2].code, crossCurrencyServiceDelegate.crossCurrencyList?[2].code)
    }

	private func createCrossCurrency(code: String) -> PlainCrossCurrency {
		let currency = PlainCurrency(flag: nil, code: code, name: "test")
		return PlainCrossCurrency(code: code, pair: [currency])
	}
}
