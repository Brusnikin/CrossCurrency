//
//  CurrencyListModuleBuilder.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol CurrencyListViewModule: class, Presentable {
    typealias Completion = () -> Void
    typealias CurrencySelectedBlock = (PlainCurrency) -> Void

    var onCurrencySelect: CurrencySelectedBlock? { get set }
    var onFinish: Completion? { get set }
    var onCancel: Completion? { get set }

	func configure(currency list: [PlainCurrency])
	func select(currency: PlainCurrency)
}

class CurrencyListModuleBuilder {
	static func build() -> CurrencyListViewModule {
		let serviceFactory = ServiceFactory()
		let presenter = CurrencyListPresenter(currencyService: serviceFactory.createCurrencyService())
		let currencyListViewController = CurrencyListViewController(presenter: presenter)
		presenter.delegate = currencyListViewController
		return currencyListViewController
	}
}
