//
//  CrossCurrencyListModuleBuilder.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol CrossCurrencyListViewModule: Presentable {
    typealias Completion = () -> Void
    typealias ShowCurrencyBlock = () -> Void

    var onFinish: Completion? { get set }
    var onAddCurrency: ShowCurrencyBlock? { get set }

	func configure()
	func addCurrencyPair()
}

class CrossCurrencyListModuleBuilder {
	static func build() -> CrossCurrencyListViewModule {
		let serviceFactory = ServiceFactory()
		let crossCurrencyService = serviceFactory.createCrossCurrencyService()
		let presenter = CrossCurrencyListPresenter(crossCurrencyService: crossCurrencyService,
												   currencyService: serviceFactory.createCurrencyService())
		crossCurrencyService.delegate = presenter
		let crossCurrencyListView = CrossCurrencyListViewController(presenter: presenter)
		presenter.delegate = crossCurrencyListView
		return crossCurrencyListView
	}
}
