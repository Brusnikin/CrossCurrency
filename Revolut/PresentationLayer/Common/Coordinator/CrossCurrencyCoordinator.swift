//
//  CrossCurrencyCoordinator.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 13.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol CrossCurrencyCoordinatorProtocol: class {
	typealias Completion = () -> Void

	var onFinish: Completion? { get set }
}

final class CrossCurrencyCoordinator {

	// MARK: - Properties

	var childCoordinators = [Coordinator]()
	var onFinish: Completion?

	private(set) var router: Routable
	private let currencyList: [PlainCurrency]
	private var crossCurrencyListViewModule = CrossCurrencyListModuleBuilder.build()

	// MARK: - Construction

	init(router: Routable, currencyList: [PlainCurrency]) {
		self.router = router
		self.currencyList = currencyList
	}

	deinit {
		print("CrossCurrencyCoordinator")
	}

	// MARK: - Functions

	private func showCrossCurrencyListView() {
		crossCurrencyListViewModule.configure()
		crossCurrencyListViewModule.onAddCurrency = { [unowned self] in
			self.runCurrencyFlow()
		}
		crossCurrencyListViewModule.onFinish = onFinish
		router.setRootModule(crossCurrencyListViewModule, animated: false)
	}

	private func runCurrencyFlow() {
		let currencyRouter = CurrencyRouter()
		let currencyCoordinator = CurrencyCoordinator(router: currencyRouter, currencyList: currencyList)
		currencyCoordinator.onFinish = { [weak currencyCoordinator, unowned self] in
			self.router.dismissModule(animated: true) {
				self.crossCurrencyListViewModule.addCurrencyPair()
				currencyCoordinator?.router.setRootModule(nil)
				self.removeChild(currencyCoordinator)
			}
		}

		router.onCancel = { [weak currencyCoordinator, unowned self] in
			self.crossCurrencyListViewModule.addCurrencyPair()
			currencyCoordinator?.router.setRootModule(nil)
			self.removeChild(currencyCoordinator)
		}

		self.router.present(currencyCoordinator.router, animated: true)
		currencyCoordinator.start()
		addChild(currencyCoordinator)
	}
}

extension CrossCurrencyCoordinator: Coordinator, CrossCurrencyCoordinatorProtocol {
	func start() {
		showCrossCurrencyListView()
	}
}
