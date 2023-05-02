//
//  PokemonsViewModel.swift
//  PokeGuide
//
//  Created by Beavean on 26.04.2023.
//

import RxSwift
import RxCocoa
import Foundation

final class PokemonsViewModel {
    // MARK: - Properties

    private(set) var isFetchingMoreData = false
    private(set) var nextPageUrl: String?
    private(set) var basicPokemons = [BasicPokemon]()
    private(set) var cellViewModels = [PokemonCellViewModel]()
    private let pokemonAPIManager: PokemonAPIManager
    private let disposeBag = DisposeBag()
    private var pokemonsRelay = BehaviorRelay<PokemonList?>(value: nil)
    var errorRelay = PublishRelay<Error>()
    var pokemons: Observable<PokemonList?> {
        return pokemonsRelay.asObservable()
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
                self.basicPokemons = pokemonsList.results
                self.cellViewModels = pokemonsList.results.map {
                    PokemonCellViewModel(basicPokemon: $0, apiManager: self.pokemonAPIManager)
                }
                self.pokemonsRelay.accept(pokemonsList)
            }, onError: { [weak self] error in
                guard let self else { return }
                print("DEBUG! error fetching initial pokemons \n\(error)")
                self.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func loadMorePokemons() {
        guard !isFetchingMoreData, let nextPageUrl else { return }
        isFetchingMoreData = true
        pokemonAPIManager
            .fetchData(from: .loadNextPokemons(fromUrl: nextPageUrl), ofType: PokemonList.self)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pokemonsList in
                guard let self, let nextPageUrl = self.nextPageUrl else { return }
                self.isFetchingMoreData = false
                self.nextPageUrl = pokemonsList.next
                self.basicPokemons += pokemonsList.results
                let newCellViewModels = pokemonsList.results.map {
                    PokemonCellViewModel(basicPokemon: $0, apiManager: self.pokemonAPIManager)
                }
                self.cellViewModels += newCellViewModels
                self.pokemonsRelay.accept(PokemonList(count: self.basicPokemons.count,
                                                      next: nextPageUrl,
                                                      previous: pokemonsList.previous,
                                                      results: self.basicPokemons))
            }, onError: { [weak self] error in
                guard let self else { return }
                self.isFetchingMoreData = false
                print("DEBUG! error fetching using this url:\(String(describing: self.nextPageUrl)) \n\(error)")
                self.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }
}
