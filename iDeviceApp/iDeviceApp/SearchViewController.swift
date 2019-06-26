//
//  ViewController.swift
//  iDeviceApp
//
//  Created by Oliver Paray on 6/24/19.
//  Copyright © 2019 Oliver Paray. All rights reserved.
//

import Library
import UIKit

class SearchViewController: UIViewController,UITextFieldDelegate {

    // MARK: Properties

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchActivity: UIActivityIndicatorView!

    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Delegates

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
    }

    // MARK: Actions

    @IBAction func buttonPressed(sender: Any){

    }

    @IBAction func retunToSearch(_ unwindSegue:UIStoryboardSegue){

    }
}

