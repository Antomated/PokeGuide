//
//  DetailedPokemon.swift
//  PokeGuide
//
//  Created by Beavean on 09.05.2023.
//

import Foundation

struct DetailedPokemon: Decodable {
    let abilities: [Ability]
    let moves: [Move]
    let name: String?
    let sprites: Sprites?
    let stats: [Stat]
    let types: [TypeElement]
}
