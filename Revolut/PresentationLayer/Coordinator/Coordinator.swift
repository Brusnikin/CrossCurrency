//
//  Coordinator.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }

    func start()
    func addChild(_ coordinator: Coordinator)
    func removeChild(_ coordinator: Coordinator?)
}

extension Coordinator {
    func addChild(_ coordinator: Coordinator) {
        if !childCoordinators.contains(where: { $0 === coordinator }) {
            childCoordinators.append(coordinator)
        }
    }

    func removeChild(_ coordinator: Coordinator?) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
