//
//  ScaleView.swift
//  FancyCurveSlider
//
//  Created by Lenochka on 3/11/24.
//

import UIKit

/// Possible types of scale's dashs.
enum TickStyle {
    case short
    case long
}

class ScaleView: UIView {
    
    // MARK: Properties
    
    /// Color used to tint the scale.
    public var scaleColor: UIColor = UIColor.lightGray  { didSet { self.setNeedsDisplay() } }
    /// Slider path, used to calculate the position of tick marks along the curve.
    public var sliderPath: SliderPathStyle?     { didSet { self.setNeedsDisplay() } }
    /// Value for shifting center of curve along which tick marks are drawn. Equal to margin between superview and PathView.
    public var pathCenterShift: Double = 15    { didSet { self.setNeedsDisplay() } }
    /// Length of dash with `TickStyle` equal long.
    private let dashLong: CGFloat = 12
    /// Length of dash with `TickStyle` equal short.
    private let dashShort: CGFloat = 7
    /// Value of margin between dash and the slider path.
    private let tickMargin: CGFloat = 7
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(scaleColor: UIColor, sliderPath: SliderPathStyle? = nil, pathCenterShift: Double) {
        super.init(frame: .zero)
        
        self.scaleColor = scaleColor
        self.sliderPath = sliderPath
        self.pathCenterShift = pathCenterShift
    }
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        if let path1 = sliderPath {
            let startTick = path1.startAngle
            var value = startTick
            let period = ceil(path1.arcDegree / 21.0)
            for idx in stride(from: 0, through: 20.0, by: 1.0) {
                let style: TickStyle = idx.truncatingRemainder(dividingBy: 5) == 0 ? .long : .short
                addTick(at: value, style: style, to: path, sliderPath: path1)
                value += period
            }
        }

        scaleColor.setStroke()
        path.stroke()
    }
    
    /// Adding a tick mark along the slider path
    /// - Parameter value: value
    /// - Parameter style: type of tick mark
    /// - Parameter path: path to draw tick marks
    /// - Parameter sliderPath: slider path along which to draw path of tick marks
    func addTick(at value: CGFloat, style: TickStyle, to path: UIBezierPath, sliderPath: SliderPathStyle) {
        let angle = value
        let radius1 = sliderPath.radius + self.tickMargin
        let p1 = CGPoint(x: self.bounds.midX + cos(angle.toRadians()) * radius1,
                         y: sliderPath.arcCenter.y + sin(angle.toRadians()) * radius1 + pathCenterShift)

        var radius2 = sliderPath.radius + self.tickMargin
        if style == .short {
            radius2 += dashShort
        } else if style == .long {
            radius2 += dashLong
        }

        let p2 = CGPoint(x: self.bounds.midX + cos(angle.toRadians()) * radius2,
                         y: sliderPath.arcCenter.y + sin(angle.toRadians()) * radius2 + pathCenterShift)

        path.move(to: p1)
        path.addLine(to: p2)
    }

}
