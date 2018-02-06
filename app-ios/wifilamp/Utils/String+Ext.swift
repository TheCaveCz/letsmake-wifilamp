//
//  String+Ext.swift
//  wifilamp
//
//  Created by Martin Púčik on 06/02/2018.
//  Copyright © 2018 The Cave. All rights reserved.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
