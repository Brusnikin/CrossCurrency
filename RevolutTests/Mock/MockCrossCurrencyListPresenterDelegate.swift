//
//  MockCrossCurrencyListPresenterDelegate.swift
//  RevolutTests
//
//  Created by Blashkin Georgiy on 22.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

@testable import Revolut

class MockCrossCurrencyListPresenterDelegate: CrossCurrencyListPresenterDelegate {

	private(set) var viewModelList: [CrossCurrencyViewModel]?

	func update(viewModelList: [CrossCurrencyViewModel]) {
		self.viewModelList = viewModelList
	}
}
