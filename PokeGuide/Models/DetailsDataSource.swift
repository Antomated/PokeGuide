//
//  DetailsDataSource.swift
//  PokeGuide
//
//  Created by Beavean on 08.05.2023.
//

import Foundation

struct DetailsDataSource {
    let leadingText: String
    let trailingText: String

    init(leadingText: String, trailingText: String = "") {
        self.leadingText = leadingText
        self.trailingText = trailingText
    }
}
