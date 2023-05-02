//
//  AppDelegate.swift
//  PokeGuide
//
//  Created by Beavean on 24.04.2023.
//
// TODO: remove prints
// TODO: If to guard

import SDWebImage
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = setupNavigationController()
        SDWebImageDownloader.shared.config.maxConcurrentDownloads = 5
        return true
    }

    private func setupNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: PokemonsViewController())
        navigationController.navigationBar.prefersLargeTitles = true
        guard let font = UIFont.boldTextCustomFont(size: 24) else { return navigationController }
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: Constants.Colors.mainAccentColor.color as Any
        ]
        navigationController.navigationBar.largeTitleTextAttributes = attributes
        navigationController.navigationBar.titleTextAttributes = attributes

        return navigationController
    }
}
