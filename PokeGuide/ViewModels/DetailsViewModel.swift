//
//  DetailsViewModel.swift
//  PokeGuide
//
//  Created by Beavean on 05.05.2023.
//

import Foundation
import RxSwift

final class DetailsViewModel {
    private let pokemonRealmManager: PokemonRealmManaging
    let pokemon: BehaviorSubject<PokemonObject>
    let tabStripViewModel: DetailsTabStripViewModel

    init(pokemon: PokemonObject, realmManager: PokemonRealmManaging) {
        self.pokemon = BehaviorSubject(value: pokemon)
        self.pokemonRealmManager = realmManager
        tabStripViewModel = DetailsTabStripViewModel(pokemonDetails: pokemon)
        pokemonRealmManager.savePokemon(pokemon: pokemon)
    }
}
