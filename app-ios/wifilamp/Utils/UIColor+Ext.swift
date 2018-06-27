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
        let unpackRed = (red >= 0 && red <= 255) ? CGFloat(red):0
        let unpackGreen = (green >= 0 && green <= 255) ? CGFloat(green):0
        let unpackBlue = (blue >= 0 && blue <= 255) ? CGFloat(blue):0

        self.init(red: unpackRed/255.0, green: unpackGreen/255.0, blue: unpackBlue/255.0, alpha: 1.0)
    }

    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
    }

    func toHex() -> Int {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: nil)

        return (Int)(red*255) << 16 | (Int)(green*255) << 8 | (Int)(blue*255) << 0
    }
    
    // swiftlint:disable:next large_tuple
    func toRgb() -> (Int, Int, Int) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return ((Int)(red*255), (Int)(green*255), (Int)(blue*255))
    }
}
