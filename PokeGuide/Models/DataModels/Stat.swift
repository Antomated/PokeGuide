//
//  Stat.swift
//  PokeGuide
//
//  Created by Beavean on 09.05.2023.
//

import Foundation

struct Stat: Decodable {
    let baseStat: Int
    let stat: Species

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}
