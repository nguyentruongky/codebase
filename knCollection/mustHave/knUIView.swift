//
//  UIView.swift
//  kLibrary
//
//  Created by Ky Nguyen on 8/27/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

extension UIView {
    
    func createBorder(_ width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    @objc func createRoundCorner(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func createCircleShape() {
        createRoundCorner(self.frame.size.width / 2)
    }
    
    func createImageFromView() -> UIImage {
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func clearSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    func setupGradientLayer(colors: [UIColor],
                            size: CGSize = .zero,
                            startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0,
                                     width: size.width == 0 ? bounds.size.width : size.width,
                                     height: size.height == 0 ? bounds.size.height : size.height)
        gradientLayer.colors = colors.map({ (uiColor) -> CGColor in
            return uiColor.cgColor
        })
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBorder(colors: [UIColor], width: CGFloat = 1) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: frame.size)
        gradient.colors = colors.map({ return $0.cgColor })
        
        let shape = CAShapeLayer()
        shape.lineWidth = 3
        shape.path = UIBezierPath(rect: bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        layer.addSublayer(gradient)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }


    func enable(_ value: Bool) {
        isUserInteractionEnabled = value
    }

}




extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func createRoundCorners(corners: UIRectCorner, radius: CGFloat) {
        _ = _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func createRoundCorners(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }

    @discardableResult
    private func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}

