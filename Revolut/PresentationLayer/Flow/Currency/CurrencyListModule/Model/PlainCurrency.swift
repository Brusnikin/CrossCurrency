//
//  PlainCurrency.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

struct PlainCurrency: Codable {
	var flag: String?
	var code: String
	var name: String
}
