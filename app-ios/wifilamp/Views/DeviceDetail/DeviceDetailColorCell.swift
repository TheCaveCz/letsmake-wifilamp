//
//  DeviceDetailColorCell.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 12/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


class DeviceDetailColorCell: UICollectionViewCell, DataLoadable {
    @IBOutlet weak private var colorView: UIView!
    
    func loadData(data: UIColor) {
        colorView.backgroundColor = data
        colorView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorView.layer.cornerRadius = self.bounds.width / 2
        colorView.layer.borderWidth = 3
    }
}
