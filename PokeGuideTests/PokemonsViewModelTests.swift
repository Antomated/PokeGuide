//
//  PokemonsViewModelTests.swift
//  PokeGuideTests
//
//  Created by Beavean on 11.05.2023.
//

import XCTest
import RxSwift
@testable import PokeGuide

final class PokemonsViewModelTests: XCTestCase {
    private var sut: PokemonsViewModel!
    private var mockAPIManager: MockPokemonAPIManager!
    private var mockRealmManager: MockPokemonRealmManager!
    private let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        mockAPIManager = MockPokemonAPIManager()
        mockRealmManager = MockPokemonRealmManager()
        sut = PokemonsViewModel(pokemonAPIManager: mockAPIManager, realmManager: mockRealmManager)
    }

    override func tearDown() {
        sut = nil
        mockAPIManager = nil
        mockRealmManager = nil
        super.tearDown()
    }

    func testLoadInitialPokemonsSuccess() {
        let expectation = XCTestExpectation(description: #function)
        sut.detailedPokemons.subscribe(onNext: { pokemons in
            guard pokemons.isEmpty else {
                XCTFail("Error in \(#function)")
                return
            }
            expectation.fulfill()
        }).disposed(by: disposeBag)
        sut.loadInitialPokemons()
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadInitialPokemonsFailure() {
        mockAPIManager.shouldReturnError = true
        let expectation = XCTestExpectation(description: #function)
        sut.errorRelay.subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        sut.loadInitialPokemons()
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadMorePokemonsSuccess() {
        let expectation = XCTestExpectation(description: #function)
        sut.detailedPokemons.subscribe(onNext: { pokemons in
            guard pokemons.isEmpty else {
                XCTFail("Error in \(#function)")
                return
            }
            expectation.fulfill()
        }).disposed(by: disposeBag)
        sut.loadMorePokemons()
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadMorePokemonsFailure() {
        mockAPIManager.shouldReturnError = true
        sut.nextPageUrl = "test"
        let expectation = XCTestExpectation(description: #function)
        sut.errorRelay.subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        sut.loadMorePokemons()
        wait(for: [expectation], timeout: 1.0)
    }

    func testReloadSuccess() {
        let expectation = XCTestExpectation(description: #function)
        sut.detailedPokemons.subscribe(onNext: { pokemons in
            guard pokemons.isEmpty else {
                XCTFail("Error in \(#function)")
                return
            }
            expectation.fulfill()
        }).disposed(by: disposeBag)
        sut.reloadData()
        wait(for: [expectation], timeout: 1.0)
    }

    func testReloadFailure() {
        mockAPIManager.shouldReturnError = true
        let expectation = XCTestExpectation(description: #function)
        sut.errorRelay.subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        sut.reloadData()
        wait(for: [expectation], timeout: 1.0)
    }

    func testPokemonDetailsFetchSuccess() {
        let basicPokemon = BasicPokemon(name: "test", url: "test")
        let expectation = XCTestExpectation(description: #function)
        sut.detailedPokemons.subscribe(onNext: { pokemons in
            guard pokemons.isEmpty else {
                XCTFail("Error in \(#function)")
                return
            }
            expectation.fulfill()
        }).disposed(by: disposeBag)
        sut.fetchAndAppendDetailedPokemons(from: [basicPokemon])
        wait(for: [expectation], timeout: 1.0)
    }

    func testPokemonDetailsFetchFailure() {
        mockAPIManager.shouldReturnError = true
        let basicPokemon = BasicPokemon(name: "test", url: "test")
        let expectation = XCTestExpectation(description: #function)
        sut.errorRelay.subscribe(onNext: { _ in
            expectation.fulfill()
        }).disposed(by: disposeBag)
        sut.fetchAndAppendDetailedPokemons(from: [basicPokemon])
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadCachedPokemons() {
        let testPokemons = [PokemonObject(), PokemonObject()]
        let expectation = XCTestExpectation(description: #function)
        mockRealmManager.mockPokemons = testPokemons
        sut.loadCachedPokemons()
        sut.detailedPokemons.subscribe(onNext: { pokemons in
            guard !pokemons.isEmpty else {
                XCTFail("Error in \(#function)")
                return
            }
            XCTAssertEqual(pokemons.count, testPokemons.count, "The loaded pokemons don't match the expected values.")
            expectation.fulfill()
        }).disposed(by: disposeBag)
        wait(for: [expectation], timeout: 3.0)
    }
}
