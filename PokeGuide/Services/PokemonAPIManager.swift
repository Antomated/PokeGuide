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
    private let concurrentRequestsQueue = DispatchQueue(label: "com.pokeguide.apiManager", qos: .userInitiated)
    private let disposeBag = DisposeBag()

    func fetchData<T: Decodable>(from request: PokemonAPI, ofType type: T.Type) -> Observable<T> {
        let decoder = JSONDecoder()

        return Observable.create { observer in
            self.concurrentRequestsQueue.async {
                self.provider.rx.request(request)
                    .filterSuccessfulStatusCodes()
                    .map(T.self, using: decoder)
                    .subscribe(onSuccess: { result in
                        observer.onNext(result)
                        observer.onCompleted()
                    }, onFailure: { error in
                        observer.onError(self.handleError(error))
                    }).disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }

    private func handleError(_ error: Error) -> APIError {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response):
                if (500...599).contains(response.statusCode) {
                    return .serverError
                } else {
                    return .customError(moyaError.localizedDescription)
                }
            default:
                return .customError(moyaError.localizedDescription)
            }
        } else {
            return .unknownError
        }
    }
}
