//
//  CheapestPathUITests.swift
//  CheapestPathUITests
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import XCTest

class CheapestPathUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func testTripFromLondonToSydney() {
        
        let fromTextField = XCUIApplication().textFields["fromField"]
        fromTextField.tap()
        fromTextField.typeText("London")

        let toTextField = XCUIApplication().textFields["toField"]
        toTextField.tap()
        toTextField.typeText("Sydney")
        
        fromTextField.tap()
        
        let cheapestPriceLabel = XCUIApplication().staticTexts["cheapestPrice"]
        cheapestPriceLabel.waitUntilExists()
        
        XCTAssertEqual(cheapestPriceLabel.label, "Cheapest trip: 850")
    }
}

public extension XCUIElement {
    @discardableResult
    func waitUntilExists(_ timeout: TimeInterval = 10) -> XCUIElement {
        if self.exists == true {
            return self
        }
        
        let test = XCTestCase()
        test.continueAfterFailure = true
        let predicate = NSPredicate(format: "exists == true")
        let expectation = test.expectation(for: predicate, evaluatedWith: self, handler: nil)
        XCTWaiter().wait(for: [expectation], timeout: timeout)
        return self
    }
}
