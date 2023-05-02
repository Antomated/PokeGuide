//
//  Constants.swift
//  PokeGuide
//
//  Created by Beavean on 25.04.2023.
//

import UIKit

enum Constants {
    enum StyleDefaults {
        static let innerPadding: CGFloat = 8
    }

    enum Colors: String, CaseIterable {
        case cellBackgroundColor
        case mainAccentColor
        case mainLabelColor
        case screenBackgroundColor
        case secondaryLabelColor
        case shadowColor

        var color: UIColor? { UIColor(named: rawValue) }
    }

    enum Images: String {
        case placeholder

        var image: UIImage? { UIImage(named: rawValue) }
    }

    enum Fonts {
        static let latoRegular = "Lato-Regular"
        static let latoBold = "Lato-Bold"
    }
}
