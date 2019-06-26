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

    private var selectedDetails = Array<Any>()

    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Delegates

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }

}
