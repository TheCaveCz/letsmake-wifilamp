//
//  Appearance.swift
//  wifilamp
//
//  Created by Martina Stremenova on 04/12/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import SVProgressHUD

struct Appearance {
    
    static func set() {
        // to block UI when showing loading idicator
         SVProgressHUD.setDefaultMaskType(.gradient)
    }
}
