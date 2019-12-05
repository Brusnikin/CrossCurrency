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

	private let navigationController: UINavigationController
	private var currencyList = [PlainCurrency]()

	private lazy var startViewController: StartViewType = {
		let startViewController = StartViewBuilder.buildStartView()
		startViewController.delegate = self
		return startViewController
	}()

	// MARK: - Construction

	init(with navigationController: UINavigationController) {
		self.navigationController = navigationController
		if let currencyList = convertibleCurrencyList() {
			self.currencyList = currencyList
		}
	}

	// MARK: - Functions

	private func showStartView() {
		startViewController.configure()
		navigationController.pushViewController(startViewController, animated: false)
	}
	
	private func runCurrencyFlow() {
		let currencyCoordinator = CurrencyCoordinator(with: navigationController, currencyList: currencyList)
		currencyCoordinator.delegate = self
		currencyCoordinator.start()
		addChild(currencyCoordinator)
	}

	private func runCrossCurrencyFlow() {
		let crossCurrencyCoordinator = CrossCurrencyCoordinator(with: navigationController, currencyList: currencyList)
		crossCurrencyCoordinator.delegate = self
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

extension AppCoordinator: StartViewControllerDelegate {
	func showCurrencyListView() {
		runCurrencyFlow()
	}

	func showCrossCurrencyListView() {
		runCrossCurrencyFlow()
	}
}

extension AppCoordinator: CurrencyCoordinatorDelegate, CrossCurrencyCoordinatorDelegate {
	func finish(flow: Coordinator) {
		removeChild(flow)

		switch flow {
		case is CurrencyCoordinator:
			print("The CurrencyFlow is finish")
			startViewController.configure()
		case is CrossCurrencyCoordinator:
			print("The CrossCurrencyFlow is finish")
		default:
			print("can't cast flow")
		}
	}
}
