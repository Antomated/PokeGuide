//
//  LoaderBarButtonItem.swift
//  PokeGuide
//
//  Created by Beavean on 04.05.2023.
//

import UIKit

final class LoaderBarButtonItem: UIBarButtonItem {
    private var activityIndicator: UIActivityIndicatorView

    override init() {
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        super.init()
        activityIndicator.color = Constants.Colors.mainAccentColor.color
        customView = activityIndicator
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
