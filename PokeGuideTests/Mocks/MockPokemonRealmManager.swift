//
//  MockPokemonRealmManager.swift
//  PokeGuideTests
//
//  Created by Beavean on 11.05.2023.
//

@testable import PokeGuide
import XCTest

final class MockPokemonRealmManager: PokemonRealmManaging {
    var mockPokemons = [Pokemon]()

    func savePokemon(pokemon: Pokemon) {}

    func getPokemon(name: String) -> Pokemon? {
        nil
    }

    func getAllPokemons() -> [Pokemon] {
        mockPokemons
    }
}
