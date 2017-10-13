//
//  DeviceSelectVM.swift
//  wifilamp
//
//  Created by Džindra on 07/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


protocol DeviceSelectItem {
    var icon: UIImage { get }
    var name: String { get }
    var details: String { get }
}


protocol DeviceSelectVMDelegate: class {
    
    func nearbyDevicesChanged()
    
}


class DeviceSelectVM {
    private let browser: Browser
    weak var delegate: DeviceSelectVMDelegate?
    
    var nearbyDevices: [DeviceSelectItem] {
        return browser.records
    }
    
    var savedDevices: [DeviceSelectItem] = [
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Item 1", details: "some"),
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Item 2", details: "some"),
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Item 3", details: "some"),
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Item 3", details: "some"),
        DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Item 3", details: "some"),DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Item 3", details: "some"),DeviceDummy(icon: #imageLiteral(resourceName: "gear"), name: "Item 3 ekfjnsdkjfnsdkjfnsdkjfnsdkfjnsdf", details: "some"),
    ]
    
    
    init(browser: Browser) {
        self.browser = browser
        browser.delegate = self
    }
    
    func deleteSaved(index: Int) {
        savedDevices.remove(at: index)
    }
}


extension DeviceSelectVM: BrowserDelegate {
    func browser(_ browser: Browser, foundRecord record: BrowserRecord) {
        delegate?.nearbyDevicesChanged()
    }
    
    func browser(_ browser: Browser, removedRecord record: BrowserRecord) {
        delegate?.nearbyDevicesChanged()
    }
}


extension BrowserRecord: DeviceSelectItem {
    var icon: UIImage {
        return R.image.lampOff()!
    }
    
    var details: String {
        return chipId
    }
    
    
}


struct DeviceDummy: DeviceSelectItem, DeviceConvertible {
    var icon: UIImage
    var name: String
    var details: String
    
    func toDevice() -> Device {
        return Device.dummy
    }
}
