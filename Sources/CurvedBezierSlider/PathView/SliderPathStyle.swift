//
//  SliderPathStyle.swift
//  FancyCurveSlider
//
//  Created by Lenochka on 2/28/24.
//

import Foundation
import UIKit

protocol SliderPathStyle: SliderCalculation {
    var startAngle: CGFloat { get set }
    var endAngle: CGFloat { get set }
    var isFlipped: Bool { get }
    var radius: CGFloat { get }
    var arcDegree: CGFloat { get }
    var arcCenter: CGPoint { get }
    var startPoint: CGPoint { get }
    var endPoint: CGPoint { get }
    var path: UIBezierPath { get }
}

extension SliderPathStyle {
    mutating func getSegmentPath(for percent: Double = 0.5, isFlipped: Bool) -> UIBezierPath {
        if isFlipped {
            self.startAngle = self.endAngle - percent * self.arcDegree
        } else {
            self.endAngle = self.startAngle + percent * self.arcDegree
        }
    
        return UIBezierPath(arcCenter: self.arcCenter, 
                            radius: self.radius,
                            startAngle: self.startAngle.toRadians(),
                            endAngle: self.endAngle.toRadians(),
                            clockwise: true)
    }
}

struct SemiCirclePath: SliderPathStyle {
    var startAngle: CGFloat
    var endAngle: CGFloat
    let radius: CGFloat
    let arcDegree: CGFloat
    let arcCenter: CGPoint
    let startPoint: CGPoint
    let endPoint: CGPoint
    let path: UIBezierPath
    let isFlipped: Bool
    
    init(bounds: CGRect, percent: Double = 1, strokeWidth: CGFloat, isFlipped: Bool) {
        self.isFlipped = isFlipped
        self.startAngle = isFlipped ? 0 : 180
        self.endAngle = isFlipped ? 180 : 0
        self.arcDegree = 180
        let angle = (self.endAngle - self.startAngle) * (Double.pi / 360)
        self.radius = bounds.width > 2 * bounds.height ? bounds.height - 2 * strokeWidth : (bounds.width / 2) - 2 * strokeWidth
        let sectorHeight = self.radius
        let arcChord = 2 * self.radius
        let curve = 2 * self.radius * angle
        self.arcCenter = isFlipped ? CGPoint(x: bounds.midX, y: strokeWidth) : CGPoint(x: bounds.midX, y: bounds.height - strokeWidth)
        self.startPoint = isFlipped ? CGPoint(x: self.arcCenter.x - self.radius, y: self.arcCenter.y) : CGPoint(x: self.arcCenter.x - self.radius, y: self.arcCenter.y)
        self.endPoint = isFlipped ? CGPoint(x: self.arcCenter.x + self.radius, y: self.arcCenter.y) : CGPoint(x: self.arcCenter.x + self.radius, y: self.arcCenter.y)
        self.path = UIBezierPath(arcCenter: self.arcCenter, 
                                 radius: self.radius,
                                 startAngle: self.startAngle.toRadians(),
                                 endAngle: self.endAngle.toRadians(),
                                 clockwise: true)
    }
}

struct AlmostCirclePath: SliderPathStyle {
    var startAngle: CGFloat
    var endAngle: CGFloat
    let radius: CGFloat
    let arcDegree: CGFloat
    let arcCenter: CGPoint
    let startPoint: CGPoint
    let endPoint: CGPoint
    let path: UIBezierPath
    let isFlipped: Bool
    
    init(bounds: CGRect, percent: Double = 1, strokeWidth: CGFloat, isFlipped: Bool) {
        self.isFlipped = isFlipped
        self.startAngle = isFlipped ? 320 : 140
        self.endAngle = isFlipped ? 220 : 40
        self.arcDegree = 260
        let angle = (360 - self.startAngle + self.endAngle) * (Double.pi / 360)
        let sectorHeight = bounds.height - 2 * strokeWidth
        self.radius = ((2 * sectorHeight) / (1 - cos(angle))) / 2
        let arcChord = 2 * self.radius * sin(angle)
        let curve = 2 * self.radius * angle
        self.arcCenter = isFlipped ? CGPoint(x: bounds.midX, y: sectorHeight - self.radius + strokeWidth) : CGPoint(x: bounds.midX, y: self.radius + strokeWidth)
        self.startPoint = isFlipped ? CGPoint(x: self.arcCenter.x - arcChord / 2, y: strokeWidth) : CGPoint(x: self.arcCenter.x - arcChord / 2, y: sectorHeight + strokeWidth)
        self.endPoint = isFlipped ? CGPoint(x: self.arcCenter.x + arcChord / 2, y: strokeWidth) : CGPoint(x: self.arcCenter.x + arcChord / 2, y: sectorHeight + strokeWidth)
        self.path = UIBezierPath(arcCenter: self.arcCenter, 
                                 radius: self.radius,
                                 startAngle: self.startAngle.toRadians(),
                                 endAngle: self.endAngle.toRadians(),
                                 clockwise: true)
    }
}

struct CrescentCirclePath: SliderPathStyle {
    var startAngle: CGFloat
    var endAngle: CGFloat
    let radius: CGFloat
    let arcDegree: CGFloat
    let arcCenter: CGPoint
    let startPoint: CGPoint
    let endPoint: CGPoint
    let path: UIBezierPath
    let isFlipped: Bool
    
    init(bounds: CGRect, percent: Double = 1, strokeWidth: CGFloat, isFlipped: Bool) {
        self.isFlipped = isFlipped
        self.startAngle = isFlipped ? 40.0 : 220.0
        self.endAngle = isFlipped ? 140.0 : 320.0
        self.arcDegree = 100
        let angle = (self.endAngle - self.startAngle) * (Double.pi / 360)
        let arcChord = bounds.width - 2 * strokeWidth 
        let curve  = arcChord * (angle / sin(angle))
        self.radius = (curve / angle) / 2
        let sectorHeight = 2 * self.radius * ((1 - cos(angle)) / 2)
        self.arcCenter = isFlipped ? CGPoint(x: bounds.midX, y:bounds.minY + strokeWidth - (self.radius - sectorHeight)) : CGPoint(x: bounds.midX, y: bounds.maxY + self.radius - sectorHeight - strokeWidth)
        self.startPoint = isFlipped ? CGPoint(x: self.arcCenter.x - (arcChord / 2), y: self.arcCenter.y + (self.radius - sectorHeight)) : CGPoint(x: self.arcCenter.x - (arcChord / 2), y: self.arcCenter.y - (self.radius - sectorHeight))
        self.endPoint = isFlipped ? CGPoint(x: self.arcCenter.x + (arcChord / 2), y: self.arcCenter.y + (self.radius - sectorHeight)) : CGPoint(x: self.arcCenter.x + (arcChord / 2), y: self.arcCenter.y - (self.radius - sectorHeight))
        self.path = UIBezierPath(arcCenter: self.arcCenter, 
                                 radius: self.radius,
                                 startAngle: self.startAngle.toRadians(),
                                 endAngle: self.endAngle.toRadians(),
                                 clockwise: true)
    }
}

