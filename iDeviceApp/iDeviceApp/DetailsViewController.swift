//
//  DetailsViewController.swift
//  iDeviceApp
//
//  Created by Oliver Paray on 6/24/19.
//  Copyright © 2019 Oliver Paray. All rights reserved.
//

import Library
import UIKit

class DetailsViewController: UITableViewController {

    static let detailImageCell = "detailImageCell"
    static let detailItemCell = "detailItemCell"
    static let detailLinkCell = "detailLinkCell"
    static let detailPreviewCell = "detailPreviewCell"
    static let detailDescriptionCell = "detailDescriptionCell"

    // MARK: Properties

    public var DetailsToDisplay:JSON?

    private var selectedDetails: [String] {
        get {
            var result = [String]()
            if self.isPreviewAvailable {
                for item in iTunesSearch.ResultKeys.PreviewableKeys.allCases {
                    result.append(item.rawValue)
                }
            } else {
                for item in iTunesSearch.ResultKeys.DescribableKeys.allCases {
                    result.append(item.rawValue)
                }
            }
            return result
        }
    }

    private var isPreviewAvailable: Bool {
        get {
            var result = false
            guard let details = self.DetailsToDisplay, let keys = details.allKeys as? [String] else {
                return result
            }
            result = keys.contains(iTunesSearch.ResultKeys.PreviewableKeys.previewUrl.rawValue)
            return result
        }
    }

    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Delegates

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        if self.isPreviewAvailable {
            result = iTunesSearch.ResultKeys.PreviewableKeys.allCases.count
        } else {
            result = iTunesSearch.ResultKeys.DescribableKeys.allCases.count
        }
        return result
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataType = self.selectedDetails[indexPath.row]
        switch dataType {
        case iTunesSearch.ResultKeys.PreviewableKeys.previewUrl.rawValue:
            return (self.tableView.bounds.height * 9)/16
        case iTunesSearch.ResultKeys.DescribableKeys.description.rawValue:
            guard let details = self.DetailsToDisplay, let description = details[iTunesSearch.ResultKeys.DescribableKeys.description.rawValue] else {
                return self.tableView.bounds.height
            }
            let descriptionText = "\(description)"
            return descriptionText.height(withConstrainedWidth: self.tableView.bounds.height - 32.0, font: UIFont.systemFont(ofSize: 16.0))
        default:
            return 25
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = DetailsViewController.detailItemCell
        let dataType = self.selectedDetails[indexPath.row]
        switch dataType {
        case iTunesSearch.ResultKeys.PreviewableKeys.previewUrl.rawValue:
            identifier = DetailsViewController.detailPreviewCell
        case iTunesSearch.ResultKeys.DescribableKeys.description.rawValue:
            identifier = DetailsViewController.detailDescriptionCell
        case iTunesSearch.ResultKeys.PreviewableKeys.trackViewUrl.rawValue:
            identifier = DetailsViewController.detailLinkCell
        default:
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        return cell
    }

}
