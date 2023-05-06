//
//  DetailsDataSource.swift
//  PokeGuide
//
//  Created by Beavean on 06.05.2023.
//

import Foundation

struct DetailsDataSource {
    let key: String
    let value: String

    init(key: String, value: String = "") {
        self.key = key
        self.value = value
    }
}
