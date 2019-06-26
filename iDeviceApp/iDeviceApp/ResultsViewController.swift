//
//  ResultsViewController.swift
//  iDeviceApp
//
//  Created by Oliver Paray on 6/24/19.
//  Copyright © 2019 Oliver Paray. All rights reserved.
//

import Library
import UIKit

class ResultsViewController: UITableViewController {

    static let resultItemCell = "resultItemCell"

    // MARK: Properties

    public var ResultsToDisplay:JSON?
    private var selectedResult: JSON?

    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.toDetails.rawValue:
            guard let destination = segue.destination as? DetailsViewController else {
                return
            }
            destination.DetailsToDisplay = selectedResult
        default:
            break
        }
    }

    // MARK: Delegates

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let json = self.ResultsToDisplay,
            let result = json[iTunesSearch.ResultKeys.resultCount.rawValue] as? Int else {
            return 0
        }
        return result
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultsViewController.resultItemCell, for: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let results = self.ResultsToDisplay, let items = results[iTunesSearch.ResultKeys.results.rawValue] as? [JSON] else {
            return
        }
        if items.count > indexPath.row {
            self.selectedResult = items[indexPath.row]
            self.performSegue(withIdentifier: Segues.toDetails.rawValue, sender: self)
        }
    }
}
