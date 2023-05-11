//
//  DetailsTabViewModel.swift
//  PokeGuide
//
//  Created by Beavean on 06.05.2023.
//

import Foundation

final class DetailsTabViewModel {
    private(set) var title: String
    private(set) var tableViewDataSource = [DetailsDataSource]()

    init(pokemon: PokemonObject, tab: DetailsTab) {
        title = tab.rawValue.capitalized
        var numeration = 0
        switch tab {
        case .stats:
            let sortedStats = pokemon.stats.sorted(by: { $0.name < $1.name })
            tableViewDataSource = sortedStats.map { stat in
                numeration += 1
                return DetailsDataSource(leadingText: "\(numeration). \(stat.name.capitalized):",
                                         trailingText: "\(stat.parameter ?? 0)")
            }
        case .abilities:
            let sortedAbilities = pokemon.abilities.sorted(by: { $0.slot ?? 0 < $1.slot ?? 0 })
            tableViewDataSource = sortedAbilities.map {
                numeration += 1
                return DetailsDataSource(leadingText: "\($0.slot ?? numeration). \($0.name.capitalized)")
            }
        case .types:
            let sortedTypes = pokemon.types.sorted(by: { $0.slot ?? 0 < $1.slot ?? 0 })
            tableViewDataSource = sortedTypes.map {
                numeration += 1
                return DetailsDataSource(leadingText: "\($0.slot ?? numeration). \($0.name.capitalized)")
            }
        case .moves:
            tableViewDataSource = pokemon.moves.map { move in
                numeration += 1
                return DetailsDataSource(leadingText: "\(numeration). \(move.name.capitalized)")
            }
        }
    }
}
