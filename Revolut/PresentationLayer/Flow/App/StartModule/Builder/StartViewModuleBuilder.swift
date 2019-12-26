//
//  StartViewModuleBuilder.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 13.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol StartViewModule: Presentable {
	typealias Completion = () -> Void
	typealias ShowCurrencyBlock = () -> Void

	var onFinish: Completion? { get set }
	var onAddCurrency: ShowCurrencyBlock? { get set }

	func configure()
}

class StartViewModuleBuilder {
	static func build() -> StartViewModule {
		let serviceFactory = ServiceFactory()
		let presenter = StartViewPresenter(currencyService: serviceFactory.createCurrencyService())
		let startViewController = StartViewController(presenter: presenter)
		presenter.delegate = startViewController
		return startViewController
	}
}
