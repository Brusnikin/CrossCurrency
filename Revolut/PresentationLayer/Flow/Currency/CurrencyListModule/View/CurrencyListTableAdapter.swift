//
//  CurrencyListTableAdapter.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol CurrencyListTableAdapterProtocol: class {
	func update(currency list: [PlainCurrency])
	func select(currencyList: [PlainCurrency])
}

protocol CurrencyListTableAdapterDelegate: class {
	func selected(currency: PlainCurrency)
}

final class CurrencyListTableAdapter: NSObject {

	// MARK: - Properties

	weak var delegate: CurrencyListTableAdapterDelegate?

	private var currencyList = [PlainCurrency]()
	private var selectedCurrencyList = [PlainCurrency]()
	private let tableView: UITableView

	// MARK: - Construction

	init(tableView: UITableView) {
		let currencyCellNib = UINib(nibName: CurrencyTableViewCell.reuseIdentifier, bundle: nil)
		tableView.register(currencyCellNib, forCellReuseIdentifier: CurrencyTableViewCell.reuseIdentifier)
		self.tableView = tableView
		
		super.init()
	}
}

extension CurrencyListTableAdapter: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		delegate?.selected(currency: currencyList[indexPath.row])
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}
}

extension CurrencyListTableAdapter: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currencyList.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.reuseIdentifier, for: indexPath) as? CurrencyTableViewCell else {
			return UITableViewCell()
		}

		let currency = currencyList[indexPath.row]
		cell.configure(with: currency)

		if selectedCurrencyList.contains(where: { $0.code == currency.code }) {
			cell.select(currency: currency)
		}

		return cell
	}
}

extension CurrencyListTableAdapter: CurrencyListTableAdapterProtocol {
	func update(currency list: [PlainCurrency]) {
		currencyList.append(contentsOf: list)
	}

	func select(currencyList: [PlainCurrency]) {
		selectedCurrencyList = currencyList
		tableView.reloadData()
	}
}
