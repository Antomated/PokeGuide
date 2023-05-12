//
//  PokeGuideUITests.swift
//  PokeGuideUITests
//
//  Created by Beavean on 12.05.2023.
//

import XCTest

final class PokeGuideUITests: XCTestCase {
    private var app: XCUIApplication!

    // MARK: - Pokemons View

    private lazy var pokemonsCollectionView = app.collectionViews["pokemonsCollectionView"]
    private lazy var reloadButton = app.buttons["reloadButton"]
    private lazy var loader = app.activityIndicators["loader"]

    // MARK: - PokemonCell

    private lazy var cellImageView = app.images["cellImageView"]
    private lazy var cellNameLabel = app.staticTexts["cellNameLabel"]
    private lazy var cellAbilityLabel = app.staticTexts["cellAbilityLabel"]

    // MARK: - Details View

    private lazy var detailsImageView = app.images["detailsImageView"]
    private lazy var detailsNameLabel = app.staticTexts["detailsNameLabel"]
    private lazy var detailsNameImageViewContainer = app.otherElements["detailsNameImageViewContainer"]
    private lazy var detailsViewContainer = app.otherElements["detailsViewContainer"]
    private lazy var backButton = app.buttons["backButton"]

    // MARK: - Details Tab View

    private lazy var detailsTabTableView = app.tables["detailsTabTableView"]

    // MARK: - Details Cell

    private lazy var detailsCellLeadingLabel = app.staticTexts["detailsCellLeadingLabel"]
    private lazy var detailsCellTrailingLabel = app.staticTexts["detailsCellTrailingLabel"]

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testInitialInterfaceElements() {
        XCTAssertTrue(pokemonsCollectionView.exists)
        let result = XCTWaiter.wait(for: [expectation(description: #function)], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(cellNameLabel.exists)
            XCTAssertTrue(cellAbilityLabel.exists)
            XCTAssertTrue(cellImageView.exists)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testDetailedViewAndBackButton() {
        let result = XCTWaiter.wait(for: [expectation(description: #function)], timeout: 1)
        if result == XCTWaiter.Result.timedOut {
            let cell = pokemonsCollectionView.cells.element(boundBy: 1)
            cell.tap()
        } else {
            XCTFail("Delay interrupted")
        }
        XCTAssertTrue(detailsImageView.exists)
        XCTAssertTrue(detailsNameLabel.exists)
        XCTAssertTrue(detailsNameImageViewContainer.exists)
        XCTAssertTrue(detailsViewContainer.exists)
        XCTAssertTrue(detailsTabTableView.exists)
        XCTAssertTrue(detailsCellLeadingLabel.exists)
        XCTAssertTrue(detailsCellTrailingLabel.exists)
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        XCTAssertFalse(detailsImageView.exists)
        XCTAssertFalse(detailsNameLabel.exists)
        XCTAssertFalse(detailsNameImageViewContainer.exists)
        XCTAssertFalse(detailsViewContainer.exists)
        XCTAssertFalse(detailsTabTableView.exists)
        XCTAssertFalse(detailsCellLeadingLabel.exists)
        XCTAssertFalse(detailsCellTrailingLabel.exists)
        XCTAssertFalse(backButton.exists)
        XCTAssertTrue(pokemonsCollectionView.exists)
        XCTAssertTrue(cellNameLabel.exists)
        XCTAssertTrue(cellAbilityLabel.exists)
        XCTAssertTrue(cellImageView.exists)
    }
}
