//
//  DetailsTabStripViewModel.swift
//  PokeGuide
//
//  Created by Beavean on 05.05.2023.
//

import Foundation
import RxCocoa

final class DetailsTabStripViewModel {
    let tabViewModels = BehaviorRelay<[DetailsTabViewModel]>(value: [])

    init(pokemonDetails: DetailedPokemon) {
        var detailsTabViewModels = [DetailsTabViewModel]()
        DetailsTab.allCases.forEach { tab in
            detailsTabViewModels.append(DetailsTabViewModel(pokemon: pokemonDetails, tab: tab))
            tabViewModels.accept(detailsTabViewModels)
        }
    }
}
