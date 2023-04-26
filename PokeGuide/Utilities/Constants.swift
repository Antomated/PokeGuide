//
//  Constants.swift
//  PokeGuide
//
//  Created by Beavean on 25.04.2023.
//
// TODO: Lightning

import UIKit

enum Constants {
    enum StyleDefaults {
        static let itemHeight: CGFloat = 52
        static let outerPadding: CGFloat = 16
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
        // TODO: Add
        case placeholder

        var image: UIImage? { UIImage(named: rawValue) }
    }

    enum Fonts {
        // TODO: Add Lato
        static let latoRegular = "Lato-Regular"
        static let latoBold = "Lato-Bold"
    }
}
