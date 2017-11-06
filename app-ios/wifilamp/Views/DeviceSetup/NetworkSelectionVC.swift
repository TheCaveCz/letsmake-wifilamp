//
//  NetworkSelectionVC.swift
//  wifilamp
//
//  Created by Lukas Machalik on 06/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

final class NetworkSelectionVC: UIViewController {

    var actionNetworkSelected: ((NetworkSelectionVC, WiFiNetwork, String?) -> Void)?
    var actionCancelled: ((NetworkSelectionVC) -> Void)?
    
    var viewModel: NetworkSelectionVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(viewModel.allNetworks)
    }

}
