//
//  MockCrossCurrencyService.swift
//  RevolutTests
//
//  Created by Blashkin Georgiy on 22.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

@testable import Revolut

class MockCrossCurrencyService: CrossCurrencyServiceProtocol {

	private let networkClient: NetworkClientProtocol

	init(networkClient: NetworkClientProtocol) {
		self.networkClient = networkClient
	}

	func request(crossCurrency list: [PlainCrossCurrency]) {
		
	}
}
