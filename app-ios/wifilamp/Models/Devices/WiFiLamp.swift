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
    let localNetworkUrl: URL
    
    init(chipId: String, name: String? = nil, localNetworkUrl: URL? = nil) {
        self.chipId = chipId
        self.name = name ?? "WiFi lamp (\(chipId))"
        // swiftlint:disable:next force_https
        self.localNetworkUrl = localNetworkUrl ?? URL(string: "http://wifilamp-\(chipId).local")!
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
    
    func setup(progressUpdate: ((String, Int, Int) -> Void)?, delegate: DeviceSetupDelegate?) -> Promise<Void> {
        return async {
            guard let delegate = delegate else {
                assert(false, "Setup of this device needs a delegate")
                return
            }
            
            let totalSteps = 8
            
            progressUpdate?("Checking if device is available on current network", 1, totalSteps)
            let isAccessibleOnCurrentNetwork = try await(self.checkIfAccessible())
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
            _ = try await(retry(times: 3, cooldown: 3) { self.getStatusOnTemporaryNetwork() })
            
            progressUpdate?("Scanning for available WiFi networks", 4, totalSteps)
            let networks = try await(self.scanForWiFiNetworksAndWaitForResultsOnTemporaryNetwork())
            
            progressUpdate?("Showing list of networks to select", 5, totalSteps)
            let (selectedNetwork, passphase) = try await(delegate.askUserToSelectWiFiNetwork(from: networks))
            
            progressUpdate?("Setting up lamp to selected WiFi network", 6, totalSteps)
            _ = try await(self.saveWiFiNetworkCredentialsOnTemporaryNetwork(network: selectedNetwork, passphase: passphase))
            
            progressUpdate?("Rebooting the lamp", 7, totalSteps)
            _ = try await(self.rebootOnTemporaryNetwork())
            self.disconnectFromTemporaryWiFiNetwork()
            
            progressUpdate?("Waiting for lamp to reboot", 8, totalSteps)
            _ = try await(retry(times: 4, cooldown: 4) { self.getStatus() })
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
    
    // MARK: Public API
    
    func checkIfAccessible(on deviceUrl: URL? = nil) -> Promise<Bool> {
        return async {
            do {
                try await(self.getStatus(on: deviceUrl))
                return true
            } catch where error.domain == NSURLErrorDomain && error.code == NSURLErrorTimedOut {
                return false
            }
        }
    }
    
    
    func getStatus(on deviceUrl: URL? = nil) -> Promise<WiFiLampInitialState> {
        return apiCall(deviceUrl: deviceUrl, path: "/api/status")
    }
    
    func scanForWiFiNetworksAndWaitForResults(on deviceUrl: URL? = nil) -> Promise<[WiFiLampNetwork]> {
        return async {
            // launch network sitesurvey on device
            _ = try await(self.performNewWiFiNetworksScan(on: deviceUrl))
            
            // try 3 times until network scan ends and returns list of access points
            let scanResult: NetworkScanResult = try await(retry(times: 3, cooldown: 3) { self.getWiFiNetworksScanResult(on: deviceUrl) })
            return scanResult.networks
        }
    }
    
    func saveWiFiNetworkCredentials(on deviceUrl: URL? = nil, network: WiFiNetwork, passphase: String?) -> Promise<VoidResponse> {
        let parameters: Parameters = [
            "ssid": network.name,
            "pass": passphase ?? ""
        ]
        return apiCall(deviceUrl: deviceUrl, path: "/api/wifi", method: .post, parameters: parameters)
    }
    
    func reboot(on deviceUrl: URL? = nil) -> Promise<VoidResponse> {
        let parameters: Parameters = [
            "reboot": true
        ]
        return apiCall(deviceUrl: deviceUrl, path: "/api/reboot", method: .post, parameters: parameters)
    }
    
    func setColor(on deviceUrl: URL, _ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> Promise<VoidResponse> {
        let parameters: Parameters = [
            "r": red,
            "g": green,
            "b": blue
        ]
        return apiCall(deviceUrl: deviceUrl, path: "/api/color", method: .post, parameters: parameters)
    }
    
    func turn(on isOn: Bool, on deviceUrl: URL) -> Promise<VoidResponse> {
        let parameters: Parameters = [
            "on": isOn
        ]
        return apiCall(deviceUrl: deviceUrl, path: "/api/on", method: .post, parameters: parameters)
    }
    
    // MARK: Private API
    
    private func getStatusOnTemporaryNetwork() -> Promise<WiFiLampInitialState> {
        return getStatus(on: Constants.WiFiLamp.defaultTemporaryNetworkUrl)
    }
    
    private func scanForWiFiNetworksAndWaitForResultsOnTemporaryNetwork() -> Promise<[WiFiLampNetwork]> {
        return scanForWiFiNetworksAndWaitForResults(on: Constants.WiFiLamp.defaultTemporaryNetworkUrl)
    }
    
    private func saveWiFiNetworkCredentialsOnTemporaryNetwork(network: WiFiNetwork, passphase: String?) -> Promise<VoidResponse> {
        return saveWiFiNetworkCredentials(on: Constants.WiFiLamp.defaultTemporaryNetworkUrl, network: network, passphase: passphase)
    }
    
    private func rebootOnTemporaryNetwork() -> Promise<VoidResponse> {
        return reboot(on: Constants.WiFiLamp.defaultTemporaryNetworkUrl)
    }
    
    private func performNewWiFiNetworksScan(on deviceUrl: URL?) -> Promise<VoidResponse> {
        return apiCall(deviceUrl: deviceUrl, path: "/api/scan", method: .post)
    }
    
    private func getWiFiNetworksScanResult(on deviceUrl: URL?) -> Promise<NetworkScanResult> {
        return async {
            let result: NetworkScanResult = try await(self.apiCall(deviceUrl: deviceUrl, path: "/api/scan", method: .get))
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
        
        let url = deviceUrl ?? localNetworkUrl
        
        return APIManager.shared.request(url.appendingPathComponent(path), method: method, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseCodable()
    }
    
    // MARK: Responses
    
    struct NetworkScanResult: Codable {
        let inprogress: Bool
        let current: String
        let networks: [WiFiLampNetwork]
    }
    
    struct WiFiLampNetwork: Codable, WiFiNetwork {
        let ssid: String
        let rssi: Int
        let enc: Int
        
        var name: String { return ssid }
        var signalStrength: Int {
            return rssi
        }
        var isPasswordProtected: Bool {
            switch enc {
            case 5: return true // ENC_TYPE_WEP
            case 2: return true // ENC_TYPE_TKIP
            case 4: return true // ENC_TYPE_CCMP
            case 7: return false // ENC_TYPE_NONE
            default: return true // unknown, ask for password anyway and try to connect
            }
        }
    }
    
    enum NetworkScanError: Error {
        case scanStillInProgress
    }
}

struct WiFiLampInitialState: Codable {
    
    let color: UIColor
    let isOn: Bool
    
    enum CodingKeys: String, CodingKey {
        case red = "r"
        case green = "g"
        case blue = "b"
        case isOn = "on"
        
        // root key
        case current
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: WiFiLampInitialState.CodingKeys.current)
        
        let red = try nestedContainer.decode(CGFloat.self, forKey: .red)
        let green = try nestedContainer.decode(CGFloat.self, forKey: .green)
        let blue = try nestedContainer.decode(CGFloat.self, forKey: .blue)
        
        print("\n[LAMP] Red:\(red) Green:\(green) Blue:\(blue)\n")
        self.color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
        self.isOn = try nestedContainer.decode(Bool.self, forKey: .isOn)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
