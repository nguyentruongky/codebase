//
//  knGistTextField.swift
//  Fixir
//
//  Created by Ky Nguyen on 3/5/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

class knGistTextField: UITextField {
    
    struct knFonts {
        
        private init() { }
        static let mediumFont = UIFont.systemFont(ofSize: 15)
        static let smallFont = UIFont.systemFont(ofSize: 12)
        
    }
    
    struct knColors {
        private init() { }
        
        static let kn_127 = UIColor.color(value: 127)
        static let kn_229 = UIColor.color(value: 229)
        static let kn_241_147_78 = UIColor.color(r: 241, g: 147, b: 78)
        static let kn_133_189_175 = UIColor.color(r: 133, g: 189, b: 175)
        static let kn_119_203_189 = UIColor.color(r: 119, g: 203, b: 189)
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var textColor: UIColor? {
        didSet {
            descriptionText.textColor = textColor?.withAlphaComponent(0.75)
        }
    }
    
    
    let descriptionText : UILabel = {
       
        let descriptionText = UILabel()
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.font = knFonts.smallFont
        descriptionText.textColor = knColors.kn_127
        descriptionText.isOpaque = true
        descriptionText.backgroundColor = .clear
        return descriptionText
    }()
    
    func setupView() {
        
        
        
        addSubview(descriptionText)
        descriptionText.topAnchor.constraint(equalTo: topAnchor, constant: -12).isActive = true
        descriptionText.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        descriptionText.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        let underline = UIView()
        underline.isOpaque = true
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = knColors.kn_127
        addSubview(underline)
        underline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        underline.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        underline.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 0.75).isActive = true

     
        addSubview(messageLabel)
        messageLabelTop = messageLabel.topAnchor.constraint(equalTo: underline.bottomAnchor, constant: 4)
        messageLabelTop?.isActive = true 
        messageLabel.leftAnchor.constraint(equalTo: underline.leftAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: underline.rightAnchor).isActive = true
    }
    
    let messageLabel : UILabel = {
        
        let label = UILabel()
        label.alpha = 0
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = knFonts.mediumFont
        label.textColor = .red
        label.text = ""
        label.textAlignment = .right
        return label
    }()
    
    
    var messageLabelTop: NSLayoutConstraint?
    var messageLabelVisible : Bool = false {
        didSet {
            
            messageLabelTop?.constant = messageLabelVisible ? 4 : -4
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                
                guard let _self = self else { return }
                _self.layoutIfNeeded()
                _self.messageLabel.alpha = _self.messageLabelVisible ? 1 : 0
            })
        }
    }
    
}
