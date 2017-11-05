//
//  DotLoadingIndicator.swift
//  LoadingDotsAnimation
//
//  Created by Ky Nguyen on 9/14/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

class knDotLoadingIndicator: UIView {
    
    fileprivate let padding : CGFloat = 2
    fileprivate var loadingView = UIView()
    fileprivate lazy var dots = [UILabel]()
    fileprivate var _dotColor = UIColor.lightGray
    var dotColor : UIColor {
        get {
            return _dotColor
        }
        set(newValue) {
            _dotColor = newValue
            for dot in dots {
                dot.textColor = _dotColor
            }
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    fileprivate func setupView() {
        var xPos: CGFloat = 0
        var viewHeight : CGFloat = 0
        for _ in 0 ... 2 {
            let label = createDotLabel()
            viewHeight = label.frame.height
            label.frame.origin = CGPoint(x: xPos, y: 0)
            xPos += label.frame.width + padding
            
            loadingView.addSubview(label)
            dots.append(label)
        }
        
        layoutIfNeeded()
        loadingView.frame.size = CGSize(width: xPos, height: viewHeight)
        loadingView.center = center
        addSubview(loadingView)
        startAnimation()
    }
    
    fileprivate func createDotLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = dotColor
        label.text = "•"
        label.sizeToFit()
        return label
    }
    
    fileprivate func startAnimation() {
        for i in 0 ..< dots.count {
            animateDot(dots[i], delayTime: 0.2 * Double(i))
        }
    }
    
    fileprivate func animateDot(_ dotView: UIView, delayTime: Double) {
        
        dotView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.6, delay: delayTime, options: [.repeat, .autoreverse], animations: {
            dotView.transform = CGAffineTransform.identity
            }, completion: nil)
    }
}
