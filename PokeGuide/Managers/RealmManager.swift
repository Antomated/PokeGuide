//
//  RealmManager.swift
//  PokeGuide
//
//  Created by Beavean on 08.05.2023.
//

import Foundation
import RealmSwift

final class PokemonRealmManager {
    static let shared = PokemonRealmManager()
    private let realm: Realm

    private init() {
        do {
            realm = try Realm()
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
