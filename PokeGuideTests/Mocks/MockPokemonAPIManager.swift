//
//  MockPokemonAPIManager.swift
//  PokeGuideTests
//
//  Created by Beavean on 11.05.2023.
//

@testable import PokeGuide
import RxSwift
import XCTest

final class MockPokemonAPIManager: PokemonAPIManaging {
    var shouldReturnError = false

    func fetchData<T>(from endpoint: PokemonAPI, ofType type: T.Type) -> Observable<T> where T: Decodable {
        if shouldReturnError {
            return Observable.error(NSError(domain: "", code: -1, userInfo: nil))
        }
        guard type == PokemonList.self else { return Observable.empty() }
        let pokemonList = PokemonList(next: nil, results: [BasicPokemon(name: "test", url: "test")])
        guard let castedPokemonList = pokemonList as? T else {
            return Observable.empty()
        }
        return Observable.just(castedPokemonList)
    }
}
