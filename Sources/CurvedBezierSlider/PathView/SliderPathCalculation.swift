//
//  SliderPathCalculation.swift
//  FancyCurveSlider
//
//  Created by Lenochka on 4/3/24.
//

import Foundation
import UIKit

protocol SliderCalculation {
    func getThumbInitialPosition(percent: Double) -> CGPoint
    func getThumbMovingPosition(point: CGPoint) -> (position: CGPoint, angle: Double)
    func getPercentForAngel(angle: Double) -> Double
}

extension SliderPathStyle {
    /// Calculate the initial position of the thumb.
    /// - Parameter percent: a part of the whole path of the slider.
    /// - Returns : Initial position `CGpoint` of thumb
    func getThumbInitialPosition(percent: Double) -> CGPoint {
        let thumbAngle: CGFloat
        if isFlipped {
            thumbAngle = endAngle - percent * arcDegree
        } else {
            thumbAngle = startAngle + percent * arcDegree
        }

        let pointX2 = arcCenter.x + cos(thumbAngle.toRadians()) * radius
        let pointY2 = arcCenter.y + sin(thumbAngle.toRadians()) * radius
        return CGPoint(x: pointX2, y: pointY2)
    }
    
    /// Calculate the new position of the thumb when you move it.
    /// - Parameter point: the position of the thumb.
    /// - Returns : A new position `CGpoint` of thumb and angle `Double` of curve for this position
    func getThumbMovingPosition(point: CGPoint) -> (position: CGPoint, angle: Double) {
        let angleX = point.x - arcCenter.x
        let angleY = point.y - arcCenter.y
        let angle = atan2(angleY, angleX)
                
        let pointX = arcCenter.x + cos(angle) * radius
        let pointY = arcCenter.y + sin(angle) * radius
        return (CGPoint(x: pointX, y: pointY), angle)
    }
    
    /// Calculate what part of the slider path curve is equal to the given angle.
    /// - Parameter angle: the angle of of slider path curve for thumb position.
    /// - Returns : A part `Double` of slider path curve.
    func getPercentForAngel(angle: Double) -> Double {
        let originalAngleDegree = (angle *  180.0) / Double.pi
        var angleDegree = originalAngleDegree
        var percent = 0.0
        
        if isFlipped {
            if angleDegree < 0 {
                angleDegree = 360 - abs(angleDegree)
            }
            
            if angleDegree > 320 {
                angleDegree = (360 - angleDegree) * -1
            }
            percent = (endAngle - angleDegree) / arcDegree
        } else {
            if (originalAngleDegree < 90 && originalAngleDegree > 0) {
                angleDegree = 360 + originalAngleDegree
            }
            
            if angleDegree < 0 {
                angleDegree = 360 - abs(angleDegree)
            }
            percent = (angleDegree - startAngle) / arcDegree
        }
        
        return Double(round(100 * percent) / 100)
    }
}

