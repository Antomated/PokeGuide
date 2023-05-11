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
        let errorMessage: String
        switch self {
        case .unknownError:
            errorMessage = "Unknown error."
        case .serverError:
            errorMessage = "Server error."
        case let .customError(message):
            if let range = message.range(of: ":") {
                let messageStartIndex = message.index(after: range.lowerBound)
                errorMessage = message[messageStartIndex...].trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                errorMessage = message
            }
        }
        return errorMessage
    }
}
