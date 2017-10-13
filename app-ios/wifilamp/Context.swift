//
//  Context.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 11/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit


protocol Flow {
    func createRootVC() -> UIViewController
}


protocol Context {
    var browser: Browser { get }
}


struct ContextApp: Context {
    let browser = Browser()
}
