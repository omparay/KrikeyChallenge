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

    func getItemAtIndex(_ index: Int) -> JSON? {
        guard let results = self.ResultsToDisplay,
            let items = results[iTunesSearch.ResultKeys.results.rawValue] as? [JSON] else {
                return nil
        }
        if items.count > index {
            return items[index]
        } else {
            return nil
        }
    }

    func discernPrice(_ item:JSON) -> String?{
        var result: String?
        if let price = item[iTunesSearch.ResultKeys.CommonKeys.price.rawValue] {
            result = "\(price)"
        } else if let trackPrice = item[iTunesSearch.ResultKeys.CommonKeys.trackPrice.rawValue] {
            result = "\(trackPrice)"
        }
        return result
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

        let imageView = cell.contentView.viewWithTag(1) as? UIImageView
        let kindLabel = cell.contentView.viewWithTag(2) as! UILabel
        let artistLabel = cell.contentView.viewWithTag(3) as! UILabel
        let titleLabel = cell.contentView.viewWithTag(4) as! UILabel
        let priceLabel = cell.contentView.viewWithTag(5) as! UILabel

        if let item = self.getItemAtIndex(indexPath.row){
            kindLabel.text = "\(item[iTunesSearch.ResultKeys.CommonKeys.kind.rawValue] ?? "Not Available")"
            artistLabel.text = "\(item[iTunesSearch.ResultKeys.CommonKeys.artistName.rawValue] ?? "Not Available")"
            titleLabel.text = "\(item[iTunesSearch.ResultKeys.CommonKeys.trackCensoredName.rawValue] ?? "Not Available")"
            priceLabel.text = self.discernPrice(item)
            if let imageUrl = item[iTunesSearch.ResultKeys.CommonKeys.artworkUrl100.rawValue] as? String{
                let client = HttpClient()
                client.execute(serviceUrl: imageUrl, webMethod: .Get, executionHandler:
                    (success: {
                        (httpResponse, httpData) in
                        if let data = httpData, let image = UIImage(data: data), let view = imageView {
                            DispatchQueue.main.async {
                                view.image = image
                            }
                        }
                    }, failure: {
                        (httpResponse, systemError, errorMessage) in
                        if let view = imageView {
                            DispatchQueue.main.async {
                                view.image = nil
                            }
                        }
                    }
                ))
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = self.getItemAtIndex(indexPath.row) {
            self.selectedResult = item
            self.performSegue(withIdentifier: Segues.toDetails.rawValue, sender: self)
        }
    }
}
