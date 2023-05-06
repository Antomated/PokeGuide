//
//  DetailsTabViewModel.swift
//  PokeGuide
//
//  Created by Beavean on 06.05.2023.
//

import Foundation

final class DetailsTabViewModel {
    private(set) var title: String
    private(set) var keyValueDataSource = [DetailsDataSource]()

    init(pokemon: DetailedPokemon, tab: DetailsTab) {
        title = tab.rawValue.capitalized
        var numeration = 0
        switch tab {
        case .stats:
            let sortedStats = pokemon.stats.sorted(by: { $0.stat.name < $1.stat.name })
            keyValueDataSource = sortedStats.map { stat in
                numeration += 1
                return DetailsDataSource(key: "\(numeration). \(stat.stat.name.capitalized):",
                                         value: "\(stat.baseStat)")
            }
        case .abilities:
            let sortedAbilities = pokemon.abilities.sorted(by: { $0.slot < $1.slot })
            keyValueDataSource = sortedAbilities.map {
                DetailsDataSource(key: "\($0.slot). \($0.ability.name.capitalized)")
            }
        case .types:
            let sortedTypes = pokemon.types.sorted(by: { $0.slot < $1.slot })
            keyValueDataSource = sortedTypes.map {
                DetailsDataSource(key: "\($0.slot). \($0.type.name.capitalized)")
            }
        case .moves:
            keyValueDataSource = pokemon.moves.map { move in
                numeration += 1
                return DetailsDataSource(key: "\(numeration). \(move.move.name.capitalized)")
            }
        }
    }
}
