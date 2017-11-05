//
//  knUIColor.swift
//  kynguyenCodebase
//
//  Created by Ky Nguyen on 11/25/16.
//  Copyright © 2016 kynguyen. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     amount greater than 1 is darker, less than 1 is lighter
     */
    func adjustBrightness(_ amount:CGFloat) -> UIColor {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            brightness += (amount-1.0)
            brightness = max(min(brightness, 1.0), 0.0)
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        return self
    }
    
    static func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }
    
    static func color(value: CGFloat, alpha: CGFloat = 1) -> UIColor {
        let c = value / 255
        return UIColor(red: c, green: c, blue: c, alpha: alpha)
    }
    
    static func color(hex: String, alpha: CGFloat = 1) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
   
    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)?
    {
        var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        {
            return (red, green, blue, alpha)
        } else {
            return nil
        }
    }
}

