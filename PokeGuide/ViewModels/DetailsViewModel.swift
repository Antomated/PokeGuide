//
//  DetailsViewModel.swift
//  PokeGuide
//
//  Created by Beavean on 05.05.2023.
//

import Foundation
import RxSwift

final class DetailsViewModel {
    let pokemon: BehaviorSubject<PokemonObject>
    let tabStripViewModel: DetailsTabStripViewModel

    init(pokemon: PokemonObject) {
        self.pokemon = BehaviorSubject(value: pokemon)
        tabStripViewModel = DetailsTabStripViewModel(pokemonDetails: pokemon)
        PokemonRealmManager.shared.savePokemon(pokemon: pokemon)
    }
}
