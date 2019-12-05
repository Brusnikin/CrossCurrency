//
//  StartViewBuilder.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 13.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

class StartViewBuilder {
	static func buildStartView() -> StartViewType {
		let serviceFactory = ServiceFactory()
		let presenter = StartViewPresenter(currencyService: serviceFactory.createCurrencyService())
		let startViewController = StartViewController(presenter: presenter)
		presenter.delegate = startViewController
		return startViewController
	}
}
