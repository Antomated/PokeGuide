//
//  MockPokemonRealmManager.swift
//  PokeGuideTests
//
//  Created by Beavean on 11.05.2023.
//

import XCTest
@testable import PokeGuide

final class MockPokemonRealmManager: PokemonRealmManaging {
    var mockPokemons = [PokemonObject]()

    func savePokemon(pokemon: PokemonObject) {
    }

    func getPokemon(name: String) -> PokemonObject? {
        return nil
    }

    func getAllPokemons() -> [PokemonObject] {
        return mockPokemons
    }
}
