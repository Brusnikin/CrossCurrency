//
//  CrossCurrencyNetworkClient.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 14.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol NetworkClientProtocol {
    typealias Success = (_ data: Data) -> Void
    typealias Failure = (_ error: Error) -> Void

	func request(crossCurrency list: [PlainCrossCurrency], onSuccess: @escaping Success, onFailure: @escaping Failure)
}

class CrossCurrencyNetworkClient: NetworkClientProtocol {

	deinit {
		print("CrossCurrencyNetworkClient")
	}

	// MARK: - Functions

	func request(crossCurrency list: [PlainCrossCurrency], onSuccess: @escaping Success, onFailure: @escaping Failure) {
		let request = createRequest(queryItems: list)
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let data = data { onSuccess(data) }
			if let error = error { onFailure(error) }
		}.resume()
	}

	private func createRequest(queryItems: [PlainCrossCurrency]) -> URLRequest {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = "europe-west1-revolut-230009.cloudfunctions.net"
		urlComponents.path = "/revolut-ios"
		urlComponents.queryItems = queryItems.map { URLQueryItem(name: "pairs", value: $0.code) }
		guard let url = urlComponents.url else { fatalError("URL could not be configured.") }
		return URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 1.0)
	}
}
