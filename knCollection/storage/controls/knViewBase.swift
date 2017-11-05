//
//  KViewBase.swift
//  KeHoachPhuot
//
//  Created by Ky Nguyen on 1/27/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

class knViewBase: UIView {

    var view: UIView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    func xibSetup() {
        
        view = loadViewFromNib()
        
        view.frame = bounds
        
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        addSubview(view)
        
        setupView()
    }
    
    func loadViewFromNib() -> UIView {
        
        return loadSubViewFromNib(0)
    }
    
    func loadSubViewFromNib(_ viewIndex: Int) -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[viewIndex] as! UIView
        
        return view
    }
    
    func setupView() {
    }

}
