//
//  PathView.swift
//  FancyCurveSlider
//
//  Created by Lenochka on 2/25/24.
//

import UIKit

class PathView: UIView {
    
    // MARK: Properties
    
    /// Width of the slider path
    private let lineWidth: CGFloat = 5
    /// View for representing thumb of the slider
    private var thumbView: ThumbView!
    
    /// Color used to tint the maximum track of the slider path.
    public var strokeMaxColor: UIColor = UIColor.darkGray
    /// Color used to tint the minimum track of the slider path.
    public var strokeMinColor: UIColor = UIColor.darkGray
    /// A Boolean value that determines whether the view is flipped.
    public var isFlipped: Bool = false
    /// A curve representing the slider path.
    public var sliderPath: SliderPathStyle!
    
    /// The slider’s current value. This value will be pinned to min/max.
    public var value: Double = 0.0 {
        didSet {
            setInitialThumpPosition(value: value)
            self.setNeedsDisplay()
        }
    }
    
    /// The minimum value of the slider.
    public var minimumValue: Double = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The maximum value of the slider.
    public var maximumValue: Double = 1.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// The thumb image being used to render the slider.
    public var thumbImage: UIImage? {
        didSet {
            thumbView.thumbImage = thumbImage
        }
    }
    
    /// The color used to tint the default thumb images.
    public var thumbColor: UIColor = .white {
        didSet{
            thumbView.thumbColor = thumbColor
            thumbView.tintColor = thumbColor            
        }
    }
    
    public func getSliderPath() -> SliderPathStyle {
        switch self.pathType {
        case .semiCircle:
            return SemiCirclePath(bounds: self.bounds, strokeWidth: 4, isFlipped: self.isFlipped)
        case .almostCircle:
            return AlmostCirclePath(bounds: self.bounds, strokeWidth: 4, isFlipped: self.isFlipped)
        case .crescentCircle:
            return CrescentCirclePath(bounds: self.bounds, strokeWidth: 4, isFlipped: self.isFlipped)
        }
    }
    
    var pathType: PathType = .semiCircle {
        didSet {
            sliderPath = getSliderPath()
            self.setNeedsDisplay()
        }
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    func commonInit() {
        sliderPath = getSliderPath()
        let thumbView = ThumbView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        thumbView.backgroundColor = .clear
        self.thumbView = thumbView
        if let thumbImage = self.thumbImage {
            thumbView.thumbImage = thumbImage
        }
        self.addSubview(thumbView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setInitialThumpPosition(value: self.value)
    }
    
    // MARK: Thumb View
    
    /// Set initial position of thump equal to value to display.
    /// For calculating the position of the thump, we need to calculate the ratio between the value and maximum possible value of the slider.
    /// - Parameter value: value to display
    func setInitialThumpPosition(value: Double) {
        sliderPath = getSliderPath()
        let percent = getScaledValueToPercent(value: value, 
                                              minValue: self.minimumValue,
                                              maxValue: self.maximumValue)

        thumbView.center = sliderPath.getThumbInitialPosition(percent: percent)
    }
    
    func moveThumbView(sliderPath: SliderPathStyle, translation: CGPoint, angle: Double) {
        thumbView.center = CGPoint(x:  translation.x, y: translation.y)
        
        let percent = sliderPath.getPercentForAngel(angle: angle)
        self.value = getScaledValueFromPercent(percent: percent,
                                               minValue: self.minimumValue,
                                               maxValue: self.maximumValue)
    }
    
    // MARK: Value Scaling
    
    /// Create a new percent of the slider path equal to the current value to dispay.
    /// - Parameter value: value to display.
    /// - Parameter minValue: minimum value of the slider.
    /// - Parameter maxValue: maximum value of the slider.
    /// - Returns: Percent `Double` of the slider path.
    func getScaledValueToPercent(value: Double, minValue: Double, maxValue: Double) -> Double {
        return (value - minValue) / (maxValue - minValue)
    }
    
    /// Create a new value equal to the current percent of the slider path.
    /// - Parameter percent: current persent of the slider path.
    /// - Parameter minValue: minimum value of the slider.
    /// - Parameter maxValue: maximum value of the slider.
    /// - Returns: Value `Double` equal to current percent of the slider path.
    func getScaledValueFromPercent(percent: Double, minValue: Double, maxValue: Double) -> Double {
        return percent * (maxValue - minValue) + minValue
    }
    
    // MARK: Draw path

    override func draw(_ rect: CGRect) {
        drawPath(path: self.sliderPath.path, color: self.strokeMaxColor)
        
        let percent = getScaledValueToPercent(value: self.value, 
                                              minValue: self.minimumValue,
                                              maxValue: self.maximumValue)
        let segmentSliderPath = self.sliderPath.getSegmentPath(for: percent, isFlipped: self.isFlipped)
        drawPath(path: segmentSliderPath, color: self.strokeMinColor)
        
    }
    
    /// Setup some parameters for drawing slider path curve.
    /// - Parameter path: Slider path.
    /// - Parameter color: Color of the slider path.
    private func drawPath(path: UIBezierPath, color: UIColor) {
        color.setStroke()
        path.lineCapStyle = .round
        path.lineWidth = lineWidth
        path.stroke()
    }
}

extension CGFloat {

    /// Translate angle value to radians.
    /// - Returns: Value `CGFloat` of the angle in radians.
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
