//
//  CurrencyListPresenterTests.swift
//  RevolutTests
//
//  Created by Blashkin Georgiy on 22.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import XCTest
@testable import Revolut

class CurrencyListPresenterTests: XCTestCase {
    func testNoSelectedCurrency() {
		let storage = MockCodableStorage()
		let currencyService = MockCurrencyService(storage: storage)
		let presenter = CurrencyListPresenter(currencyService: currencyService)
		presenter.prepare(selected: PlainCurrency(flag: nil, code: "test", name: "test"))

		XCTAssertEqual(presenter.cachedCrossCurrencyList?.count, 0)
    }

    func testSelectedCurrency() {
		let storage = MockCodableStorage()
		storage.addCrossCurrency(with: "test")
		let currencyService = MockCurrencyService(storage: storage)
		let presenter = CurrencyListPresenter(currencyService: currencyService)
		presenter.prepare(selected: PlainCurrency(flag: nil, code: "test", name: "test"))

		XCTAssertEqual(presenter.cachedCrossCurrencyList?.count, 1)
    }

    func testSelectedCurrencies() {
		let storage = MockCodableStorage()
		storage.addCrossCurrency(with: "test1")
		storage.addCrossCurrency(with: "test2")
		let currencyService = MockCurrencyService(storage: storage)
		let presenter = CurrencyListPresenter(currencyService: currencyService)
		presenter.prepare(selected: PlainCurrency(flag: nil, code: "test1", name: "test"))

		XCTAssertEqual(presenter.cachedCrossCurrencyList?.count, 2)
    }
}
