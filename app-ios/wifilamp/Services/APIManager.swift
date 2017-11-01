//
//  APIManager.swift
//  wifilamp
//
//  Created by Lukas Machalik on 01/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation
import Alamofire

struct APIManager {
    static let shared: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        return Alamofire.SessionManager(configuration: configuration)
    }()
}
