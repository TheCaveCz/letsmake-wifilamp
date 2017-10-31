//
//  AppDelegate.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 04/09/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mainFlow: Flow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//#if DEBUG
//        do {
//            try R.validate()
//        } catch {
//            fatalError("R validate failed with \(error)")
//        }
//#endif
        
        let assembler = Assembler([
            CoreAssembly(),
            DeviceSelectAssembly()
        ])
        
        mainFlow = assembler.resolver.resolve(Flow.self, name: Flows.main.rawValue)!
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 128/255, green: 204/255, blue: 40/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().shadowImage = UIImage()

        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.rootViewController = mainFlow.createRootVC()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

}

class CoreAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Browser.self) { _ in
            return Browser()
        }.inObjectScope(.container)
    }
    
    func loaded(resolver: Resolver) {
        resolver.resolve(Browser.self)?.startSearch()
    }
}

enum Flows: String {
    case main
    case detail
    case setup
}


class DeviceSelectAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Flow.self, name: Flows.main.rawValue) { res in
            return MainFlow(resolver: res)
        }
        container.register(DeviceSelectVM.self) { res in
            return DeviceSelectVM(browser: res.resolve(Browser.self)!)
        }
        container.register(DeviceSelectVC.self) { res in
            let vc = R.storyboard.main.deviceSelectVC()!
            vc.viewModel = res.resolve(DeviceSelectVM.self)
            return vc
        }
        
        container.register(Flow.self, name: Flows.detail.rawValue) { _, arg1 in
            return DeviceFlow(device: arg1)
        }
        
        container.register(Flow.self, name: Flows.setup.rawValue) { res in
            return SetupFlow(resolver: res)
        }
        
        container.register(QRScannerVC.self) { _ in
            let vc = R.storyboard.setupFlow.qrScannerVC()!
            return vc
        }
    }
}
