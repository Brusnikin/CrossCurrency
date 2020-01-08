//
//  AppCoordinator.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

class AppCoordinator {

	// MARK: - Properties

	var childCoordinators = [Coordinator]()

	private(set) var router: Routable
	private var currencyList = [PlainCurrency]()
	private var startViewModule = StartViewModuleBuilder.build()

	// MARK: - Construction

	init(router: Routable) {
		self.router = router
		if let currencyList = convertibleCurrencyList() {
			self.currencyList = currencyList
		}
	}

	// MARK: - Functions

	private func showStartView() {
		startViewModule.onAddCurrency = runCurrencyFlow
		startViewModule.onFinish = runCrossCurrencyFlow
		router.setRootModule(startViewModule, animated: false)
		startViewModule.configure()
	}
	
	private func runCurrencyFlow() {
		let currencyRouter = CurrencyRouter()
		let currencyCoordinator = CurrencyCoordinator(router: currencyRouter, currencyList: currencyList)
		currencyCoordinator.onFinish = { [weak currencyCoordinator, unowned self] in
			self.router.dismissModule(animated: true) {
				currencyCoordinator?.router.setRootModule(nil)
				self.removeChild(currencyCoordinator)
				self.runCrossCurrencyFlow()
			}
		}

		router.onCancel = { [weak currencyCoordinator, unowned self] in
			currencyCoordinator?.router.setRootModule(nil)
			self.removeChild(currencyCoordinator)
		}

		router.present(currencyCoordinator.router, animated: true)
		currencyCoordinator.start()
		addChild(currencyCoordinator)
	}

	private func runCrossCurrencyFlow() {
		let currencyRouter = CurrencyRouter()
		let crossCurrencyCoordinator = CrossCurrencyCoordinator(router: currencyRouter, currencyList: currencyList)
		crossCurrencyCoordinator.onFinish = { [weak crossCurrencyCoordinator, unowned self] in
			self.router.dismissModule(animated: true) {
				crossCurrencyCoordinator?.router.setRootModule(nil)
				self.removeChild(crossCurrencyCoordinator)
			}
		}

		router.present(crossCurrencyCoordinator.router, animated: true)
		crossCurrencyCoordinator.start()
		addChild(crossCurrencyCoordinator)
	}

	private func convertibleCurrencyList() -> [PlainCurrency]? {
		guard let path = Bundle.main.path(forResource: "codes", ofType: "json") else {
			return nil
		}
		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
			if let codes = json as? [String]  {
				return codes.map { code -> PlainCurrency in
					let name = Locale.current.localizedString(forCurrencyCode: code) ?? " "
					return PlainCurrency(flag: nil, code: code, name: name)
				}
			}
		} catch {
			fatalError("JSON could not be serialized.")
		}
		return nil
	}
}

extension AppCoordinator: Coordinator {
	func start() {
		showStartView()
	}
}
