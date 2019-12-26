//
//  StartViewController.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

	// MARK: - Properties

	var onFinish: Completion?
	var onAddCurrency: ShowCurrencyBlock?
	let presenter: StartViewPresenterProtocol

	private lazy var startContentViewType: StartContentViewType? = {
		let startContentView = Bundle.main.loadNibNamed("StartContentView", owner: nil, options: [:])?.first as? StartContentViewType
		return startContentView
	}()

	// MARK: - Lifecycle

	override func loadView() {
		if let startView = startContentViewType {
			startView.delegate = self
			view = startView
			if #available(iOS 13.0, *) {
				view.backgroundColor = .systemBackground
			} else {
				// Fallback on earlier versions
			}
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = true
	}

	// MARK: - Construction

	init(presenter: StartViewPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		print("StartViewController")
	}
}

extension StartViewController: StartViewModule {
	func configure() {
		presenter.checkCrossCurrencyList()
	}
}

extension StartViewController: StartViewPresenterDelegate {
	func shouldShowCrossCurrencyList() {
		onFinish?()
	}
}

extension StartViewController: StartContentViewDelegate {
	func addAction() {
		onAddCurrency?()
	}
}
