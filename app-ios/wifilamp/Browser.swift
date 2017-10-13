//
//  Browser.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 10/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

protocol BrowserDelegate {
    func browser(_ browser: Browser, foundRecord record: BrowserRecord)
    func browser(_ browser: Browser, removedRecord record: BrowserRecord)
}


class Browser: NSObject, NetServiceBrowserDelegate, NetServiceDelegate {
    let serviceType: String
    var delegate: BrowserDelegate?
    var records: [BrowserRecord] {
        return resolvedServices
    }
    
    private let browser: NetServiceBrowser
    private var servicesToResolve: [NetService] = []
    private var resolvedServices: [BrowserRecord] = []
    private var searching: Bool = false
    
    init(serviceType t: String = "_wifilamp._tcp.") {
        serviceType = t
        browser = NetServiceBrowser()
        
        super.init()
        
        browser.includesPeerToPeer = true
        browser.delegate = self
    }
    
    func startSearch() {
        browser.searchForServices(ofType: serviceType, inDomain: "local.")
    }
    
    func stopSearch() {
        browser.stop()
    }
    
    private func clearResults() {
        servicesToResolve.removeAll()
        resolvedServices.removeAll()
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("Error \(errorDict)")
        clearResults()
        searching = false
    }
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        clearResults()
        searching = true
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        clearResults()
        searching = false
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self
        service.resolve(withTimeout: 10)
        servicesToResolve.append(service)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        servicesToResolve.removeFirst(element: service)
        if let record = resolvedServices.removeFirst(where: { $0.service == service }) {
            delegate?.browser(self, removedRecord: record)
        }
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        servicesToResolve.removeFirst(element: sender)
        if let record = BrowserRecord.from(service: sender) {
            resolvedServices.append(record)
            delegate?.browser(self, foundRecord: record)
        }
        sender.stop()
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        servicesToResolve.removeFirst(element: sender)
    }
    
}


struct BrowserRecord {
    static let removedPrefix = "The Cave "
    
    let name: String
    let hostName: String
    let url: URL
    let chipId: String
    fileprivate let service: NetService
    
    static func from(service: NetService) -> BrowserRecord? {
        guard let data = service.txtRecordData(), let hostName = service.hostName, let url = URL(string:"http://\(hostName)") else {
            return nil
        }
        
        guard let chipIdData = NetService.dictionary(fromTXTRecord: data)["chipid"], let chipId = String(data: chipIdData, encoding:.utf8) else {
            return nil
        }
        
        var name = service.name
        if name.hasPrefix(removedPrefix) {
            name.removeFirst(removedPrefix.count)
        }
        
        return BrowserRecord(name: name, hostName: hostName, url: url, chipId: chipId, service: service)
    }
}
