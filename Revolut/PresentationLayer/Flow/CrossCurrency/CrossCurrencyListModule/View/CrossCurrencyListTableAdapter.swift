//
//  CrossCurrencyListTableAdapter.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol CrossCurrencyListTableAdapterProtocol: class {
	func update(viewModel list: [CrossCurrencyViewModel])
}

protocol CrossCurrencyListTableAdapterDelegate: class {
	func delete(crossCurrency: CrossCurrencyViewModel)
	func hideEmptyTableView()
}

class CrossCurrencyListTableAdapter: NSObject {

	// MARK: - Properties

	weak var delegate: CrossCurrencyListTableAdapterDelegate?

	private let tableView: UITableView
	private var viewModelList = [CrossCurrencyViewModel]()

	// MARK: - Construction

	init(tableView: UITableView) {
		let currencyCellNib = UINib(nibName: CrossCurrencyTableViewCell.reuseIdentifier, bundle: nil)
		tableView.register(currencyCellNib, forCellReuseIdentifier: CrossCurrencyTableViewCell.reuseIdentifier)
		
		self.tableView = tableView

		super.init()
	}

	// MARK: - Functions

	private func insert(viewModel list: [CrossCurrencyViewModel]) {
		if list.count > viewModelList.count,
			let viewModel = list.first {
			viewModelList.insert(viewModel, at: 0)
			tableView.beginUpdates()
			tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
			tableView.endUpdates()
		}
	}

	private func configureVisibleRows(at indexPaths: [IndexPath]) {
		for indexPath in indexPaths {
			if let cell = tableView.cellForRow(at: indexPath) as? CrossCurrencyTableViewCell {
				cell.configure(with: viewModelList[indexPath.row])
			}
		}
	}

	private func removeVisibleRow(at indexPath: IndexPath) {
		let crossCurrency = viewModelList[indexPath.row]
		delegate?.delete(crossCurrency: crossCurrency)
		viewModelList.remove(at: indexPath.row)

		tableView.beginUpdates()
		tableView.deleteRows(at: [indexPath], with: .automatic)
		tableView.endUpdates()

		if viewModelList.isEmpty {
			delegate?.hideEmptyTableView()
		}
	}
}

extension CrossCurrencyListTableAdapter: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			removeVisibleRow(at: indexPath)
		}
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
}

extension CrossCurrencyListTableAdapter: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModelList.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CrossCurrencyTableViewCell.reuseIdentifier, for: indexPath) as? CrossCurrencyTableViewCell else {
			return UITableViewCell()
		}

		cell.configure(with: viewModelList[indexPath.row])

		return cell
	}
}

extension CrossCurrencyListTableAdapter: CrossCurrencyListTableAdapterProtocol {
	func update(viewModel list: [CrossCurrencyViewModel]) {
		guard let visibleRowsIndexPaths = tableView.indexPathsForVisibleRows,
			!visibleRowsIndexPaths.isEmpty else {
				viewModelList = list
				tableView.reloadData()
				return
		}

		insert(viewModel: list)
		if viewModelList.count == list.count {
			viewModelList = list
			configureVisibleRows(at: visibleRowsIndexPaths)
		}
	}
}
