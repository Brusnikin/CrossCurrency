//
//  CodableStorage.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 13.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol CodableStorageProtocol: class {
	func fetch<T: Decodable>(for key: String) throws -> T
	func save<T: Encodable>(_ value: T, for key: String) throws
	func save<T: Encodable>(_ value: T, for key: String, handler: @escaping Handler<Data>) throws
}

class CodableStorage {

	// MARK: - Properties

    private let storage: Storage
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

	// MARK: - Construction

    init(storage: Storage,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
    }
}

extension CodableStorage: CodableStorageProtocol {
    func fetch<T: Decodable>(for key: String) throws -> T {
        let data = try storage.fetchValue(for: key)
        return try decoder.decode(T.self, from: data)
    }

    func save<T: Encodable>(_ value: T, for key: String) throws {
        let data = try encoder.encode(value)
        try storage.save(value: data, for: key)
    }

    func save<T: Encodable>(_ value: T, for key: String, handler: @escaping Handler<Data>) throws {
        let data = try encoder.encode(value)
		storage.save(value: data, for: key, handler: handler)
    }
}
