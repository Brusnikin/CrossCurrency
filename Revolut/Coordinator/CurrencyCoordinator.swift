//
//  CurrencyCoordinator.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol CurrencyCoordinatorDelegate: class {
	func finish(flow: Coordinator)
}

class CurrencyCoordinator {

	// MARK: - Properties

	var childCoordinators = [Coordinator]()
	weak var delegate: CurrencyCoordinatorDelegate?

	private let navigationController: UINavigationController
	private let currencyListNavigationController = UINavigationController()
	private let currencyList: [PlainCurrency]

	// MARK: - Construction

	init(with navigationController: UINavigationController, currencyList: [PlainCurrency]) {
		self.navigationController = navigationController
		self.currencyList = currencyList
	}

	deinit {
		print("CurrencyCoordinator")
	}

	// MARK: - Functions

	private func showCurrencyListView() {
		let currencyListView = configuredCurrencyListView()
		currencyListNavigationController.pushViewController(currencyListView, animated: false)
		navigationController.present(currencyListNavigationController, animated: true, completion: nil)
	}

	private func showCurrencyListView(selected currency: PlainCurrency) {
		let currencyListView = configuredCurrencyListView()
		currencyListView.select(currency: currency)
		currencyListNavigationController.pushViewController(currencyListView, animated: true)
	}

	private func configuredCurrencyListView() -> CurrencyListViewType {
		let currencyListView = CurrencyListBuilder.buildCurrencyListView()
		currencyListView.delegate = self
		currencyListView.configure(currency: currencyList)
		return currencyListView
	}
}

extension CurrencyCoordinator: Coordinator {
	func start() {
		showCurrencyListView()
	}
}

extension CurrencyCoordinator: CurrencyListViewControllerDelegate {
	func show(selected currency: PlainCurrency) {
		showCurrencyListView(selected: currency)
	}
	
	func showCrossCurrencyList() {
		navigationController.dismiss(animated: true) {
			self.currencyListNavigationController.viewControllers = []
			self.delegate?.finish(flow: self)
		}
	}

	func finishFlow() {
		delegate?.finish(flow: self)
	}
}
