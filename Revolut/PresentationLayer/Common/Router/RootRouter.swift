//
//  RootRouter.swift
//  Revolut
//
//  Created by George Blashkin on 04.01.2020.
//  Copyright © 2020 Blashkin Georgiy. All rights reserved.
//

import UIKit
import Foundation

protocol Presentation: UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate {

    typealias Completion = () -> Void

	var onCancel: Completion? { get set }
}

class RootRouter: NSObject {
	var onCancel: Completion?

}
extension RootRouter: Presentation {
	func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		onCancel?()
	}

	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

	}
}
