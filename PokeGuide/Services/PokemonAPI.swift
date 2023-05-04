//
//  PokemonAPI.swift
//  PokeGuide
//
//  Created by Beavean on 26.04.2023.
//

import Foundation
import Moya

enum PokemonAPI {
    static let pokemonsListLimit = 20

    case getPokemonsList
    case loadNextPokemons(fromUrl: String)
    case getPokemon(fromUrl: String)
}

extension PokemonAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .getPokemonsList:
            return URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=\(Self.pokemonsListLimit)")!
        case let .getPokemon(urlString), let .loadNextPokemons(urlString):
            return URL(string: urlString)!
        }
    }

    var path: String {
        ""
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        .requestPlain
    }

    var headers: [String: String]? {
        nil
    }
}
