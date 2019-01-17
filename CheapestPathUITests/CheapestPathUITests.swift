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

    func testExample() {
        let fromTextField = XCUIApplication().textFields["fromField"]
        fromTextField.tap()
        fromTextField.typeText("Lo")
        
        let toTextField = XCUIApplication().textFields["toField"]
        toTextField.tap()
        toTextField.typeText("Sy")
    }

}
