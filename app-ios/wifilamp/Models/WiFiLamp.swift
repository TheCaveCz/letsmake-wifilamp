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
import AwaitKit
import PromiseKit

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
    
    func setup(progressUpdate: ((String, Int, Int) -> Void)?) -> Promise<Void> {
        return async {
            let totalSteps = 4
            
            progressUpdate?("Checking if device is available on current network", 1, totalSteps)
            
            let isAccessibleOnCurrentNetwork = try await(self.checkIfAccessibleOnLocalNetwork())
            
            if isAccessibleOnCurrentNetwork {
                // we are done, we don't need to go trough network setup below
                return
            }
            
            progressUpdate?("Connecting to the lamp WiFi network", 2, totalSteps)
            
            try await(self.connectToTemporaryWiFiNetwork())
            defer {
                self.disconnectFromTemporaryWiFiNetwork()
            }
            
            progressUpdate?("Contacting WiFi lamp", 3, totalSteps)
            
            _ = try await(retry(times: 3, cooldown: 1) { self.getStatusOnTemporaryNetwork() })
            
            progressUpdate?("Scan for available WiFi networks", 4, totalSteps)
            
            let networks = try await(self.scanForWiFiNetworksAndWaitForResults())
            print(networks)
            
        }
    }
    
    private func connectToTemporaryWiFiNetwork() -> Promise<Void> {
        return Promise { resolve, reject in
            let lampWiFiConfig = NEHotspotConfiguration(ssid: self.setupNetworkSSID, passphrase: self.setupNetworkPassword, isWEP: false)
            lampWiFiConfig.joinOnce = true
            
            NEHotspotConfigurationManager.shared.apply(lampWiFiConfig, completionHandler: { error in
                if let error = error, error.code != NEHotspotConfigurationError.alreadyAssociated.rawValue {
                    self.disconnectFromTemporaryWiFiNetwork()
                    reject(error)
                } else {
                    resolve(Void())
                }
            })
        }
    }
    
    private func disconnectFromTemporaryWiFiNetwork() {
        NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: setupNetworkSSID)
    }
    
}

// MARK: - API
extension WiFiLamp {
    func checkIfAccessibleOnLocalNetwork() -> Promise<Bool> {
        return async {
            do {
                try await(self.getStatus())
                return true
            } catch where error.domain == NSURLErrorDomain && error.code == NSURLErrorTimedOut {
                return false
            }
        }
    }
    
    func getStatus() -> Promise<VoidResponse> {
        return apiCall(path: "/api/status")
    }
    
    func scanForWiFiNetworksAndWaitForResults() -> Promise<[WiFiNetwork]> {
        return async {
            // launch network sitesurvey on device
            _ = try await(self.performNewWiFiNetworksScan())
            
            // try 3 times until network scan ends and returns list of access points
            let scanResult: NetworkScanResult = try await(retry(times: 3, cooldown: 3) { self.getWiFiNetworksScanResult() })
            return scanResult.networks
        }
    }
    
    private func getStatusOnTemporaryNetwork() -> Promise<VoidResponse> {
        return apiCall(deviceUrl: Constants.WiFiLamp.defaultTemporaryNetworkUrl, path: "/api/status")
    }
    
    private func performNewWiFiNetworksScan() -> Promise<VoidResponse> {
        return apiCall(deviceUrl: Constants.WiFiLamp.defaultTemporaryNetworkUrl, path: "/api/scan", method: .post)
    }
    
    private func getWiFiNetworksScanResult() -> Promise<NetworkScanResult> {
        return async {
            let result: NetworkScanResult = try await(self.apiCall(deviceUrl: Constants.WiFiLamp.defaultTemporaryNetworkUrl, path: "/api/scan", method: .get))
            if result.inprogress {
                throw NetworkScanError.scanStillInProgress
            }
            return result
        }
    }
    
    private func apiCall<T: Codable>(
        deviceUrl: URL? = nil,
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        username: String = Constants.WiFiLamp.defaultUsername,
        password: String = Constants.WiFiLamp.defaultPassword
        ) -> Promise<T> {
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        let url = deviceUrl ?? baseUrl
        
        return APIManager.shared.request(url.appendingPathComponent(path), method: method, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseCodable()
    }
    
    struct NetworkScanResult: Codable {
        let inprogress: Bool
        let current: String
        let networks: [WiFiNetwork]
    }
    
    struct WiFiNetwork: Codable {
        let ssid: String
        let rssi: Int
        let enc: Int
    }
    
    enum NetworkScanError: Error {
        case scanStillInProgress
    }
}
