//
//  PokemonAPI.swift
//  PokeGuide
//
//  Created by Beavean on 26.04.2023.
//

import Foundation
import Moya

enum PokemonAPI {
    static private let pokemonsListLimit = 40

    case getPokemonsList
    case loadNextPokemons(fromUrl: String)
    case getPokemon(fromUrl: String)
}

extension PokemonAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .getPokemonsList:
            return URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=\(Self.pokemonsListLimit)")!
        case .getPokemon(let urlString), .loadNextPokemons(let urlString):
            return URL(string: urlString)!
        }
    }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return nil
    }
}
