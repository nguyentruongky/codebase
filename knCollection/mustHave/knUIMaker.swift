//
//  UIMaker.swift
//  knCollection
//
//  Created by Ky Nguyen on 10/12/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit


struct knUIMaker {
    
    static func makeLine(color: UIColor = UIColor.color(r: 242, g: 246, b: 254),
                         height: CGFloat = 1) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.height(height)
        return view
    }
    
    static func makeVerticalLine(color: UIColor = UIColor.color(r: 242, g: 246, b: 254),
                                 width: CGFloat = 1) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.width(width)
        return view
    }
    
    
    static func makeLabel(text: String? = nil, font: UIFont = .systemFont(ofSize: 15),
                          color: UIColor = .black, numberOfLines: Int = 1,
                          alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = color
        label.text = text
        label.numberOfLines = numberOfLines
        label.textAlignment = alignment
        return label
    }
    
    static func makeView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }
    
    static func makeImageView(image: UIImage? = nil,
                              contentMode: UIViewContentMode = .scaleAspectFit) -> UIImageView {
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }
    
    static func makeTextField(text: String? = nil, placeholder: String? = nil,
                              font: UIFont = .systemFont(ofSize: 15), color: UIColor = .black,
                              alignment: NSTextAlignment = .left) -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = font
        tf.textColor = color
        tf.text = text
        tf.placeholder = placeholder
        tf.textAlignment = alignment
        return tf
    }
    
    static func makeButton(title: String? = nil, titleColor: UIColor = .black,
                           font: UIFont? = nil, background: UIColor = .clear,
                           cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0,
                           borderColor: UIColor = .clear) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)

        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(titleColor.withAlphaComponent(0.4), for: .disabled)
        
        button.setBackgroundColor(color: background, forState: .normal)
        button.setBackgroundColor(color: background.withAlphaComponent(0.5), forState: .disabled)
        
        button.titleLabel?.font = font
        button.createRoundCorner(cornerRadius)
        button.createBorder(borderWidth, color: borderColor)
        return button
    }
    
    static func makeButton(image: UIImage? = nil) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }
}

