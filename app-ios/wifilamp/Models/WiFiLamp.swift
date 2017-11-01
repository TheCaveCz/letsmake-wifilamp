//
//  WiFiLamp.swift
//  wifilamp
//
//  Created by Lukas Machalik on 01/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import Alamofire

class WiFiLamp: Device {
    let chipId: String
    var name: String
    let baseUrl: URL
    
    init(chipId: String, name: String? = nil, baseUrl: URL? = nil) {
        self.chipId = chipId
        self.name = name ?? "WiFi lamp (\(chipId))"
        // swiftlint:disable:next force_https
        self.baseUrl = baseUrl ?? URL(string: "http://wifilamp-\(chipId).local")!
    }
}

// MARK: - API
extension WiFiLamp {
    func isAccessibleOnLocalNetwork(result: @escaping (Bool) -> Void, failure: ((Error) -> Void)?) {
        getStatus(success: { _ in
            result(true)
        }, failure: { error in
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorTimedOut {
                result(false)
            } else {
                failure?(error)
            }
        })
    }
    
    func getStatus(success: ((Any) -> Void)?, failure: ((Error) -> Void)?) {
        apiCall(path: "/api/status", success: success, failure: failure)
    }
    
    private func apiCall(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        username: String = Constants.WiFiLamp.defaultUsername,
        password: String = Constants.WiFiLamp.defaultPassword,
        success: ((Any) -> Void)?,
        failure: ((Error) -> Void)?
        ) {
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        APIManager.shared.request(baseUrl.appendingPathComponent(path), method: method, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let jsonResponse):
                    success?(jsonResponse)
                case .failure(let error):
                    failure?(error)
                }
        }
    }
}
