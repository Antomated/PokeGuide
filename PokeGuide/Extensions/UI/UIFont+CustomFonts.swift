//
//  UIFont+CustomFonts.swift
//  PokeGuide
//
//  Created by Beavean on 25.04.2023.
//

import UIKit

extension UIFont {
    static func regularTextCustomFont(size: CGFloat = 14) -> UIFont? {
        if let font = UIFont(name: Constants.Fonts.latoRegular, size: size) {
            return font
        } else {
            print("\(#function) not found")
            return nil
        }
    }

    static func boldTextCustomFont(size: CGFloat = 15) -> UIFont? {
        if let font = UIFont(name: Constants.Fonts.latoBold, size: size) {
            return font
        } else {
            print("\(#function) not found")
            return nil
        }
    }
}
