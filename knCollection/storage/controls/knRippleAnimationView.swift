//
//  SonarAnimationView.swift
//  MapLocationAnimation
//
//  Created by Ky Nguyen on 9/14/16.
//  Copyright © 2016 Larry Natalicio. All rights reserved.
//

import UIKit

class knRippleAnimationView: UIView, CAAnimationDelegate {
    
    struct ColorPalette {
        static let green = UIColor(red:0.00, green:0.87, blue:0.71, alpha:1.0)
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        startRippleAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startRippleAnimation()
    }
    
    func startRippleAnimation() {
        createRippleAnimation(atTime: CACurrentMediaTime())
        createRippleAnimation(atTime: CACurrentMediaTime() + 0.92)
        createRippleAnimation(atTime: CACurrentMediaTime() + 1.84)
    }
    
    fileprivate func createRippleAnimation(atTime beginTime: CFTimeInterval) {
        
        prepareLayoutSize()
        let smallestCircle = UIBezierPath(arcCenter: center,
                                       radius: CGFloat(3),
                                       startAngle: CGFloat(0),
                                       endAngle:CGFloat(Double.pi * 2),
                                       clockwise: true)
        
        let biggestCircle = UIBezierPath(arcCenter: center,
                                         radius: CGFloat(80),
                                         startAngle: CGFloat(0),
                                         endAngle:CGFloat(Double.pi * 2),
                                         clockwise: true)
        
        let shapeLayer = createShapeWhenNoAnimation(fromPath: smallestCircle)
        layer.addSublayer(shapeLayer)
        
        let scaleAnimation = createScaleAnimation(fromPath: smallestCircle, toPath: biggestCircle)
        let fadeAnimation = createFadeAnimation(fromValue: 0.8, toValue: 0)
        let animationGroup = combineAnimations([scaleAnimation, fadeAnimation], atTime: beginTime)
        shapeLayer.add(animationGroup, forKey: "sonar")
    }
    
    fileprivate func prepareLayoutSize() {
        layoutIfNeeded()
    }
    fileprivate func createShapeWhenNoAnimation(fromPath path: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = ColorPalette.green.cgColor
        shapeLayer.fillColor = ColorPalette.green.cgColor
        shapeLayer.path = path.cgPath
        return shapeLayer
    }
    
    fileprivate func createScaleAnimation(fromPath smallestPath: UIBezierPath, toPath biggestPath: UIBezierPath) -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "path")
        scaleAnimation.fromValue = smallestPath.cgPath
        scaleAnimation.toValue = biggestPath.cgPath
        return scaleAnimation
    }
    
    fileprivate func createFadeAnimation(fromValue: CGFloat, toValue: CGFloat) -> CABasicAnimation {
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.8
        fade.toValue = 0
        return fade
    }
    
    fileprivate func combineAnimations(_ animations: [CABasicAnimation], atTime beginTime: Double = 0) -> CAAnimationGroup{
        let animationGroup = CAAnimationGroup()
        animationGroup.beginTime = beginTime
        animationGroup.animations = animations
        animationGroup.duration = 2.76
        animationGroup.repeatCount = .greatestFiniteMagnitude
        animationGroup.delegate = self
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        return animationGroup
    }
}
