//
//  PokemonCellViewModel.swift
//  PokeGuide
//
//  Created by Beavean on 27.04.2023.
//

import RxCocoa
import RxSwift
import Foundation

final class PokemonCellViewModel {
    private let pokemonBasic: BasicPokemon
    private let apiManager: PokemonAPIManager
    private let disposeBag = DisposeBag()
    private(set) var name: String
    private(set) var ability = BehaviorRelay<String?>(value: nil)
    private(set) var imageUrl = BehaviorRelay<String?>(value: nil)
    var errorRelay = PublishRelay<Error>()

    init(basicPokemon: BasicPokemon, apiManager: PokemonAPIManager) {
        self.pokemonBasic = basicPokemon
        self.apiManager = apiManager
        name = basicPokemon.name.capitalized
        fetchPokemonDetails()
    }

    func fetchPokemonDetails() {
        apiManager.fetchData(from: .getPokemon(fromUrl: pokemonBasic.url), ofType: DetailedPokemon.self)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] details in
                guard let self else { return }
                self.imageUrl.accept(details.sprites?.frontDefault)
                self.ability.accept(details.abilities.first?.ability.name.capitalized)
            }, onError: { [weak self] error in
                guard let self else { return }
                print("DEBUG! error fetching more details for \(self.pokemonBasic.url) \n\(error)")
                self.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }
}
