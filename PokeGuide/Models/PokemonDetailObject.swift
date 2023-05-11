//
//  PokemonDetailObject.swift
//  PokeGuide
//
//  Created by Beavean on 06.05.2023.
//

import Foundation
import RealmSwift

final class PokemonDetailObject: Object {
    @Persisted var name: String = ""
    @Persisted var slot: Int?
    @Persisted var parameter: Int?

    convenience init(name: String, slot: Int? = nil, parameter: Int? = nil) {
        self.init()
        self.name = name
        self.slot = slot
        self.parameter = parameter
    }
}
