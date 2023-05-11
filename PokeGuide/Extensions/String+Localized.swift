//
//  String+Localized.swift
//  PokeGuide
//
//  Created by Beavean on 11.05.2023.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
