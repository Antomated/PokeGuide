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
    private(set) var reloadButtonIsVisible = BehaviorRelay<Bool>(value: false)
    var nextPageUrl: String?
    private let pokemonAPIManager: PokemonAPIManager
    private(set) var pokemonRealmManager: PokemonRealmManaging
    private let disposeBag = DisposeBag()
    private var detailedPokemonsRelay = BehaviorRelay<[PokemonObject]>(value: [])
    var errorRelay = PublishRelay<Error>()
    var detailedPokemons: Observable<[PokemonObject]> {
        detailedPokemonsRelay.asObservable()
    }

    // MARK: - Initialization

    init(pokemonAPIManager: PokemonAPIManager = PokemonAPIManager(),
         realmManager: PokemonRealmManaging = PokemonRealmManager()) {
        self.pokemonAPIManager = pokemonAPIManager
        pokemonRealmManager = realmManager
        loadInitialPokemons()
    }

    // MARK: - Internal methods

    func loadInitialPokemons() {
        pokemonAPIManager
            .fetchData(from: .getPokemonsList, ofType: PokemonList.self)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .subscribe(onNext: { [weak self] pokemonsList in
                guard let self else { return }
                self.nextPageUrl = pokemonsList.next
                self.fetchAndAppendDetailedPokemons(from: pokemonsList.results)
                self.reloadButtonIsVisible.accept(false)
            }, onError: { [weak self] error in
                guard let self else { return }
                self.loadCachedPokemons()
                self.errorRelay.accept(error)
                self.reloadButtonIsVisible.accept(true)
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
                self.reloadButtonIsVisible.accept(true)
                self.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func reloadData() {
        detailedPokemonsRelay.accept([])
        loadInitialPokemons()
    }

    func fetchAndAppendDetailedPokemons(from basicPokemons: [BasicPokemon]) {
        isFetchingDetailedPokemons.accept(true)
        let observables = basicPokemons.compactMap { basicPokemon -> Observable<PokemonObject> in
            if let savedPokemon = pokemonRealmManager.getPokemon(name: basicPokemon.name) {
                return Observable.just(savedPokemon)
            } else {
                return self.pokemonAPIManager.fetchData(from: .getPokemon(fromUrl: basicPokemon.url),
                                                        ofType: DetailedPokemon.self)
                    .flatMap { detailedPokemon -> Observable<PokemonObject> in
                        if let pokemonObject = PokemonObject(pokemon: detailedPokemon) {
                            return Observable.just(pokemonObject)
                        } else {
                            return Observable.empty()
                        }
                    }
            }
        }
        Observable.concat(observables)
            .do(afterCompleted: { [weak self] in
                self?.isFetchingDetailedPokemons.accept(false)
            })
            .subscribe(onNext: { [weak self] pokemonObject in
                var updatedDetailedPokemons = self?.detailedPokemonsRelay.value ?? []
                updatedDetailedPokemons.append(pokemonObject)
                self?.detailedPokemonsRelay.accept(updatedDetailedPokemons)
            }, onError: { [weak self] error in
                guard let self else { return }
                self.isFetchingDetailedPokemons.accept(false)
                self.reloadButtonIsVisible.accept(true)
                self.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func loadCachedPokemons() {
        let cachedPokemons = pokemonRealmManager.getAllPokemons()
        detailedPokemonsRelay.accept(cachedPokemons)
    }
}
