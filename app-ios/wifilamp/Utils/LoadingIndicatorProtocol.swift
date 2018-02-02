//
//  LoadingIndicatorProtocol.swift
//  wifilamp
//
//  Created by Martina Stremenova on 04/12/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol LoadingIndicatorProtocol { }
extension LoadingIndicatorProtocol where Self: UIViewController {
    
    func showLoadingIndicator() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
