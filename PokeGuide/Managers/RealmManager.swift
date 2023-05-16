//
//  RealmManager.swift
//  PokeGuide
//
//  Created by Beavean on 08.05.2023.
//

import Foundation
import RealmSwift

protocol PokemonRealmManaging {
    func savePokemon(pokemon: Pokemon)
    func getPokemon(name: String) -> Pokemon?
    func getAllPokemons() -> [Pokemon]
}

final class PokemonRealmManager: PokemonRealmManaging {
    private(set) var realm: Realm

    init(realmConfiguration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            self.realm = realm
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    func savePokemon(pokemon: Pokemon) {
        guard realm.object(ofType: Pokemon.self, forPrimaryKey: pokemon.name) == nil else { return }
        try? realm.write {
            realm.add(pokemon, update: .modified)
        }
    }

    func getPokemon(name: String) -> Pokemon? {
        realm.object(ofType: Pokemon.self, forPrimaryKey: name)
    }

    func getAllPokemons() -> [Pokemon] {
        let pokemons = realm.objects(Pokemon.self)
        return Array(pokemons)
    }
}
