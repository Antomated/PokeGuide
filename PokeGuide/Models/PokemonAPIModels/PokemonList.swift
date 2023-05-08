//
//  PokemonList.swift
//  PokeGuide
//
//  Created by Beavean on 09.05.2023.
//

import Foundation

struct PokemonList: Decodable {
    let next: String?
    let results: [BasicPokemon]
}
