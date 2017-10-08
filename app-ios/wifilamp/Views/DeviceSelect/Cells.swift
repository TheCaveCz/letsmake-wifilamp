//
//  DeviceSelectCells.swift
//  wifilamp
//
//  Created by Džindra on 08/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


class DeviceSelectCell: UITableViewCell, NibAware, DataLoadable {
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    func loadData(data: DeviceSelectItem) {
        stateImage.image = data.icon
        nameLabel.text = data.name
        idLabel.text = data.details
    }
}


class DeviceSelectEmptyCell: UITableViewCell, NibAware {
    
}


class DeviceSelectNearbyEmptyCell: UITableViewCell, NibAware {
    
}


class DeviceSelectNearbyLoadingCell: UITableViewCell, NibAware {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}
