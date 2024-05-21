//
//  ThumbView.swift
//  FancyCurveSlider
//
//  Created by Lenochka on 2/26/24.
//

import UIKit

class ThumbView: UIImageView {
    
    // MARK: Properties
    /// The color used to tint the default thumb images.
    public var thumbColor: UIColor = .white {
        didSet{
            drawThumb()
        }
    }
    
    /// The thumb image being used to render the slider.
    public var thumbImage: UIImage? {
        didSet {
            if let thumbImage = self.thumbImage {
                self.layer.sublayers = nil
                self.image = thumbImage
            }
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
    
    /// Initialize thumb as an image or as round thumb.
    func commonInit() {
        if let thumbImage = self.thumbImage {
            self.image = thumbImage
        } 
        
        drawThumb()
    }
    
    // MARK: Draw
    
    /// Draw the thumb as a round with given color and stroke.
    private func drawThumb() {
        if thumbImage == nil {
            let ovalPath = UIBezierPath(ovalIn: CGRectMake(0.5, 0.5, self.bounds.height - 1, self.bounds.width - 1))
            let ovalPathLayer = CAShapeLayer()
            ovalPathLayer.frame = self.bounds
            ovalPathLayer.path = ovalPath.cgPath
            ovalPathLayer.fillColor = thumbColor.cgColor
            ovalPathLayer.strokeColor = UIColor.lightGray.cgColor
            ovalPathLayer.lineWidth = 0.5
            self.layer.addSublayer(ovalPathLayer)
        }
    }

}
