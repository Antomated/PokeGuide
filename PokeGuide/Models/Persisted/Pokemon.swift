//
//  Pokemon.swift
//  PokeGuide
//
//  Created by Beavean on 08.05.2023.
//

import Realm
import RealmSwift

final class Pokemon: Object {
    @Persisted var name: String = ""
    @Persisted var smallImageUrl: String?
    @Persisted var officialArtworkImageUrl: String?
    @Persisted var stats: List<PokemonDetails>
    @Persisted var abilities: List<PokemonDetails>
    @Persisted var types: List<PokemonDetails>
    @Persisted var moves: List<PokemonDetails>

    override static func primaryKey() -> String? {
        "name"
    }

    convenience init?(pokemon: DetailedPokemon) {
        guard let name = pokemon.name,
              let smallImageUrl = pokemon.sprites?.frontDefault else {
            return nil
        }
        self.init()
        self.name = name
        self.smallImageUrl = smallImageUrl
        officialArtworkImageUrl = pokemon.sprites?.other?.officialArtwork.frontDefault
        pokemon.stats.forEach { stat in
            self.stats.append(PokemonDetails(name: stat.stat.name, parameter: stat.baseStat))
        }
        pokemon.abilities.forEach { ability in
            self.abilities.append(PokemonDetails(name: ability.ability.name, slot: ability.slot))
        }
        pokemon.types.forEach { type in
            self.types.append(PokemonDetails(name: type.type.name, slot: type.slot))
        }
        pokemon.moves.forEach { move in
            self.moves.append(PokemonDetails(name: move.move.name))
        }
    }
}
