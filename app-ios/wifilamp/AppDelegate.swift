//
//  AppDelegate.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 04/09/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mainFlow: Flow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
#if DEBUG
        do {
            try R.validate()
        } catch {
            fatalError("R validate failed with \(error)")
        }
#endif
        
        let context = ContextApp()
        mainFlow = MainFlow(context: context)
        
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
