//
//  MainFlow.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 11/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import Swinject

protocol Flow {
    func createRootVC() -> UIViewController
    var flowCompletion: ((_ isSuccess: Bool) -> Void)? { get set }
}

class MainFlow: Flow {

    // MARK: - Public Props
    var flowCompletion: ((_ isSuccess: Bool) -> Void)?
    
    let resolver: Resolver

    lazy var rootController: CustomNavigationController = {
        let deviceController = resolver.resolve(DeviceSelectVC.self)!

        deviceController.actionSetupNewDevice = { [weak self] controller in
            self?.setupNewDevice(controller: controller)
        }

        deviceController.actionSelectDevice = { [weak self] controller, item in
            self?.pushDeviceDetail(forDevice: item, fromController: controller)
        }

        return CustomNavigationController(rootViewController: deviceController)
    }()

    // MARK: - Lifecycle
    init(resolver: Resolver) {
        self.resolver = resolver
    }

    // MARK: - Interface methods
    func createRootVC() -> UIViewController {
        return rootController
    }
    
    func setupNewDevice(controller: UIViewController) {
        var flow = self.resolver.resolve(Flow.self, name: Flows.setup.rawValue)!
        flow.flowCompletion = { [weak self] _ in
            self?.resolver.resolve(Browser.self)?.refresh()
        }
        controller.navigationController?.present(flow.createRootVC(), animated: true, completion: nil)
    }

    func pushDeviceDetail(forDevice item: DeviceSelectItem, fromController controller: UIViewController?) {
        guard let device = item as? Device else {
            print("Selected item \(item) is not Device")
            return
        }

        // TODO: some kind of dispatcher for different devices
        let flow = self.resolver.resolve(Flow.self, name: Flows.detail.rawValue, argument: device)!
        controller?.navigationController?.pushViewController(flow.createRootVC(), animated: true)
    }
}
