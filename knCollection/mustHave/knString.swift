//
//  StringExtension.swift
//  kLibrary
//
//  Created by Ky Nguyen on 1/25/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

extension String {

    func capitalizingFirstLetter() -> String {
        guard characters.count > 0 else { return self }
        
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    
    /**
     format some string in normal string.
     */

    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       font: UIFont = UIFont.systemFont(ofSize: 14),
                       color: UIColor = UIColor.black) -> NSAttributedString {

        let attributedString =
            NSMutableAttributedString(string: string,
                                      attributes: [
                                        NSAttributedStringKey.font: font,
                                        NSAttributedStringKey.foregroundColor: color])
        let boldFontAttribute = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }

    func formatParagraph(alignment: NSTextAlignment = NSTextAlignment.left, spacing: CGFloat = 7) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = alignment
        paragraphStyle.maximumLineHeight = 40

        let attributed = [NSAttributedStringKey.paragraphStyle:paragraphStyle]
        return NSAttributedString(string: self, attributes:attributed)
    }
    
    func strikethroughText() -> NSMutableAttributedString {

        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle,
                                     value: NSUnderlineStyle.styleSingle.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func estimateFrameForText(withFont font: UIFont, estimateSize: CGSize) -> CGRect {
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: estimateSize, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
    }
}

extension String {
    
    func formatThousandSeparator(_ separatorCharacter: String = " ") -> String {
        
        guard let numberFromString = Double(self) else { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = separatorCharacter
        formatter.roundingMode = .down
        formatter.maximumFractionDigits = 5
        var formattedString = formatter.string(from: NSNumber(value: numberFromString as Double))
        formattedString = formattedString != nil ? formattedString! : self
        
        if substring(from: 1) == "." {
            formattedString! += "."
        }
        
        return formattedString!
    }
    
    var length: Int { return characters.count }
    
    func isValidEmail() -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func splitString(_ separator: String) -> [String] {   
        return components(separatedBy: separator)
    }
    
    func substring(from: Int, to: Int) -> String {

        let start = index(startIndex, offsetBy: from)
        let end = index(endIndex, offsetBy: -(characters.count - to) + 1)
        let range = start ..< end
        return String(self[range])
    }

    func substring(from: Int) -> String {
        return String(suffix(from))
    }

    func substring(to: Int) -> String {
        return String(prefix(to))
    }
}

//
//  SwiftString.swift
//  SwiftString
//
//  Created by Andrew Mayne on 30/01/2016.
//  Copyright © 2016 Red Brick Labs. All rights reserved.
//

public extension String {
    
    // https://gist.github.com/stevenschobert/540dd33e828461916c11
    func camelize() -> String {
        let source = clean(" ", allOf: "-", "_")
        if source.characters.contains(" ") {
            let first = source.substring(to: source.characters.index(source.startIndex, offsetBy: 1))
            let cammel = NSString(format: "%@", (source as NSString).capitalized.replacingOccurrences(of: " ", with: "", options: [], range: nil)) as String
            let rest = String(cammel.characters.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercased.substring(to: source.characters.index(source.startIndex, offsetBy: 1))
            let rest = String(source.characters.dropFirst())
            return "\(first)\(rest)"
        }
    }
    
    func capitalize() -> String {
        return capitalized
    }
    
    func contains(_ substring: String) -> Bool {
        return range(of: substring) != nil
    }
    
    func chompLeft(_ prefix: String) -> String {
        if let prefixRange = range(of: prefix) {
            if prefixRange.upperBound >= endIndex {
                return String(self[startIndex..<prefixRange.lowerBound])
            } else {
                return String(self[prefixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    func chompRight(_ suffix: String) -> String {
        if let suffixRange = range(of: suffix, options: .backwards) {
            if suffixRange.upperBound >= endIndex {
                return String(self[startIndex..<suffixRange.lowerBound])
            } else {
                return String(self[suffixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    func collapseWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: " ")
    }
    
    func clean(_ with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
    
    func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    func endsWith(_ suffix: String) -> Bool {
        return hasSuffix(suffix)
    }

    func indexOf(_ substring: String) -> Int? {
        
        guard let range = range(of: substring) else { return nil }
        return characters.distance(from: startIndex, to: range.lowerBound)
    }
    
    func lastIndexOf(_ target: String) -> Int? {
        guard let range = range(of: target, options: .backwards) else { return nil }
        return characters.distance(from: startIndex, to: range.lowerBound)
    }
    
    func isAlpha() -> Bool {
        for chr in characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    func isAlphaNumeric() -> Bool {
        let alphaNumeric = CharacterSet.alphanumerics
        return components(separatedBy: alphaNumeric).joined(separator: "").length == 0
    }
    
    func isEmpty() -> Bool {
        return trim().length == 0
    }
    
    func isNotEmpty() -> Bool {
        return trim().length > 0
    }
    
    func isNumeric() -> Bool {
        return NumberFormatter().number(from: self) != nil
    }
    
    static func random(_ length: Int = 5) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.characters.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        
        return randomString
    }
}
