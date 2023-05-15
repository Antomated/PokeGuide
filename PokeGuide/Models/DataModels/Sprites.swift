//
//  Sprites.swift
//  PokeGuide
//
//  Created by Beavean on 09.05.2023.
//

import Foundation

struct Sprites: Decodable {
    let frontDefault: String?
    let other: Other?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}
