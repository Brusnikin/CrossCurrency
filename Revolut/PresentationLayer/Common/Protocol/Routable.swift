//
//  Routable.swift
//  Revolut
//
//  Created by George Blashkin on 25.12.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

protocol Routable: Presentable {
    typealias Completion = () -> Void

	var onCancel: Completion? { get set }

    func present(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool)
    func popModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func setRootModule(_ module: Presentable?, animated: Bool)
}

extension Routable {
    func present(_ module: Presentable?, animated: Bool = true) {
        present(module, animated: animated)
    }

    func push(_ module: Presentable?, animated: Bool = true) {
        push(module, animated: true)
    }

	func popModule(animated: Bool = true) {
        popModule(animated: animated)
    }

    func dismissModule(animated: Bool = true, completion: (() -> Void)? = nil) {
        dismissModule(animated: animated, completion: completion)
    }

    func setRootModule(_ module: Presentable?, animated: Bool = true) {
        setRootModule(module, animated: animated)
    }
}
