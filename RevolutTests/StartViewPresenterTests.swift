//
//  StartViewPresenterTests.swift
//  RevolutTests
//
//  Created by Blashkin Georgiy on 22.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import XCTest
@testable import Revolut

class StartViewPresenterTests: XCTestCase {
    func testCheckCrossCurrencyList() {
		let storage = MockCodableStorage()
		storage.addCrossCurrency(with: "test")
		let currencyService = MockCurrencyService(storage: storage)
		let presenter = StartViewPresenter(currencyService: currencyService)
		presenter.checkCrossCurrencyList()

		XCTAssertEqual(presenter.crossCurrencyList?.count, 1)
    }
}
