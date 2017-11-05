//
//  UITextField.swift
//  kLibrary
//
//  Created by Ky Nguyen on 8/27/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setRightViewWithButtonTitle(_ title: String) -> UIButton {
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.blue, for: UIControlState())
        button.titleLabel?.frame = button.bounds
        button.sizeToFit()
        setRightViewWithView(button)
        return button
    }
    
    func setRightViewWithView(_ view: UIView) {
        
        rightView = view
        rightViewMode = UITextFieldViewMode.always
        rightView!.contentMode = UIViewContentMode.scaleAspectFit
        rightView!.clipsToBounds = true
    }
    
    func setRightViewWithButtonImage(_ image: UIImage) -> UIButton {
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        button.setImage(image, for: UIControlState())
        button.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        setRightViewWithView(button)
        return button
    }
    
    func setLeftViewWithImage(_ imge:UIImage){
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 33,height: 21))
        imgView.image = imge
        imgView.contentMode = .scaleAspectFill
        leftView = imgView
        leftViewMode = .always
        leftView!.contentMode = UIViewContentMode.scaleAspectFit
        leftView!.clipsToBounds = true
    }
    
    func changePlaceholderTextColor(_ color: UIColor) {
        
        guard let placeholder = placeholder else { return }
        let attributes = [NSAttributedStringKey.foregroundColor : color]
        attributedPlaceholder = NSAttributedString(string:placeholder, attributes: attributes)
    }
    
    func showHidePassword() -> String {
        isSecureTextEntry = !isSecureTextEntry
        becomeFirstResponder()
        return text!
    }
    
    func selectAllText() {
        selectedTextRange = textRange(from: beginningOfDocument, to: endOfDocument)
    }
}
