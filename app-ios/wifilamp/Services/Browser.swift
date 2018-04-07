//
//  Browser.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 10/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

protocol BrowserDelegate: class {
    func browserStartedSearching(_ browser: Browser)
    func browser(_ browser: Browser, foundRecord record: BrowserRecord)
    func browser(_ browser: Browser, removedRecord record: BrowserRecord)
}


protocol BrowserRecord {
    var identifier: String { get }
}


class Browser: NSObject, NetServiceBrowserDelegate, NetServiceDelegate {
    let serviceType: String
    weak var delegate: BrowserDelegate?
    var records: [BrowserRecord] {
        return resolvedServices
    }
    
    private let browser: NetServiceBrowser
    private var servicesToResolve: [NetService] = []
    private var resolvedServices: [BrowserRecord] = []
    private var shouldRestartSearch: Bool = false
    private var converter: (NetService) -> BrowserRecord?
    private(set) var searching: Bool = false
    
    init(serviceType type: String = "_wifilamp._tcp.", converter: @escaping (NetService) -> BrowserRecord?) {
        serviceType = type
        self.converter = converter
        browser = NetServiceBrowser()
        
        super.init()
        
        browser.includesPeerToPeer = true
        browser.delegate = self
    }
    
    func startSearch() {
        if !searching {
            debugPrint("Starting search in local")
            browser.searchForServices(ofType: serviceType, inDomain: "local.")
        }
    }
    
    func stopSearch() {
        browser.stop()
    }
    
    func refresh() {
        if searching {
            shouldRestartSearch = true
            stopSearch()
        } else {
            startSearch()
        }
    }
    
    private func clearResults() {
        servicesToResolve.removeAll()
        resolvedServices.removeAll()
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String: NSNumber]) {
        print("Error \(errorDict)")
        clearResults()
        searching = false
    }
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        debugPrint("Browser will search")
        clearResults()
        searching = true
        delegate?.browserStartedSearching(self)
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        debugPrint("Browser did stop search")
        clearResults()
        searching = false
        if shouldRestartSearch {
            shouldRestartSearch = false
            debugPrint("Browser restarting search")
            startSearch()
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        debugPrint("Browser did find service \(service.name) ")

        service.delegate = self
        service.stop()
        service.resolve(withTimeout: 10)
        servicesToResolve.append(service)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        debugPrint("Browser did remove device \(service.name) ")

        servicesToResolve.removeFirst(element: service)
        if let crecord = converter(service), let record = resolvedServices.removeFirst(where: { $0.identifier == crecord.identifier }) {
            delegate?.browser(self, removedRecord: record)
        }
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        servicesToResolve.removeFirst(element: sender)
        if let record = converter(sender) {
            debugPrint("Browser did resolve address \(record)")
            resolvedServices.append(record)
            delegate?.browser(self, foundRecord: record)
        }
        sender.stop()
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String: NSNumber]) {
        debugPrint("Browser did not resolve address \(errorDict) ")
        servicesToResolve.removeFirst(element: sender)
    }
}
