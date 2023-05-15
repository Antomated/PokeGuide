//
//  OfficialArtwork.swift
//  PokeGuide
//
//  Created by Beavean on 09.05.2023.
//

import Foundation

struct OfficialArtwork: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
