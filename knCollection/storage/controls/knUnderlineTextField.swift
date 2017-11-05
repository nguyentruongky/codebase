//
//  KTextField.swift
//  kLibrary
//
//  Created by Ky Nguyen on 8/25/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

class knUnderlineTextField: UITextField {

    fileprivate var underline : UIView!
    var underlineColor : UIColor = UIColor.darkGray {
        willSet(value) {
            underline.backgroundColor = value
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupControl()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }
    
    func setupControl() {
        underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underline)
        underline.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        underline.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        underline.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    override func becomeFirstResponder() -> Bool {
        underline.backgroundColor =  underlineColor
        super.becomeFirstResponder()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        underline.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        super.resignFirstResponder()
        return true
    }

    

}

