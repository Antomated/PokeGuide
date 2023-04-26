//
//  UIViewController+Title.swift
//  PokeGuide
//
//  Created by Beavean on 25.04.2023.
//

import UIKit

extension UIViewController {
    func configureTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        if let font = UIFont.boldTextCustomFont(size: 24) {
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: Constants.Colors.mainLabelColor.color as Any
            ]
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
            navigationController?.navigationBar.titleTextAttributes = attributes
        }
    }
}
