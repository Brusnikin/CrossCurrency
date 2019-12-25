//
//  CrossCurrencyListViewController.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol CrossCurrencyListViewModule: Presentable {
    typealias Completion = () -> Void
    typealias ShowCurrencyBlock = () -> Void

    var onFinish: Completion? { get set }
    var onAddCurrency: ShowCurrencyBlock? { get set }

	func configure()
	func addCurrencyPair()
}

extension CrossCurrencyListViewController: CrossCurrencyListViewModule {
	func configure() {
		presenter.suspendUpdates()
		presenter.obtainCrossCurrencyRates()
	}

	func addCurrencyPair() {
		presenter.obtainCrossCurrencyRates()
	}
}

class CrossCurrencyListViewController: UIViewController {

	// MARK: - Properties

	let presenter: CrossCurrencyListPresenterProtocol
	var onFinish: Completion?
	var onAddCurrency: ShowCurrencyBlock?

	private let tableHeaderView = CrossCurrencyTableHeaderView()
	private let tableView = UITableView()
	private lazy var tableAdapter = CrossCurrencyListTableAdapter(tableView: tableView)

	init(presenter: CrossCurrencyListPresenterProtocol) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		print("CrossCurrencyListViewController")
	}

    // MARK: - Lifecycle

	override func loadView() {
		view = tableView
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		tableAdapter.delegate = self

		tableHeaderView.delegate = self
		tableView.tableHeaderView = tableHeaderView
		tableView.separatorColor = .clear
		tableView.delegate = tableAdapter
		tableView.dataSource = tableAdapter
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if #available(iOS 13.0, *) {
			navigationController?.isModalInPresentation = true
		}

		navigationItem.hidesBackButton = true
		
		let frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 50))
		tableView.tableHeaderView?.frame = frame
	}
}

extension CrossCurrencyListViewController: CrossCurrencyListPresenterDelegate {
	func update(viewModelList: [CrossCurrencyViewModel]) {
		tableAdapter.update(viewModel: viewModelList)
	}
}

extension CrossCurrencyListViewController: CrossCurrencyListTableAdapterDelegate {
	func delete(crossCurrency: CrossCurrencyViewModel) {
		presenter.suspendUpdates()
		presenter.remove(crossCurrency: crossCurrency)
	}

	func hideEmptyTableView() {
		presenter.suspendUpdates()
		onFinish?()
	}
}

extension CrossCurrencyListViewController: CrossCurrencyTableHeaderViewDelegate {
	func showCurrencyListView() {
		presenter.suspendUpdates()
		onAddCurrency?()
	}
}
