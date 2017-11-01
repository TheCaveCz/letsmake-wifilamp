//
//  ErrorExtensions.swift
//  wifilamp
//
//  Created by Lukas Machalik on 01/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
