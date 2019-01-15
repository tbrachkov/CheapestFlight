//
//  TripSelectorViewController.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import UIKit

class TripSelectorViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var fromCityLabel: UILabel!
    @IBOutlet weak var toCityLabel: UILabel!
    @IBOutlet weak var fromCityTextField: UITextField!
    @IBOutlet weak var toCityTextField: UITextField!
    @IBOutlet weak var cheapestResultLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: TripSelectorViewModel!
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TripSelectorViewModel()
        
    }
}
