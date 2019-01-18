//
//  MockAutocompleteTextField.swift
//  CheapestPathTests
//
//  Created by Todor Brachkov on 17/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import XCTest
@testable import CheapestPath

extension NSRange {
    func toTextRange(textInput: UITextInput) -> UITextRange? {
        if let rangeStart = textInput.position(from: textInput.beginningOfDocument, offset: location),
            let rangeEnd = textInput.position(from: rangeStart, offset: length) {
            return textInput.textRange(from: rangeStart, to: rangeEnd)
        }
        return nil
    }
}

class MockAutocompleteTextField: UITextFieldAutoCompletable {
    
    var textInRange: String
    
    init(text: String, textInRange: String) {
        self.text = text
        self.textInRange = textInRange
        let endTextPosition = UITextPosition()
        self.beginningOfDocument = UITextPosition()
        self.endOfDocument = endTextPosition
        let selectedRange = MockedTextRange(start: self.beginningOfDocument, end: endTextPosition)
        self.selectedTextRange = selectedRange
    }
    
    var text: String?
    var beginningOfDocument: UITextPosition
    var endOfDocument: UITextPosition
    var selectedTextRange: UITextRange?
    
    var didCallTextRangeFrom: Bool = false
    var didCallTextInRange: Bool = false
    var didCallPositionFrom: Bool = false

    func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
        didCallTextRangeFrom = true
        return MockedTextRange(start: self.beginningOfDocument, end: self.endOfDocument)
    }

    func text(in range: UITextRange) -> String? {
        didCallTextInRange = true
        return textInRange
    }
    
    func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        didCallPositionFrom = true
        return nil
    }
}


class MockedTextRange: UITextRange {
    var mockedStart: UITextPosition
    var mockedEnd: UITextPosition
    
    init(start: UITextPosition, end: UITextPosition) {
        self.mockedEnd = end
        self.mockedStart = start
        super.init()
    }
    
    override var start: UITextPosition {
        return mockedStart
    }
    
    override var end: UITextPosition {
        return mockedEnd
    }
}
