//
//  CrossCurrencyTableHeaderView.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 13.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol CrossCurrencyTableHeaderViewDelegate: class {
	func showCurrencyListView()
}

final class CrossCurrencyTableHeaderView: UIView {

    // MARK: - Properties

	weak var delegate: CrossCurrencyTableHeaderViewDelegate?

	private let button = RevolutButton()

    // MARK: - Construction

	override init(frame: CGRect) {
		super.init(frame: frame)

		button.contentHorizontalAlignment = .left
		button.setTitle("Add currency pair", for: .normal)
		button.setImage(#imageLiteral(resourceName: "Plus.pdf"), for: .normal)
		button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
		button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
		button.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
		addSubview(button)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    // MARK: - Lifecycle

	override func layoutSubviews() {
		super.layoutSubviews()
		button.frame = bounds
	}

	// MARK: - Action

	@objc private func addAction(sender: UIButton) {
		delegate?.showCurrencyListView()
	}
}
