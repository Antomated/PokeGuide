//
//  Other.swift
//  PokeGuide
//
//  Created by Beavean on 09.05.2023.
//

import Foundation

struct Other: Decodable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}
