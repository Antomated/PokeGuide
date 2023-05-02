//
//  PokemonAPIManager.swift
//  PokeGuide
//
//  Created by Beavean on 26.04.2023.
//

import Moya
import RxSwift
import RxCocoa
import Foundation

final class PokemonAPIManager {
    private let provider = MoyaProvider<PokemonAPI>()

    func fetchData<T: Decodable>(from request: PokemonAPI, ofType type: T.Type) -> Observable<T> {
        let decoder = JSONDecoder()
        return provider.rx.request(request)
            .filterSuccessfulStatusCodes()
            .map(T.self, using: decoder)
            .asObservable()
    }
}
