//
//  CrossCurrencyCoordinator.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 13.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol CrossCurrencyCoordinatorDelegate: class {
	func finish(flow: Coordinator)
}

class CrossCurrencyCoordinator {

	// MARK: - Properties

	var childCoordinators = [Coordinator]()
	weak var delegate: CrossCurrencyCoordinatorDelegate?

	private let currencyList: [PlainCurrency]
	private let navigationController: UINavigationController
	private let crossCurrencyListNavigationController = UINavigationController()

	private lazy var crossCurrencyListView: CrossCurrencyListViewType = {
		let crossCurrencyListView = CrossCurrencyListBuilder.buildCrossCurrencyListView()
		crossCurrencyListView.delegate = self
		crossCurrencyListView.configure()
		return crossCurrencyListView
	}()

	// MARK: - Construction

	init(with navigationController: UINavigationController, currencyList: [PlainCurrency]) {
		self.navigationController = navigationController
		self.currencyList = currencyList
	}

	deinit {
		print("CrossCurrencyCoordinator")
	}

	// MARK: - Functions

	private func showCrossCurrencyListView() {
		crossCurrencyListNavigationController.pushViewController(crossCurrencyListView, animated: false)
		navigationController.modalTransitionStyle = .crossDissolve
		navigationController.present(crossCurrencyListNavigationController, animated: true, completion: nil)
	}

	private func runCurrencyFlow() {
		let currencyCoordinator = CurrencyCoordinator(with: crossCurrencyListNavigationController, currencyList: currencyList)
		currencyCoordinator.delegate = self
		currencyCoordinator.start()
		addChild(currencyCoordinator)
	}
}

extension CrossCurrencyCoordinator: Coordinator {
	func start() {
		showCrossCurrencyListView()
	}
}

extension CrossCurrencyCoordinator: CrossCurrencyListViewControllerDelegate {
	func showStartView() {
		navigationController.dismiss(animated: true) {
			self.crossCurrencyListNavigationController.viewControllers = []
		}
		delegate?.finish(flow: self)
	}

	func showCurrencyListView() {
		runCurrencyFlow()
	}
}

extension CrossCurrencyCoordinator: CurrencyCoordinatorDelegate {
	func finish(flow: Coordinator) {
		removeChild(flow)
		crossCurrencyListView.addCurrencyPair()
	}
}
