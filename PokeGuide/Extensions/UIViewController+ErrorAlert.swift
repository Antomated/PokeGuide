//
//  UIViewController+ErrorAlert.swift
//  PokeGuide
//
//  Created by Beavean on 02.05.2023.
//

import UIKit

extension UIViewController {
    func showInfoAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func showError(_ error: Error?) {
        let message = (error as? APIError)?.errorMessage ?? "Unknown error occurred."
        showInfoAlert(title: "Error", message: message)
    }
}
