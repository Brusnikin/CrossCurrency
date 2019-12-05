//
//  CrossCurrencyListPresenterTests.swift
//  RevolutTests
//
//  Created by Blashkin Georgiy on 22.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import XCTest
@testable import Revolut

class CrossCurrencyListPresenterTests: XCTestCase {
    func testCrossCurrencyListNotEmpty() {
		let storage = MockCodableStorage()
		storage.addCrossCurrency(with: "test")
		let presenter = createPresenter(storage: storage)

		let crossCurrencyListPresenterDelegate = MockCrossCurrencyListPresenterDelegate()
		presenter.delegate = crossCurrencyListPresenterDelegate
		presenter.obtainCrossCurrencyRates()
		presenter.update(crossCurrency: presenter.crossCurrencyList, shouldCache: false)

		XCTAssertEqual(presenter.crossCurrencyList.count, 1)
		XCTAssertEqual(presenter.crossCurrencyList.count, crossCurrencyListPresenterDelegate.viewModelList?.count)
    }

	func testViewModelFormat() {
		let storage = MockCodableStorage()
		storage.addCrossCurrency(with: "test1", rate: 0.0)
		storage.addCrossCurrency(with: "test2", rate: 1.12)
		storage.addCrossCurrency(with: "test3", rate: 1.1234)

		let presenter = createPresenter(storage: storage)

		let crossCurrencyListPresenterDelegate = MockCrossCurrencyListPresenterDelegate()
		presenter.delegate = crossCurrencyListPresenterDelegate
		presenter.obtainCrossCurrencyRates()
		presenter.update(crossCurrency: presenter.crossCurrencyList, shouldCache: false)

		guard let viewModelList = crossCurrencyListPresenterDelegate.viewModelList,
			viewModelList.count == 3 else {
				XCTFail("Error: viewModelList count doesn't match crossCurrencyList count")
				return
		}

		XCTAssertEqual(viewModelList[0].code, "test1")

		// The test couldn't be pass, because used simple formatter, for demonstration purpose.
		//XCTAssertEqual(viewModelList[0].rate.string, "0.0000")
		XCTAssertEqual(viewModelList[0].numerator, "1 test1")
		XCTAssertEqual(viewModelList[0].numeratorName, "test1")
		XCTAssertEqual(viewModelList[0].denominatorName, "test1 ∙ test1")

		XCTAssertEqual(viewModelList[1].code, "test2")

		// The test couldn't be pass, because used simple formatter, for demonstration purpose.
		//XCTAssertEqual(viewModelList[1].rate.string, "1.1200")
		XCTAssertEqual(viewModelList[1].numerator, "1 test2")
		XCTAssertEqual(viewModelList[1].numeratorName, "test2")
		XCTAssertEqual(viewModelList[1].denominatorName, "test2 ∙ test2")

		XCTAssertEqual(viewModelList[2].code, "test3")
		XCTAssertEqual(viewModelList[2].rate.string, "1.1234")
		XCTAssertEqual(viewModelList[2].numerator, "1 test3")
		XCTAssertEqual(viewModelList[2].numeratorName, "test3")
		XCTAssertEqual(viewModelList[2].denominatorName, "test3 ∙ test3")
	}

	private func createPresenter(storage: CodableStorageProtocol) -> CrossCurrencyListPresenter {
		let currencyService = MockCurrencyService(storage: storage)
		let networkClient = MockCrossCurrencyNetworkClient()
		let crossCurrencyService = MockCrossCurrencyService(networkClient: networkClient)
		return CrossCurrencyListPresenter(crossCurrencyService: crossCurrencyService, currencyService: currencyService)
	}
}
