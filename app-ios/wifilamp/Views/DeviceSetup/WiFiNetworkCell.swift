//
//  WiFiNetworkCell.swift
//  wifilamp
//
//  Created by Lukas Machalik on 07/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

final class WiFiNetworkCell: UITableViewCell, DataLoadable {

    @IBOutlet weak var networkNameLabel: UILabel!
    @IBOutlet weak var lockIcon: UIImageView!
    @IBOutlet weak var signalStrengthIcon: UIImageView!
    
    func loadData(data: WiFiNetwork) {
        networkNameLabel.text = data.name
        lockIcon.isHidden = !data.isPasswordProtected
        signalStrengthIcon.image = data.signalIndicatorIcon
    }
}

extension WiFiNetwork {
    var signalIndicatorIcon: UIImage {
        switch signalStrength {
        case (-60)...:
            return #imageLiteral(resourceName: "signalStrengthHigh")
        case (-80)...:
            return #imageLiteral(resourceName: "signalStrengthMedium")
        case (-90)...:
            return #imageLiteral(resourceName: "signalStrengthLow")
        default:
            return #imageLiteral(resourceName: "signalStrengthVeryLow")
        }
    }
}
