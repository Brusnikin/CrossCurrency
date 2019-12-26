//
//  StartContentView.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 18.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol StartContentViewProtocol: class {}

protocol StartContentViewDelegate: class {
	func addAction()
}

typealias StartContentViewType = StartContentViewProtocol & StartContentView

class StartContentView: UIView, StartContentViewProtocol {

	// MARK: - Properties

	weak var delegate: StartContentViewDelegate?

	// MARK: - Outlets

	@IBOutlet private weak var addImageView: UIImageView! {
		didSet {
			addImageView.image = #imageLiteral(resourceName: "Plus.pdf")
			addImageView.isUserInteractionEnabled = true
			addImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAction(sender:))))
		}
	}

	@IBOutlet private weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = "Add currency pair"
			titleLabel.textAlignment = .center
			titleLabel.font = UIFont.systemFont(ofSize: 14)
			titleLabel.textColor = .systemBlue
			titleLabel.isUserInteractionEnabled = true
			titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAction(sender:))))
		}
	}
	@IBOutlet private weak var subtitleLabel: UILabel! {
		didSet {
			subtitleLabel.font = UIFont.systemFont(ofSize: 14)
			subtitleLabel.text = "Choose a currency pair to compare their live rates"
			subtitleLabel.numberOfLines = 0
			subtitleLabel.textAlignment = .center
			subtitleLabel.textColor = .darkGray
		}
	}

	@objc func addAction(sender: UITapGestureRecognizer) {
		select()
		delegate?.addAction()
	}

	// MARK: - Functions

	private func select() {
		UIView.transition(with: titleLabel,
						  duration: 0.25,
						  options: .transitionCrossDissolve,
						  animations: {
							self.titleLabel.textColor = .darkGray
		}) { completed in
			if completed {
				self.titleLabel.textColor = .systemBlue
			}
		}
	}
}
