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

	var window: RevolutWindow?
	private var appCoordinator: Coordinator?
	private let navigationController = UINavigationController()

	// MARK: - Lifecycle

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window = RevolutWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

		let router = AppRouter(rootController: navigationController)
		appCoordinator = AppCoordinator(router: router)
		appCoordinator?.start()

		return true
	}
}
