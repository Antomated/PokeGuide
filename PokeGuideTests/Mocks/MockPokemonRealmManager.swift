//
//  MockPokemonRealmManager.swift
//  PokeGuideTests
//
//  Created by Beavean on 11.05.2023.
//

@testable import PokeGuide
import XCTest

final class MockPokemonRealmManager: PokemonRealmManaging {
    var mockPokemons = [PokemonObject]()

    func savePokemon(pokemon: PokemonObject) {}

    func getPokemon(name: String) -> PokemonObject? {
        nil
    }

    func getAllPokemons() -> [PokemonObject] {
        mockPokemons
    }
}
