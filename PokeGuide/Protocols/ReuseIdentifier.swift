//
//  ReuseIdentifier.swift
//  PokeGuide
//
//  Created by Beavean on 06.05.2023.
//

import Foundation

protocol ReuseIdentifier {}

extension ReuseIdentifier {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
