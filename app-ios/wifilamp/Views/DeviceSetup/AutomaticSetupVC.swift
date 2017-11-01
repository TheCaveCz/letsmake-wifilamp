//
//  AutomaticSetupVC.swift
//  wifilamp
//
//  Created by Lukas Machalik on 31/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

final class AutomaticSetupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let lamp = WiFiLamp(chipId: "24736e")
        lamp.isAccessibleOnLocalNetwork(result: { result in
            print("result: \(result)")
        }, failure: { error in
            print("error: \(error)")
        })
    }
}
