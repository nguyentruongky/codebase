//
//  InputAccessoryView.swift
//  knCollection
//
//  Created by Ky Nguyen on 10/12/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit


class marInputAccessoryView: knView {
    
    weak private var textField: UITextField?
    
    let titleLabel = knUIMaker.makeLabel()
    let doneButton = knUIMaker.makeButton(title: "Done")
    let cancelButton = knUIMaker.makeButton(title: "Cancel")
    
    override func setupView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        view.backgroundColor = UIColor.color(value: 246)
        
        view.addSubviews(views: cancelButton, titleLabel, doneButton)
        
        cancelButton.centerY(toView: view)
        cancelButton.left(toView: view, space: 10)
        
        titleLabel.center(toView: view)
        
        doneButton.centerY(toView: view)
        doneButton.right(toView: view, space: -10)
        
        addSubview(view)
        view.fill(toView: self)
    }
}
