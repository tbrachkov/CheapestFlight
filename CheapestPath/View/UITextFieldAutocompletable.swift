//
//  UITextFieldAutocompletable.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 17/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import UIKit

protocol UITextFieldAutoCompletable: class {
    var beginningOfDocument: UITextPosition { get }
    var selectedTextRange: UITextRange? { get set }
    var endOfDocument: UITextPosition { get }
    func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange?
    func text(in range: UITextRange) -> String?
    func position(from position: UITextPosition, offset: Int) -> UITextPosition?
    var text: String? { get set }
}

extension UITextField: UITextFieldAutoCompletable {}
