//
//  CurrencyListBuilder.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

class CurrencyListBuilder {
	static func buildCurrencyListView() -> CurrencyListViewType {
		let serviceFactory = ServiceFactory()
		let presenter = CurrencyListPresenter(currencyService: serviceFactory.createCurrencyService())
		let currencyListViewController = CurrencyListViewController(presenter: presenter)
		presenter.delegate = currencyListViewController
		return currencyListViewController
	}
}
