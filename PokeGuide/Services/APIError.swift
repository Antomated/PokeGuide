//
//  APIError.swift
//  PokeGuide
//
//  Created by Beavean on 02.05.2023.
//

import Foundation

enum APIError: Error {
    case unknownError
    case serverError
    case customError(String)

    var errorMessage: String {
        switch self {
        case .unknownError:
             return "Unknown error."
        case .serverError:
            return "Server error."
        case .customError(let message):
            return message
        }
    }
}
