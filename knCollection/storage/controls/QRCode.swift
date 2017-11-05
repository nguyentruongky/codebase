//
//  QRCode.swift
//  QRCode
//
//  Created by Alexander Schuch on 25/01/15.
//  Copyright (c) 2015 Alexander Schuch. All rights reserved.
//

import UIKit

/// QRCode generator
public struct QRCode {
    
    /**
     The level of error correction.
     
     - Low:      7%
     - Medium:   15%
     - Quartile: 25%
     - High:     30%
     */
    public enum ErrorCorrection: String {
        case Low = "L"
        case Medium = "M"
        case Quartile = "Q"
        case High = "H"
    }
    
    /// Data contained in the generated QRCode
    public let data: Data
    
    /// Foreground color of the output
    /// Defaults to black
    public var color = CIColor(red: 0, green: 0, blue: 0)
    
    /// Background color of the output
    /// Defaults to white
    public var backgroundColor = CIColor(red: 1, green: 1, blue: 1)
    
    /// Size of the output
    public var size = CGSize(width: 200, height: 200)
    
    /// The error correction. The default value is `.Low`.
    public var errorCorrection = ErrorCorrection.Low
    
    // MARK: Init
    
    public init(_ data: Data) {
        self.data = data
    }
    
    public init?(_ string: String) {
        if let data = string.data(using: .isoLatin1) {
            self.data = data
        } else {
            return nil
        }
    }
    
    public init?(_ url: URL) {
        if let data = url.absoluteString.data(using: .isoLatin1) {
            self.data = data
        } else {
            return nil
        }
    }
    
    // MARK: Generate QRCode
    
    /// The QRCode's UIImage representation
    public var image: UIImage? {
        guard let ciImage = ciImage else { return nil }
        
        // Size
        let ciImageSize = ciImage.extent.size
        let widthRatio = size.width / ciImageSize.width
        let heightRatio = size.height / ciImageSize.height
        
        return ciImage.nonInterpolatedImage(withScale: Scale(dx: widthRatio, dy: heightRatio))
    }
    
    /// The QRCode's CIImage representation
    public var ciImage: CIImage? {
        // Generate QRCode
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        qrFilter.setDefaults()
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue(self.errorCorrection.rawValue, forKey: "inputCorrectionLevel")
        
        // Color code and background
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        
        colorFilter.setDefaults()
        colorFilter.setValue(qrFilter.outputImage, forKey: "inputImage")
        colorFilter.setValue(color, forKey: "inputColor0")
        colorFilter.setValue(backgroundColor, forKey: "inputColor1")
        
        return colorFilter.outputImage
    }
}





internal typealias Scale = (dx: CGFloat, dy: CGFloat)

internal extension CIImage {
    
    /// Creates an `UIImage` with interpolation disabled and scaled given a scale property
    ///
    /// - parameter withScale:  a given scale using to resize the result image
    ///
    /// - returns: an non-interpolated UIImage
    internal func nonInterpolatedImage(withScale scale: Scale = Scale(dx: 1, dy: 1)) -> UIImage? {
        guard let cgImage = CIContext(options: nil).createCGImage(self, from: self.extent) else { return nil }
        let size = CGSize(width: self.extent.size.width * scale.dx, height: self.extent.size.height * scale.dy)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .none
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}



public extension UIImageView {
    
    /// Creates a new image view with the given QRCode
    ///
    /// - parameter qrCode:      The QRCode to display in the image view
    public convenience init(qrCode: QRCode) {
        self.init(image: qrCode.image)
    }
    
}




public extension CIColor {
    
    /// Creates a CIColor from an rgba string
    ///
    /// E.g.
    ///     `aaa`
    ///     `ff00`
    ///     `bb00ff`
    ///     `aabbccff`
    ///
    /// - parameter rgba:    The hex string to parse in rgba format
    public convenience init(rgba: String) {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let scanner = Scanner(string: rgba)
        var hexValue: CUnsignedLongLong = 0
        
        if scanner.scanHexInt64(&hexValue) {
            let length = rgba.characters.count
            
            switch (length) {
            case 3:
                r = CGFloat((hexValue & 0xF00) >> 8)    / 15.0
                g = CGFloat((hexValue & 0x0F0) >> 4)    / 15.0
                b = CGFloat(hexValue & 0x00F)           / 15.0
            case 4:
                r = CGFloat((hexValue & 0xF000) >> 12)  / 15.0
                g = CGFloat((hexValue & 0x0F00) >> 8)   / 15.0
                b  = CGFloat((hexValue & 0x00F0) >> 4)  / 15.0
                a = CGFloat(hexValue & 0x000F)          / 15.0
            case 6:
                r = CGFloat((hexValue & 0xFF0000) >> 16)    / 255.0
                g = CGFloat((hexValue & 0x00FF00) >> 8)     / 255.0
                b  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                r = CGFloat((hexValue & 0xFF000000) >> 24)  / 255.0
                g = CGFloat((hexValue & 0x00FF0000) >> 16)  / 255.0
                b = CGFloat((hexValue & 0x0000FF00) >> 8)   / 255.0
                a = CGFloat(hexValue & 0x000000FF)          / 255.0
            default:
                print("Invalid number of values (\(length)) in HEX string. Make sure to enter 3, 4, 6 or 8 values. E.g. `aabbccff`")
            }
            
        } else {
            print("Invalid HEX value: \(rgba)")
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}








