//
//  OtherExtensions.swift
//  Coinhako
//
//  Created by Ky Nguyen on 10/12/17.
//  Copyright © 2017 Coinhako. All rights reserved.
//

import UIKit

extension Optional {
    func or<T>(defaultValue: T) -> T {
        switch(self) {
        case .none:
            return defaultValue
        case .some(let value):
            return value as! T
        }
    }
}



extension UIBarButtonItem {
    func format(font: UIFont, textColor: UIColor) {
        let attributes = [NSAttributedStringKey.font: font,
                          NSAttributedStringKey.foregroundColor: textColor]
        setTitleTextAttributes(attributes, for: UIControlState.normal)
    }
}

extension UILabel{
    func createSpaceBetweenLines(_ alignText: NSTextAlignment = NSTextAlignment.left, spacing: CGFloat = 7) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.maximumLineHeight = 40
        paragraphStyle.alignment = .left
        
        let ats = [NSAttributedStringKey.paragraphStyle:paragraphStyle]
        attributedText = NSAttributedString(string: self.text!, attributes:ats)
        textAlignment = alignText
    }
}



extension UIScrollView {
    
    func animateHeaderView(staticView: UIView, animatedView: UIView) {
        
        var headerTransform = CATransform3DIdentity
        let yOffset = contentOffset.y
        staticView.isHidden = yOffset < 0
        animatedView.isHidden = yOffset > 0
        if yOffset < 0 {
            let headerScaleFactor:CGFloat = -(yOffset) / animatedView.bounds.height
            let headerSizevariation = ((animatedView.bounds.height * (1.0 + headerScaleFactor)) - animatedView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            animatedView.layer.transform = headerTransform
        }
    }
    
}




extension UITableView {
    
    func resizeTableHeaderView(toSize size: CGSize) {
        
        guard let headerView = tableHeaderView else { return }
        headerView.frame.size = headerView.systemLayoutSizeFitting(size)
        tableHeaderView? = headerView
    }
    
}



extension UITextView {
    
    func wrapText(aroundRect rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        textContainer.exclusionPaths = [path]
    }
}






extension UserDefaults {
    func setString(key: String, value: String?) {
        setValue(value, forKey: key)
    }
    
    func getString(key: String) -> String? {
        return value(forKeyPath: key) as? String
    }
    
    func setBool(key: String, value: Bool?) {
        setValue(value, forKey: key)
    }
    
    func getBool(key: String, defaultValue: Bool = false) -> Bool {
        guard let value = value(forKeyPath: key) as? Bool else { return defaultValue }
        return value
    }
    
    func setInt(key: String, value: Int?) {
        setValue(value, forKey: key)
    }
    
    func getInt(key: String) -> Int? {
        return value(forKeyPath: key) as? Int
    }
}
