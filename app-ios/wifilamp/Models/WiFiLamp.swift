//
//  WiFiLamp.swift
//  wifilamp
//
//  Created by Lukas Machalik on 01/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import Alamofire
import NetworkExtension

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

// MARK: - Initial device configuration
extension WiFiLamp {
    
    private var setupNetworkSSID: String {
        return "WiFi-Lamp-\(chipId)"
    }
    private var setupNetworkPassword: String {
        return "wifilamp"
    }
    
    func setup(
        success: @escaping (() -> Void),
        failure: @escaping ((Error) -> Void),
        progressUpdate: ((String, Int, Int) -> Void)?
        ) {
        
        let totalSteps = 4
        
        progressUpdate?("Checking if device is available on current network", 1, totalSteps)
        
        self.checkIfAccessibleOnLocalNetwork(result: { [weak self] isAccessible in
            if isAccessible {
                success()
            } else {
                progressUpdate?("Connecting to the lamp WiFi network", 2, totalSteps)
                
                guard let setupNetworkSSID = self?.setupNetworkSSID, let setupNetworkPassword = self?.setupNetworkPassword else { return }
                
                let lampWiFiConfig = NEHotspotConfiguration(ssid: setupNetworkSSID, passphrase: setupNetworkPassword, isWEP: false)
                lampWiFiConfig.joinOnce = true
                
                NEHotspotConfigurationManager.shared.apply(lampWiFiConfig, completionHandler: { error in
                    if let error = error, error.code != NEHotspotConfigurationError.alreadyAssociated.rawValue {
                        NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: setupNetworkSSID)
                        failure(error)
                        return
                    }
                    
                    progressUpdate?("Waiting to get IP address", 3, totalSteps)
                    
                    delay(10, closure: {
                        progressUpdate?("Contacting WiFi lamp", 4, totalSteps)
                        
                        self?.getStatusOnTemporaryNetwork(success: { json in
                            print("\(json)")
                            
                            NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: setupNetworkSSID)
                        }, failure: { error in
                            print(error)
                            
                            NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: setupNetworkSSID)
                        })
                    })
                    
                })
            }
            }, failure: failure)
        
    }
}

// MARK: - API
extension WiFiLamp {
    func checkIfAccessibleOnLocalNetwork(result: @escaping (Bool) -> Void, failure: ((Error) -> Void)?) {
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
    
    private func getStatusOnTemporaryNetwork(success: ((Any) -> Void)?, failure: ((Error) -> Void)?) {
        // swiftlint:disable:next force_https
        apiCall(deviceUrl: URL(string: "http://192.168.4.1")!, path: "/api/status", success: success, failure: failure)
    }
    
    private func apiCall(
        deviceUrl: URL? = nil,
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
        
        let url = deviceUrl ?? baseUrl
        
        APIManager.shared.request(url.appendingPathComponent(path), method: method, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
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

func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
