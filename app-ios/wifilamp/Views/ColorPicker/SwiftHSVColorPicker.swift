//
//  SwiftHSVColorPicker.swift
//  SwiftHSVColorPicker
//
//  Created by johankasperi on 2015-08-20.
//

import UIKit

public protocol SwiftHSVColorPickerDelegate: class {
    func colorPicker(_ picker: SwiftHSVColorPicker, didChangeColor color: UIColor)
}

open class SwiftHSVColorPicker: UIView, ColorWheelDelegate, BrightnessViewDelegate {
    private var colorWheel: ColorWheel!
    private var brightnessView: BrightnessView!

    open weak var delegate: SwiftHSVColorPickerDelegate?
    
    open var color: UIColor {
        get {
            return UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        }
        set(value) {
            var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
            value.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
            self.hue = hue
            self.saturation = saturation
            self.brightness = brightness
            
            colorWheel.color = value
            brightnessView.setViewColor(value)
        }
    }
    private(set) var hue: CGFloat = 1.0
    private(set) var saturation: CGFloat = 1.0
    private(set) var brightness: CGFloat = 1.0
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    private func setupViews() {
        let brightnessViewHeight: CGFloat = 26.0
        let colorWheelSize = min(self.bounds.width, self.bounds.height - brightnessViewHeight)
        let centeredX = (self.bounds.width - colorWheelSize) / 2.0
        
        backgroundColor = .clear
        
        colorWheel = ColorWheel(frame: CGRect(x: centeredX, y: 0, width: colorWheelSize, height: colorWheelSize))
        colorWheel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        colorWheel.color = color
        colorWheel.delegate = self
        self.addSubview(colorWheel)
        
        brightnessView = BrightnessView(frame: CGRect(x: centeredX, y: colorWheel.frame.maxY, width: colorWheelSize, height: brightnessViewHeight), color: self.color)
        brightnessView.delegate = self
        brightnessView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.addSubview(brightnessView)
    }
    
    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat) {
        self.hue = hue
        self.saturation = saturation

        let color = self.color
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        print("\(r) \(g) \(b)")
        
        brightnessView.setViewColor(color)
        delegate?.colorPicker(self, didChangeColor: color)
    }
    
    func brightnessSelected(_ brightness: CGFloat) {
        self.brightness = brightness

        colorWheel.brightness = brightness
        delegate?.colorPicker(self, didChangeColor: self.color)
    }

}
