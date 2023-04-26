//
//  ApplyableProtocol.swift
//  PokeGuide
//
//  Created by Beavean on 25.04.2023.
//

import UIKit

protocol ApplyableProtocol {}

extension ApplyableProtocol where Self: AnyObject {
    @discardableResult
    func apply(_ item: (Self) throws -> Void) rethrows -> Self {
        try item(self)
        return self
    }
}

extension NSObject: ApplyableProtocol {}
