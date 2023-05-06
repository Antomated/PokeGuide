//
//  AppDelegate.swift
//  PokeGuide
//
//  Created by Beavean on 24.04.2023.
//

import SDWebImage
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        SDWebImageDownloader.shared.config.maxConcurrentDownloads = 5
        window?.makeKeyAndVisible()
        window?.rootViewController = setupNavigationController()
        return true
    }

    private func setupNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: PokemonsViewController())
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        navigationController.interactivePopGestureRecognizer?.delegate = nil
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
