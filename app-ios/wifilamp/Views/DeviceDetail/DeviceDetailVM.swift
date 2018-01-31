//
//  DeviceDetailVM.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 12/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import AwaitKit
import PromiseKit

protocol DisplayErrorDelegate: class {
    func displayError(message: String)
}

protocol DeviceDetailVMDelegate: DisplayErrorDelegate {
    func didFinishLoadingInitialData(_ color: UIColor, _ isOn: Bool)
}

class DeviceDetailVM {
    private let device: Device
    weak var delegate: DeviceDetailVMDelegate?
    
    var title: String {
        return device.name
    }
    
    let colors: [UIColor] = [
        UIColor(red: 1, green: 0x69/255, blue: 0, alpha: 1),
        UIColor(red: 0xff/255, green: 189/255, blue: 0, alpha: 1),
        UIColor(red: 142/255, green: 255/255, blue: 210/255, alpha: 1),
        UIColor(red: 0, green: 0xd0/255, blue: 0x84/255, alpha: 1),
        UIColor(red: 0x8e/255, green: 0xd1/255, blue: 0xfc/255, alpha: 1),
        UIColor(red: 0x06/255, green: 0x93/255, blue: 0xe3/255, alpha: 1),
        UIColor(red: 0xab/255, green: 0xb8/255, blue: 0xc3/255, alpha: 1),
        UIColor(red: 0xeb/255, green: 0x14/255, blue: 0x4c/255, alpha: 1),
        UIColor(red: 0xf7/255, green: 0x8d/255, blue: 0xa7/255, alpha: 1),
        UIColor(red: 0x99/255, green: 0, blue: 0xef/255, alpha: 1),
        UIColor(red: 1, green: 1, blue: 1, alpha: 1),
        UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    ]
    
    init(device: Device) {
        self.device = device
    }
    
    // To load initial device state when displaying the detail
    func getInitialState() {
        guard let lamp = self.device as? WiFiLamp else { return }
        
        async {
            do {
                let initialState = try await(lamp.getStatus(on: self.device.localNetworkUrl))
                DispatchQueue.main.async {
                    self.delegate?.didFinishLoadingInitialData(initialState.color, initialState.isOn)
                }
            } catch {
                // TODO: Handle Specific Error
                DispatchQueue.main.async {
                    self.delegate?.displayError(message: "Could not connect to the device.")
                }
            }
        }
    }
    
    func updateColor(color: UIColor) {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        let roundR =  round(r * 255.0)
        let roundG =  round(g * 255.0)
        let roundB =  round(b * 255.0)
        
        print("\n[APP] Red:\(roundR) Green: \(roundG) Blue:\(roundB)\n")
        _ = self.device.setColor(on: self.device.localNetworkUrl, roundR, roundG, roundB)
    }
    
    func updateState(isOn: Bool) {
        _ = self.device.turn(on: isOn, on: self.device.localNetworkUrl)
    }

    // MARK: - Saving device
    func deviceIsSaved() -> Bool {
        guard let device = device as? WiFiLamp else { return false }
        return Defaults.deviceIsSaved(device)
    }

    func saveDevice() {
        guard let device = device as? WiFiLamp else { return }
        Defaults.saveDevice(device)
    }

    func removeDeviceFromSaved() {
        guard let device = device as? WiFiLamp else { return }
        Defaults.removeSavedDevice(device)
    }
}
