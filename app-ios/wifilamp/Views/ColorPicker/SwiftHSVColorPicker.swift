//
//  SwiftHSVColorPicker.swift
//  SwiftHSVColorPicker
//
//  Created by johankasperi on 2015-08-20.
//  Modified by dzindra on 2017-10-15.
//

import UIKit

@objc protocol SwiftHSVColorPickerDelegate: class {
    func colorPicker(_ picker: SwiftHSVColorPicker, didChangeColor color: UIColor)
}

class SwiftHSVColorPicker: UIView, ColorWheelDelegate, BrightnessViewDelegate {
    private var colorWheel: ColorWheel!
    private var brightnessView: BrightnessView!

    @IBOutlet weak var delegate: SwiftHSVColorPickerDelegate?
    
    var color: UIColor {
        get {
            return UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        }
        set(value) {
            var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
            value.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
            
            self.hue = hue
            self.saturation = saturation
            self.brightness = brightness
        }
    }
    var hue: CGFloat = 1.0 {
        didSet {
            brightnessView.hue = hue
            colorWheel.hue = hue
        }
    }
    var saturation: CGFloat = 1.0 {
        didSet {
            brightnessView.saturation = saturation
            colorWheel.saturation = saturation
        }
    }
    var brightness: CGFloat = 1.0 {
        didSet {
            brightnessView.brightness = brightness
            colorWheel.brightness = brightness
        }
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    private func setupViews() {
        let brightnessViewHeight: CGFloat = 28.0
        let colorWheelSize = min(self.bounds.width, self.bounds.height - brightnessViewHeight)
        let centeredX = (self.bounds.width - colorWheelSize) / 2.0
        
        backgroundColor = .clear
        
        colorWheel = ColorWheel(frame: CGRect(x: centeredX, y: 0, width: colorWheelSize, height: colorWheelSize))
        colorWheel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        colorWheel.hue = hue
        colorWheel.saturation = saturation
        colorWheel.brightness = brightness
        colorWheel.delegate = self
        self.addSubview(colorWheel)
        
        brightnessView = BrightnessView(frame: CGRect(x: centeredX, y: colorWheel.frame.maxY, width: colorWheelSize, height: brightnessViewHeight))
        brightnessView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        brightnessView.hue = hue
        brightnessView.saturation = saturation
        brightnessView.brightness = brightness
        brightnessView.delegate = self
        self.addSubview(brightnessView)
    }
    
    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        
        delegate?.colorPicker(self, didChangeColor: color)
    }
    
    func brightnessSelected(_ brightness: CGFloat) {
        self.brightness = brightness
        
        delegate?.colorPicker(self, didChangeColor: self.color)
    }

}
