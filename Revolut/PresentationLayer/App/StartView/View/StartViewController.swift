//
//  StartViewController.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol StartViewControllerProtocol: class {
	func configure()
}

protocol StartViewControllerDelegate: class {
	func showCurrencyListView()
	func showCrossCurrencyListView()
}

typealias StartViewType = StartViewControllerProtocol & StartViewController

class StartViewController: UIViewController {

	// MARK: - Properties

	weak var delegate: StartViewControllerDelegate?

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

extension StartViewController: StartViewControllerProtocol {
	func configure() {
		presenter.checkCrossCurrencyList()
	}
}

extension StartViewController: StartViewPresenterDelegate {
	func shouldShowCrossCurrencyList() {
		delegate?.showCrossCurrencyListView()
	}
}

extension StartViewController: StartContentViewDelegate {
	func addAction() {
		delegate?.showCurrencyListView()
	}
}
