//
//  CrossCurrencyViewModel.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 15.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

struct CrossCurrencyViewModel {
	var code: String
	var rate: NSAttributedString
	var numerator: String
	var numeratorName: String
	var denominatorName: String
}
