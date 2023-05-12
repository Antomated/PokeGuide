//
//  RealmManager.swift
//  PokeGuide
//
//  Created by Beavean on 08.05.2023.
//

import Foundation
import RealmSwift

protocol PokemonRealmManaging {
    func savePokemon(pokemon: PokemonObject)
    func getPokemon(name: String) -> PokemonObject?
    func getAllPokemons() -> [PokemonObject]
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

    func savePokemon(pokemon: PokemonObject) {
        guard realm.object(ofType: PokemonObject.self, forPrimaryKey: pokemon.name) == nil else { return }
        try? realm.write {
            realm.add(pokemon, update: .modified)
        }
    }

    func getPokemon(name: String) -> PokemonObject? {
        realm.object(ofType: PokemonObject.self, forPrimaryKey: name)
    }

    func getAllPokemons() -> [PokemonObject] {
        let pokemons = realm.objects(PokemonObject.self)
        return Array(pokemons)
    }
}
