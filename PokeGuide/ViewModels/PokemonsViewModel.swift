//
//  PokemonsViewModel.swift
//  PokeGuide
//
//  Created by Beavean on 04.05.2023.
//

import Foundation
import RxCocoa
import RxSwift

final class PokemonsViewModel {
    // MARK: - Properties

    private(set) var isFetchingMoreData = false
    private(set) var isFetchingDetailedPokemons = BehaviorRelay<Bool>(value: false)
    private(set) var nextPageUrl: String?
    private let pokemonAPIManager: PokemonAPIManager
    private let disposeBag = DisposeBag()
    private var _detailedPokemons = BehaviorRelay<[DetailedPokemon]>(value: [])
    var errorRelay = PublishRelay<Error>()
    var detailedPokemons: Observable<[DetailedPokemon]> {
        _detailedPokemons.asObservable()
    }

    // MARK: - Initialization

    init(pokemonAPIManager: PokemonAPIManager = PokemonAPIManager()) {
        self.pokemonAPIManager = pokemonAPIManager
        pokemonAPIManager
            .fetchData(from: .getPokemonsList, ofType: PokemonList.self)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .subscribe(onNext: { [weak self] pokemonsList in
                guard let self else { return }
                self.nextPageUrl = pokemonsList.next
                self.fetchAndAppendDetailedPokemons(from: pokemonsList.results)
            }, onError: { [weak self] error in
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func loadMorePokemons() {
        guard !isFetchingMoreData, let nextPageUrl = nextPageUrl else { return }
        isFetchingMoreData = true
        pokemonAPIManager
            .fetchData(from: .loadNextPokemons(fromUrl: nextPageUrl), ofType: PokemonList.self)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemonsList in
                guard let self else { return }
                self.isFetchingMoreData = false
                self.nextPageUrl = pokemonsList.next
                self.fetchAndAppendDetailedPokemons(from: pokemonsList.results)
            }, onError: { [weak self] error in
                guard let self else { return }
                self.isFetchingMoreData = false
                self.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func fetchAndAppendDetailedPokemons(from basicPokemons: [BasicPokemon]) {
        isFetchingDetailedPokemons.accept(true)
        let observables = basicPokemons.map { basicPokemon -> Observable<DetailedPokemon> in
            self.pokemonAPIManager.fetchData(from: .getPokemon(fromUrl: basicPokemon.url),
                                             ofType: DetailedPokemon.self)
        }
        Observable.concat(observables)
            .do(afterCompleted: { [weak self] in
                self?.isFetchingDetailedPokemons.accept(false)
            })
            .subscribe(onNext: { [weak self] detailedPokemon in
                guard let self else { return }
                var updatedDetailedPokemons = self._detailedPokemons.value
                updatedDetailedPokemons.append(detailedPokemon)
                self._detailedPokemons.accept(updatedDetailedPokemons)
            }, onError: { [weak self] error in
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }
}
