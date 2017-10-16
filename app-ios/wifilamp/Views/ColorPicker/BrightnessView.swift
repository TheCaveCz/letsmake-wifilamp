//
//  BrightnessView.swift
//  SwiftHSVColorPicker
//
//  Created by johankasperi on 2015-08-20.
//  Modified by dzindra on 2017-10-15.
//

import UIKit

protocol BrightnessViewDelegate: class {
   func brightnessSelected(_ brightness: CGFloat)
}

class BrightnessView: UIView {
    var hue: CGFloat = 0 {
        didSet {
            updateGradient()
        }
    }
    var saturation: CGFloat = 0 {
        didSet {
            updateGradient()
        }
    }
    var brightness: CGFloat = 0 {
        didSet {
            drawIndicator()
        }
    }
    
    var indicator: CAShapeLayer
    
    weak var delegate: BrightnessViewDelegate?
    
    private var colorLayer: CAGradientLayer
    
    
    override init(frame: CGRect) {
        colorLayer = CAGradientLayer()
        indicator = CAShapeLayer()
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        colorLayer = CAGradientLayer()
        colorLayer.locations = [0.0, 1.0]
        colorLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        colorLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        colorLayer.actions = ["colors": NSNull()]
        layer.insertSublayer(colorLayer, below: layer)
        
        // Add the indicator
        //indicator.strokeColor = indicatorColor
        indicator.fillColor = UIColor.lightGray.cgColor
        //indicator.lineWidth = indicatorBorderWidth
        indicator.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        indicator.actions = ["bounds": NSNull(), "position": NSNull()]
        layer.addSublayer(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorLayer.frame = self.bounds.insetBy(dx: 10, dy: 2)
        indicator.bounds = CGRect(x: 0, y: 0, width: 6, height: bounds.height)
        indicator.path = UIBezierPath(roundedRect: indicator.bounds, cornerRadius: indicator.bounds.width / 2).cgPath
        drawIndicator()
    }
    
    private func updateGradient() {
        colorLayer.colors = [
            UIColor.black.cgColor,
            UIColor(hue: hue, saturation: saturation, brightness: 1, alpha: 1).cgColor
        ]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }
    
    private func touchHandler(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }

        brightness = min(max(touch.location(in: self).x - colorLayer.frame.minX, 0), colorLayer.frame.width) / colorLayer.frame.width

        delegate?.brightnessSelected(brightness)
    }
    
    private func drawIndicator() {
        indicator.position = CGPoint(x: colorLayer.frame.minX + colorLayer.frame.width * brightness, y: bounds.height / 2)
    }
    
}
