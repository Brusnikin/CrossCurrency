//
//  AppDelegate.swift
//  Revolut
//
//  Created by Blashkin Georgiy on 12.11.2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	// MARK: Properties

    var window: UIWindow?
	private var appCoordinator: Coordinator?
	private let navigationController = UINavigationController()

	// MARK: - Lifecycle

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		if #available(iOS 13.0, *) {
			if UITraitCollection.current.userInterfaceStyle == .light {
				appearanceLight()
			}
		} else {
			appearanceLight()
		}

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

		let router = AppRouter(rootController: navigationController)
		appCoordinator = AppCoordinator(router: router)
		appCoordinator?.start()

		return true
	}

	private func appearanceLight() {
		UINavigationBar.appearance().barTintColor = .white
		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
		UINavigationBar.appearance().shadowImage = UIImage()
	}
}

