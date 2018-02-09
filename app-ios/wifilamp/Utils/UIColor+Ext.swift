//
//  UIColor+Ext.swift
//  wifilamp
//
//  Created by Martin Púčik on 09/02/2018.
//  Copyright © 2018 The Cave. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        let unpackRed: CGFloat = (red >= 0 && red <= 255) ? CGFloat(red):0
        let unpackGreen = (green >= 0 && green <= 255) ? CGFloat(green):0
        let unpackBlue = (blue >= 0 && blue <= 255) ? CGFloat(blue):0

        self.init(red: unpackRed/255.0, green: unpackGreen/255.0, blue: unpackBlue/255.0, alpha: 1.0)
    }

    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
    }

    func toHex() -> Int {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r*255) << 16 | (Int)(g*255) << 8 | (Int)(b*255) << 0
        let string = NSString.init(format: "%06x", rgb)
        return Int(string as String, radix: 16)!
    }
}
