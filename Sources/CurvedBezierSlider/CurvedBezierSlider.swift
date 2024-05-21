//
//  CurvedBezierSlider.swift
//  CurvedBezierSlider
//
//  Created by Lenochka on 2/22/24.
//

import UIKit

enum PathType: Int {
    case semiCircle
    case almostCircle
    case crescentCircle
}

@IBDesignable public class CurvedBezierSlider: UIControl {

    // MARK: IB Properties
    
    /// The slider’s current value. This value will be pinned to min/max.
    @IBInspectable public var value: Double {
        get {
            return pathView.value
        }
        set{
            if newValue > self.maximumValue {
                self.maximumValue = newValue
            }
            if newValue < self.minimumValue {
                self.minimumValue = newValue
            }
            pathView.value = newValue
        }
    }
    
    /// The minimum value of the slider. The current value may change if outside new min value.
    @IBInspectable public var minimumValue: Double {
        get {
            return pathView.minimumValue
        }
        set{
            if newValue > self.maximumValue {
                self.maximumValue = newValue
            }
            if value < newValue {
                self.value = newValue
            }
            pathView.minimumValue = newValue
        }
    }
    
    /// The maximum value of the slider. The current value may change if outside new max value.
    @IBInspectable public var maximumValue: Double {
        get {
            return pathView.maximumValue
        }
        set{
            if newValue < self.minimumValue {
                self.minimumValue = newValue
            }
            if value > newValue {
                self.value = newValue
            }
            pathView.maximumValue = newValue
        }
    }
    
    /// A Boolean value that determines whether the view is flipped. Set the derection of the curve - up or down.
    @IBInspectable public var isFlipped: Bool {
        get {
            return pathView.isFlipped
        }
        set {
            pathView.isFlipped = newValue
        }
    }
    
    /// The thumb image being used to render the slider.
    @IBInspectable public var thumbImage: UIImage? {
        get {
            return pathView.thumbImage
        }
        set {
            pathView.thumbImage = newValue
        }
    }
    
    /// The color used to tint the default thumb images.
    @IBInspectable public var thumbColor: UIColor  {
        get {
            return pathView.thumbColor
        }
        set {
            pathView.thumbColor = newValue
        }
    }
    
    /// Color used to tint the maximum track of the slider path.
    @IBInspectable public var strokeMaxColor: UIColor {
        get {
            return pathView.strokeMaxColor
        }
        set {
            pathView.strokeMaxColor = newValue
        }
    }
    
    /// Color used to tint the minimum track of the slider path.
    @IBInspectable public var strokeMinColor: UIColor {
        get {
            return pathView.strokeMinColor
        }
        set {
            pathView.strokeMinColor = newValue
        }
    }
    
    /// A Boolean value that determines whether scale should be hidden.
    @IBInspectable public var scaleIsHidden: Bool  {
        get {
            return scaleView?.isHidden ?? false
        }
        set {
            scaleView?.isHidden = newValue
        }
    }

    /// Color used to tint the scale.
    @IBInspectable public var scaleColor: UIColor  {
        get {
            return scaleView?.scaleColor ?? UIColor.lightGray
        }
        set {
            scaleView?.scaleColor = newValue
        }
    }
    
    /// Style of the slider path.
    var pathType: PathType = .semiCircle {
        didSet {
            self.pathView.pathType = pathType
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var pathAdapter: Int {
         get {
             return self.pathType.rawValue
         }
         set( shapeIndex) {
             guard let statusPath = PathType(rawValue: shapeIndex) else {
                 return
             }
             self.pathType = statusPath
             self.setNeedsDisplay()
         }
     }
     
    // MARK: Properties
    
    /// View depicting scale
    private var scaleView: ScaleView?
    /// View depicting path of the slider with thumb
    private var pathView: PathView!
    
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
        let pathView = PathView()
        pathView.backgroundColor = .clear
        pathView.translatesAutoresizingMaskIntoConstraints = false
        self.pathView = pathView
        self.pathView.isFlipped = self.isFlipped
        self.pathView.strokeMaxColor = self.strokeMaxColor
        self.pathView.strokeMinColor = self.strokeMinColor
        
        if let thumbImage = self.thumbImage {
            pathView.thumbImage = thumbImage
        }
        
        let dragThumbGesture = UIPanGestureRecognizer(target: self, action:#selector(self.dragThumb(_:)))
        pathView.addGestureRecognizer(dragThumbGesture)
        
        self.addSubview(pathView)
        
        // marging between pathView and superview
        let shift: Double = 15
        addConstraints([
            pathView.topAnchor.constraint(equalTo: self.topAnchor, constant: shift),
            pathView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -shift),
            pathView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: shift),
            pathView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -shift)
            ])
        
        let scaleView = ScaleView(scaleColor: self.scaleColor, pathCenterShift: shift)
        scaleView.backgroundColor = .clear
        scaleView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scaleView = scaleView
        self.insertSubview(scaleView, belowSubview: self.pathView)
        
        let shiftScale: Double = 0
        
        addConstraints([
            scaleView.topAnchor.constraint(equalTo: self.topAnchor, constant: shiftScale),
            scaleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -shiftScale),
            scaleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: shiftScale),
            scaleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -shiftScale)
            ])

        self.setNeedsDisplay()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        if let pathView = self.pathView {
            scaleView!.sliderPath = pathView.getSliderPath()
        }
    }
        
    @objc func dragThumb(_ sender: UIPanGestureRecognizer) {
        let point: CGPoint = sender.location(in: self.pathView)
        let thumbPositionResult = self.pathView.sliderPath.getThumbMovingPosition(point: point)
        
        if self.isFlipped {
            if thumbPositionResult.position.y > pathView.sliderPath.endPoint.y {
                pathView.moveThumbView(sliderPath: pathView.sliderPath, 
                                       translation: thumbPositionResult.position,
                                       angle: thumbPositionResult.angle)
            }
        } else {
            if thumbPositionResult.position.y < pathView.sliderPath.endPoint.y {
                pathView.moveThumbView(sliderPath: pathView.sliderPath, 
                                       translation: thumbPositionResult.position,
                                       angle: thumbPositionResult.angle)
            }
        }
        
        self.sendActions(for: .valueChanged)
    }

}


