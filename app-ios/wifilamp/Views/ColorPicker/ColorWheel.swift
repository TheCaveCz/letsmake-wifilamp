//
//  ColorWheel.swift
//  SwiftHSVColorPicker
//
//  Created by johankasperi on 2015-08-20.
//  Modified by dzindra on 2017-10-15.
//

import UIKit


protocol ColorWheelDelegate: class {
    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat)
}

class ColorWheel: UIView {
    var brightness: CGFloat = 1.0 {
        didSet {
            brightnessLayer.fillColor = UIColor(white: 0, alpha: 1.0 - brightness).cgColor
            drawIndicator()
        }
    }
    var saturation: CGFloat = 1.0 {
        didSet {
            drawIndicator()
        }
    }
    var hue: CGFloat = 1.0 {
        didSet {
            drawIndicator()
        }
    }
    
    let indicatorLayer: CAShapeLayer
    var indicatorCircleRadius: CGFloat = 24 {
        didSet {
            updateIndicatorRadius()
        }
    }
    var whiteThreshold: CGFloat = 10
    
    weak var delegate: ColorWheelDelegate?

    
    private let wheelImage: UIImageView
    private let brightnessLayer: CAShapeLayer
    private let scale: CGFloat = UIScreen.main.scale


    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not implemented")
    }

    override init(frame: CGRect) {
        wheelImage = UIImageView(image: R.image.colorWheel())
        brightnessLayer = CAShapeLayer()
        indicatorLayer = CAShapeLayer()
        
        super.init(frame: frame)
        
        addSubview(wheelImage)
        
        brightnessLayer.actions = ["fillColor": NSNull()]
        self.layer.addSublayer(brightnessLayer)
        
        indicatorLayer.strokeColor = UIColor.lightGray.cgColor
        indicatorLayer.lineWidth = 2.0
        indicatorLayer.fillColor = nil
        indicatorLayer.actions = ["fillColor": NSNull(), "position": NSNull(), "bounds": NSNull()]
        indicatorLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        updateIndicatorRadius()
        
        self.layer.addSublayer(indicatorLayer)
    }
    
    private func updateIndicatorRadius() {
        indicatorLayer.bounds = CGRect(x: 0, y:0, width:indicatorCircleRadius, height:indicatorCircleRadius)
        indicatorLayer.path = UIBezierPath(ovalIn: indicatorLayer.bounds).cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        wheelImage.frame = self.bounds.insetBy(dx: 20, dy: 20)
        brightnessLayer.path = UIBezierPath(ovalIn: wheelImage.frame).cgPath
        drawIndicator()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        indicatorCircleRadius = 36
        touchHandler(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchHandler(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        indicatorCircleRadius = 24
        touchHandler(touches)
    }

    private func touchHandler(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let point = updateIndicatorCoordinate(touch.location(in: self.wheelImage))
        
        (hue, saturation) = hueSaturationAt(point: CGPoint(x: point.x * scale, y: point.y * scale))
                
        delegate?.hueAndSaturationSelected(hue, saturation: saturation)
    }

    private func updateIndicatorCoordinate(_ coord: CGPoint) -> CGPoint {
        // Making sure that the indicator can't get outside the Hue and Saturation wheel

        let radius: CGFloat = wheelImage.frame.width / 2
        let wheelLayerCenter: CGPoint = CGPoint(x: radius, y: radius)

        let dx: CGFloat = coord.x - wheelLayerCenter.x
        let dy: CGFloat = coord.y - wheelLayerCenter.y
        let distance: CGFloat = sqrt(dx * dx + dy * dy)
        var outputCoord: CGPoint = coord

        // If the touch coordinate is outside the radius of the wheel, transform it to the edge of the wheel with polar coordinates
        if (distance > radius) {
            let theta: CGFloat = atan2(dy, dx)
            outputCoord.x = radius * cos(theta) + wheelLayerCenter.x
            outputCoord.y = radius * sin(theta) + wheelLayerCenter.y
        }

        // If the touch coordinate is close to center, focus it to the very center at set the color to white
        if (distance < whiteThreshold) {
            outputCoord.x = wheelLayerCenter.x
            outputCoord.y = wheelLayerCenter.y
        }
        return outputCoord
    }
    
    private func drawIndicator() {
        let point = pointAt(hue: hue, saturation: saturation)
        indicatorLayer.position = CGPoint(x: point.x + wheelImage.frame.origin.x, y: point.y + wheelImage.frame.origin.y)
        
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        indicatorLayer.fillColor = color.cgColor
    }

    private func hueSaturationAt(point position: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
        // Get hue and saturation for a given point (x,y) in the wheel

        let c = wheelImage.bounds.width * scale / 2
        let dx = CGFloat(position.x - c) / c
        let dy = CGFloat(position.y - c) / c
        let d = sqrt(CGFloat(dx * dx + dy * dy))

        let saturation: CGFloat = d

        var hue: CGFloat
        if (d == 0) {
            hue = 0;
        } else {
            hue = acos(dx / d) / CGFloat.pi / 2.0
            if (dy < 0) {
                hue = 1.0 - hue
            }
        }
        return (hue, saturation)
    }

    private func pointAt(hue: CGFloat, saturation: CGFloat) -> CGPoint {
        // Get a point (x,y) in the wheel for a given hue and saturation

        let dimension = wheelImage.frame.width
        let radius: CGFloat = saturation * dimension / 2
        let x = dimension / 2 + radius * cos(hue * CGFloat.pi * 2);
        let y = dimension / 2 + radius * sin(hue * CGFloat.pi * 2);
        return CGPoint(x: x, y: y)
    }

}

