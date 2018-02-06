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
            guard let weakSelf = self else { return }

            var flow = weakSelf.resolver.resolve(Flow.self, name: Flows.setup.rawValue)!
            flow.flowCompletion = { [weak self] _ in
                weakSelf.resolver.resolve(Browser.self)?.refresh()
            }
            controller.navigationController?.present(flow.createRootVC(), animated: true, completion: nil)
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

    func pushDeviceDetail(forDevice item: DeviceSelectItem, fromController controller: UIViewController?) {
        guard let device = item as? DeviceConvertible else {
            print("Selected item \(item) is not DeviceConvertible")
            return
        }

        let flow = self.resolver.resolve(Flow.self, name: Flows.detail.rawValue, argument: device.toDevice())!
        controller?.navigationController?.pushViewController(flow.createRootVC(), animated: true)
    }
}
