//
//  DeviceSelectCells.swift
//  wifilamp
//
//  Created by Džindra on 08/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

class DeviceSelectCell: UITableViewCell, DataLoadable {
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    func loadData(data: DeviceSelectItem) {
        stateImage.image = data.icon
        nameLabel.text = data.name
        idLabel.text = data.details
    }
}

class DeviceSelectEmptyCell: UITableViewCell {
    
}

class DeviceSelectNearbyEmptyCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Public Interface
    func setIsLoading(_ isLoading: Bool) {
        infoLabel.text = isLoading ? "Searching for nearby lamps":"No other nearby lamps detected."
        isLoading ? activityIndicator.startAnimating():activityIndicator.stopAnimating()
    }
}
