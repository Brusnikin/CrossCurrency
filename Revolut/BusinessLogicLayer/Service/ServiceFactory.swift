//
//  ServiceFactory.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 15.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol ServiceFactoryProtocol {
	func createCurrencyService() -> CurrencyServiceProtocol
	func createCrossCurrencyService() -> CrossCurrencyServiceProtocol & CrossCurrencyService
}

final class ServiceFactory: ServiceFactoryProtocol {
	func createCurrencyService() -> CurrencyServiceProtocol {
		let path = URL(fileURLWithPath: NSTemporaryDirectory())
		let disk = DiskStorage(path: path)
		let storage = CodableStorage(storage: disk)
		return CurrencyService(storage: storage)
	}

	func createCrossCurrencyService() -> CrossCurrencyServiceProtocol & CrossCurrencyService {
		let networkClient = CrossCurrencyNetworkClient()
		return CrossCurrencyService(networkClient: networkClient)
	}
}
