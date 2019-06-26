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
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchActivity: UIActivityIndicatorView!

    private var alert : UIAlertController = UIAlertController(title: "Alert", message: String.empty, preferredStyle: .alert)
    private var results : JSON?

    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchAnimation(false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.toResults.rawValue:
            guard let toDisplay = results, let destination = segue.destination as? ResultsViewController else {
                self.displayError()
                return
            }
            destination.ResultsToDisplay = toDisplay
        default:
            break
        }
    }

    private func searchAnimation(_ start: Bool=true){
        DispatchQueue.main.async {
            self.searchActivity.isHidden = !start
            if start {
                self.searchActivity.startAnimating()
            } else {
                self.searchActivity.stopAnimating()
            }
        }
    }

    private func processResult(_ data:Data){
        guard let jsonData = Parser.jsonFrom(data: data) else {
            self.displayError()
            return
        }
        self.results = jsonData
        DispatchQueue.main.async {
            print(jsonData)
            self.searchAnimation(false)
        }
    }

    private func displayError(withTitle: String = "Ooops...",
                              andMessage:String = "Something weird has happened.\nPlease try again."){
        DispatchQueue.main.async {
            self.alert = UIAlertController(title: withTitle, message: andMessage, preferredStyle: .alert)
            self.alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.alert.dismiss(animated: true, completion: nil)
            }))
            self.searchAnimation(false)
            self.present(self.alert, animated: true, completion: nil)
        }
    }

    // MARK: Delegates

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        self.searchAnimation()
        iTunesSearch.performSearch(withTerm: text, handler:
            (success: {
                (httpResponse,httpData) in
                guard let response = httpResponse as? HTTPURLResponse, let data = httpData else {
                    self.displayError()
                    return
                }
                if response.statusCode != 200 {
                    self.displayError(withTitle: "HTTP Error...", andMessage: "No Internet Connection?\nTyu again later...")
                }
                self.processResult(data)
            }, failure: {
                (httpResponse,systemError,errorMessage) in
                guard let message = errorMessage else {
                    self.displayError()
                    return
                }
                self.displayError(withTitle: "Error...", andMessage: message)
            })
        )

    }

    // MARK: Actions

    @IBAction func buttonPressed(sender: UIButton){
        switch sender{
        case self.searchButton:
            self.performSegue(withIdentifier: Segues.toResults.rawValue, sender: self)
        case self.clearButton:
            self.searchTextField.text = String.empty
        default:
            break
        }
    }

    @IBAction func retunToSearch(_ unwindSegue:UIStoryboardSegue){

    }
}

