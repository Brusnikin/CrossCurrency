//
//  CurrencyCoordinator.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol CurrencyCoordinatorProtocol: class {
    typealias Completion = () -> Void

    var onFinish: Completion? { get set }
	var onCancel: Completion? { get set }
}

final class CurrencyCoordinator {

	// MARK: - Properties

	var childCoordinators = [Coordinator]()
	var onFinish: Completion?
	var onCancel: Completion?

	private(set) var router: Routable
	private let currencyList: [PlainCurrency]

	// MARK: - Construction

	init(router: Routable, currencyList: [PlainCurrency]) {
		self.router = router
		self.currencyList = currencyList
	}

	deinit {
		print("CurrencyCoordinator")
	}

	// MARK: - Functions

	private func showCurrencyListView() {
		let currencyListViewModule = createCurrencyListViewModule()
		router.setRootModule(currencyListViewModule, animated: false)
	}

	private func showCurrencyListView(selected currency: PlainCurrency) {
		let currencyListViewModule = createCurrencyListViewModule()
		currencyListViewModule.select(currency: currency)
		router.push(currencyListViewModule)
	}

	private func createCurrencyListViewModule() -> CurrencyListViewModule {
		let currencyListViewModule = CurrencyListModuleBuilder.build()
		currencyListViewModule.onCurrencySelect = showCurrencyListView
		currencyListViewModule.onFinish = onFinish
		currencyListViewModule.configure(currency: currencyList)
		return currencyListViewModule
	}
}

extension CurrencyCoordinator: Coordinator, CurrencyCoordinatorProtocol {
	func start() {
		showCurrencyListView()
	}
}
