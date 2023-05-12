//
//  PokemonAPIManagerTests.swift
//  PokeGuideTests
//
//  Created by Beavean on 12.05.2023.
//

import Moya
@testable import PokeGuide
import RxSwift
import XCTest

final class PokemonAPIManagerTests: XCTestCase {
    private var sut: PokemonAPIManager!
    private var mockProvider: MoyaProvider<PokemonAPI>!

    override func setUp() {
        super.setUp()
        let sampleJSON = """
        {
        "count": 1,
        "next": "http://example.com/api/v2/pokemon?offset=1&limit=1",
        "previous": null,
        "results": [
        {
        "name": "bulbasaur",
        "url": "http://example.com/api/v2/pokemon/1/"
        }
        ]
        }
        """
        let sampleData = sampleJSON.data(using: .utf8)!
        let endpointClosure = { (target: PokemonAPI) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString,
                     sampleResponseClosure: { .networkResponse(200, sampleData) },
                     method: target.method,
                     task: target.task,
                     httpHeaderFields: target.headers)
        }
        mockProvider = MoyaProvider<PokemonAPI>(endpointClosure: endpointClosure,
                                                stubClosure: MoyaProvider.immediatelyStub)
        sut = PokemonAPIManager(provider: mockProvider)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        mockProvider = nil
    }

    func testFetchDataSuccess() {
        let expectation = XCTestExpectation(description: "Fetch data success")
        _ = sut.fetchData(from: .getPokemonsList, ofType: PokemonList.self)
            .subscribe(onNext: { result in
                guard !result.results.isEmpty else {
                    XCTFail("Fetch data returned empty result")
                    return
                }
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Fetch data should succeed, but it failed with error: \(error)")
            })
        wait(for: [expectation], timeout: 3.0)
    }

    func testHandleServerError() {
        let serverError = MoyaError.statusCode(Response(statusCode: 500, data: Data()))
        let error = sut.handleError(serverError)
        XCTAssertEqual(error.localizedDescription, APIError.serverError.localizedDescription)
    }

    func testHandleCustomError() {
        let customError = MoyaError.requestMapping("Bad Request")
        let customErrorText = APIError.customError(customError.localizedDescription).localizedDescription
        let error = sut.handleError(customError)
        XCTAssertEqual(error.localizedDescription, customErrorText)
    }

    func testHandleUnknownError() {
        let unknownError = NSError(domain: "Unknown", code: 0, userInfo: nil)
        let error = sut.handleError(unknownError)
        XCTAssertEqual(error.localizedDescription, APIError.unknownError.localizedDescription)
    }
}
