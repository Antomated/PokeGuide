//
//  DetailsViewModel.swift
//  PokeGuide
//
//  Created by Beavean on 05.05.2023.
//

import Foundation
import RxSwift

final class DetailsViewModel {
    let pokemon: BehaviorSubject<DetailedPokemon>
    let tabStripViewModel: DetailsTabStripViewModel

    init(pokemon: DetailedPokemon) {
        self.pokemon = BehaviorSubject(value: pokemon)
        tabStripViewModel = DetailsTabStripViewModel(pokemonDetails: pokemon)
    }
}
