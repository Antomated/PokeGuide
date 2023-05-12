//
//  PokemonRealmManagerTests.swift
//  PokeGuideTests
//
//  Created by Beavean on 11.05.2023.
//

@testable import PokeGuide
import RealmSwift
import XCTest

final class PokemonRealmManagerTests: XCTestCase {
    private var pokemonRealmManager: PokemonRealmManager!

    override func setUp() {
        super.setUp()
        let config = Realm.Configuration(inMemoryIdentifier: "testRealm")
        pokemonRealmManager = PokemonRealmManager(realmConfiguration: config)
    }

    override func tearDown() {
        super.tearDown()
        pokemonRealmManager = nil
    }

    func testSaveAndGetPokemon() {
        guard let pokemon = PokemonObject(pokemon: DetailedPokemon(abilities: [],
                                                                   moves: [],
                                                                   name: "Pikachu",
                                                                   sprites: Sprites(frontDefault: "", other: nil),
                                                                   stats: [],
                                                                   types: []))
        else {
            XCTFail("Error creating Pokemon Object")
            return
        }
        pokemonRealmManager.savePokemon(pokemon: pokemon)
        let retrievedPokemon = pokemonRealmManager.getPokemon(name: "Pikachu")
        XCTAssertNotNil(retrievedPokemon)
        XCTAssertEqual(retrievedPokemon?.name, "Pikachu")
    }

    func testGetAllPokemons() {
        guard let firstPokemon = PokemonObject(pokemon: DetailedPokemon(abilities: [],
                                                                        moves: [],
                                                                        name: "Charmander",
                                                                        sprites: Sprites(frontDefault: "", other: nil),
                                                                        stats: [],
                                                                        types: [])),
            let secondPokemon = PokemonObject(pokemon: DetailedPokemon(abilities: [],
                                                                       moves: [],
                                                                       name: "Bulbasaur",
                                                                       sprites: Sprites(frontDefault: "", other: nil),
                                                                       stats: [],
                                                                       types: []))
        else {
            XCTFail("Error creating Pokemon Objects")
            return
        }
        pokemonRealmManager.savePokemon(pokemon: firstPokemon)
        pokemonRealmManager.savePokemon(pokemon: secondPokemon)
        let allPokemons = pokemonRealmManager.getAllPokemons()
        XCTAssertEqual(allPokemons.count, 2)
        XCTAssertEqual(allPokemons[0].name, "Charmander")
        XCTAssertEqual(allPokemons[1].name, "Bulbasaur")
    }
}
